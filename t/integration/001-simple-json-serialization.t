use Test;
use F2::JSON;

=begin pod
Check if simple [de]serialization pass
=end pod

class MyData
{
    has Int $.my-number;
    has Str $.my-string;
    has Bool $.my-bool;
}

my MyData $obj .= new: :12my-number, :my-string<abcd>, :!my-bool;

is to-json($obj),
        '{"my-number": 12,"my-string": "abcd","my-bool": false}';

is-deeply from-json(MyData, '{"my-number": 12,"my-string": "abcd","my-bool": false}'),
        $obj;

done-testing;
