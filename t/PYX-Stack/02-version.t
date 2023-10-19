use strict;
use warnings;

use PYX::Stack;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($PYX::Stack::VERSION, 0.07, 'Version.');
