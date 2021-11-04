unit module F2::JSON;
#use Grammar::Tracer;
use F2;

role JSON is Serializable is export {

}

sub json-serializer(\obj) {
    given obj {
        when Positional:D {
            print '[';
            my Bool $sep = False;
            for @$_ {
                if $sep { print ',' }
                else { $sep = True }
                json-serializer $_;
            }
            print ']';
        }
        when Associative:D {
            print '{';
            my Bool $sep = False;
            for $_.kv -> $k, $v {
                warn "Key need be a string for valid JSON" unless $v ~~ Str:D;
                if $sep { print ',' }
                else { $sep = True }
                json-serializer $k;
                print ':';
                json-serializer $v;
            }
            print '}';
        }
        when Str:D {
            print '"';
            for $_.comb {
                when '"' | '\\' { print '\\', $_ }
                when "\b" { print '\\b' }
                when "\f" { print '\\f' }
                when "\n" { print '\\n' }
                when "\r" { print '\\r' }
                when "\t" { print '\\t' }
                default { print $_ }
            }
            print '"';
        }
        when Bool:D { print $_ ?? 'true' !! 'false'; }
        when Real:D { print $_; }
        when Any:U { print 'null'; }
        when Serializable:D {
            print '{';
            my Bool $sep = False;
            for properties($_, :!local, :private,) -> $/ {
                if $sep { print ',' }
                else { $sep = True }
                json-serializer $<name>;
                print ':';
                json-serializer $<value>;
            }
            print '}';
        }
        default { die "Impossible to serialize ", $_.^name; }
    }
}

grammar JsonGrammar {
    token TOP {
        <value>
    }
    proto token value {*}
    rule value:type<object> {
        '{'
        <pair> * % ','
        '}'
    }
    rule value:type<array> {
        '['
        <value> * % ','
        ']'
    }
    token value:type<number> {
        '-'?
        [
        | '0'
        | <[1..9]> <[0..9]>*
        ]
        ['.' <[0..9]>+]?
        [<[eE]> <[+-]>? <[0..9]>+]?
    }
    token value:sym<true> { <sym> }
    token value:sym<false> { <sym> }
    token value:sym<null> { <sym> }


    rule pair {
        <key=.value:string> ':' <value>
    }

    token value:type<string> {
        '"'
        <( <char>* )>
        '"'
    }
    proto token char {*}
    token char:type<literal> { <-["\\]>+ }
    token char:type<escaped> { '\\' <( <["\\/]> )> }
    token char:type("\b") { '\\b' }
    token char:type("\f") { '\\f' }
    token char:type("\n") { '\\n' }
    token char:type("\r") { '\\r' }
    token char:type("\t") { '\\t' }
    token char:type<unicode> { '\\u' <( <xdigit> ** 4 )> }

    token ws {
        <[
        \x[20]
        \x[0A]
        \x[0D]
        \x[09]
        ]>*
    }
}
class JsonActions {
    method TOP($/) {
        make $<value>.made;
    }
    method value:type<object>($/) {
        make $<pair>».made.hash;
    }
    method value:type<array>($/) {
        make $<pair>».made;
    }
    method value:type<number>($/) {
        make +$/;
    }
    method value:sym<true>($/) {
        make True
    }
    method value:sym<false>($/) {
        make False
    }
    method value:sym<null>($/) {
        make Nil
    }
    method value:type<string>($/) {
        make ([~] $/<char>».made).decode('utf16');
    }

    method char:type<literal> ($/) {
        make $/.encode('utf16').Buf;
    }
    method char:type<escaped> ($/) {
        make ~$/.encode('utf16').Buf;
    }
    method char:type("\b")($/) {
        make "\b".encode('utf16').Buf;
    }
    method char:type("\f")($/) {
        make "\f".encode('utf16').Buf;
    }
    method char:type("\n")($/) {
        make "\n".encode('utf16').Buf;
    }
    method char:type("\r")($/) {
        make "\r".encode('utf16').Buf;
    }
    method char:type("\t")($/) {
        make "\t".encode('utf16').Buf;
    }
    method char:type<unicode>($/) {
        make buf16.new(:16(~$/));
    }

    method pair($/) {
        make $<key>.made => $<value>.made;
    }
}

our sub to-json(\obj) is export {
    serializer
            &json-serializer,
            obj;
}

our sub from-json(Any:U $type, Str:D $data) is export {
    JsonGrammar.parse($data, actions => JsonActions.new).made;
}