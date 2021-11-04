unit module F2;

role Serializable is export {
}

class StrHandle is IO::Handle {
    has $.data = "";
    submethod TWEAK {
        self.encoding: 'utf8';
    }
    submethod WRITE(IO::Handle:D: Blob:D \data --> Bool:D) {
        $!data ~= data.decode();
        True;
    }
    method gist() {
        $!data
    }
}

our sub properties(Serializable:D $obj,
                   :$local = True, #= only local attribute (not inherit attribute)
                   :$private = False, #= include private attribute
                   :$optional = True, #= include optional attribute without value
                   ) is export {
    lazy gather {
        for $obj.^attributes: :$local {
            next if .has_accessor.not && $private.not;
            my $value = .get_value($obj);
            next if $optional && .required.defined.not && $value.defined.not;
            take %(
                name => .name.substr(2),
                type => .type,
                :$value,
                required => .required.defined,
                deprecated => .?DEPRECATED.defined,
            );
        }
    }
}

our sub serializer(&callback,
                   \obj
                   )
        is export
{
    my $cache = StrHandle.new;
    my $out = $*OUT;
    $*OUT = $cache;
    callback(obj);
    $*OUT = $out;
    $cache;
}