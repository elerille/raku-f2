use Test;
#use F2;
#use F2::JSON;

#my $json = 'resources/amt.json'.IO.slurp;
#$json = '{"my-number": -12.0e+1,"my-string": "abcd\u0020","my-bool": false}';

#say from-json Any, $json;
#say "\x[1d11e]";
#say from-json Any, '"==> asdf\\u0020"';
#say from-json Any, '"==> asdf -- \ud834\udd1e"';


my $a := Proxy.new(
#        FETCH => method { say 'fetch' },
        STORE => method ($_) { say 'store ', $_ }
        );

$a = 'qwe';
say $a;

#class HTML {
#    has %!attributes is built;
#    has @!contents is built;
#    has $!name is built;
#
#    method new($name, *@contents, *%attributes) {
#        self.bless(:$name, :@contents, :%attributes)
#    }
#    method CALL-ME(*@contents, *%attributes) {
#        @!contents.push: |@contents;
#        %!attributes{%attributes.keys} = %attributes.values;
#        self;
#    }
#    method AT-KEY($key) {
#        with @!contents.grep(method {self ~~ HTML && $!name eq $key}) {
#            if +$_ == 1 { $_[0] }
#            else { $_ }
#        }
#    }
#    multi method FALLBACK($name) is rw {
#        %!attributes{$name};
#    }
#    method !say {
#        print '<'.indent($*indent), $!name;
#        if %!attributes {
#            print ' ';
#            print %!attributes.map({ .key ~ '=' ~ .value.Str.raku }).join(' ');
#        }
#        if @!contents {
#            say '>';
#            $*indent += $*tab-size;
#            for @!contents {
#                when HTML {
#                    $_!say
#                }
#                default {
#                    .say
#                }
#            }
#            $*indent -= $*tab-size;
#            say '</'.indent($*indent), $!name, '>';
#        } else {
#            say ' />';
#        }
#    }
#    method say {
#        my $*indent = 0;
#        my $*tab-size = 2;
#        self!say
#    }
#}
##sub H(*@a, *%_) {
##    HTML.new: |@a, |%_
##}
#
#constant term:<H> = class :: does Associative {
#    method AT-KEY($key) {
#        HTML.new: $key;
#    }
#}
#
#my $html = H<html>(H<body>(H<h1>("Mon titre")));
#
#$html.say;
#$html<body>.class = "asdf";
#$html.say;

done-testing;
