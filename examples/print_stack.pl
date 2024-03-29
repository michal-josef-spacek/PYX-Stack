#!/usr/bin/env perl

use strict;
use warnings;

use PYX::Stack;

# Example data.
my $pyx = <<'END';
(begin
(middle
(end
-data
)end
)middle
)begin
END

# PYX::Stack object.
my $obj = PYX::Stack->new(
        'verbose' => 1,
);

# Parse.
$obj->parse($pyx);

# Output:
# begin
# begin/middle
# begin/middle/end
# begin/middle
# begin