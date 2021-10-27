use Test;

=begin pod
Test if module can be correctly loaded
=end pod

plan 2;
use-ok 'F2';
use-ok 'F2::JSON';
done-testing;
