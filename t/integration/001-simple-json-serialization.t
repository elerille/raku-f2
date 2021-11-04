#use Test;
use F2;
use F2::JSON;

=begin pod
Check if simple [de]serialization pass
=end pod

class MyParent {
    has $.from-parent;
}
class MyData
        is MyParent
        does JSON
{
    has Int $.my-number is required;
    has Str $.my-string is required("asdf");
    has Bool $.my-bool;
    has $!my-private is required is built;
}

my MyData $obj .= new: :12my-number, :my-string<abcd>, :!my-bool, my-private => "Str";

#is to-json($obj),
#        '{"my-number": 12,"my-string": "abcd","my-bool": false}';

my @a = 1, 2, 3, True, False, Nil, @(9, 8, 7);
say to-json @a;
say to-json Pair.new(123, "qwe");


say to-json($obj);
#say to-json(@$obj);
#say to-json(%(:$obj));

#is-deeply from-json(MyData, '{"my-number": 12,"my-string": "abcd","my-bool": false}'),
#        $obj;
#
#done-testing;
