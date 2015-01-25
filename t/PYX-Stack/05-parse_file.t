# Pragmas.
use strict;
use warnings;

# Modules.
use File::Object;
use PYX::Stack;
use Test::More 'tests' => 2;
use Test::NoWarnings;
use Test::Output;

# Directories.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $obj = PYX::Stack->new(
	'verbose' => 1,
);
my $right_ret = <<'END';
xml
xml/xml2
xml/xml2/xml3
xml/xml2
xml
END
stdout_is(
	sub {
		$obj->parse_file($data_dir->file('ex1.pyx')->s);
		return;
	},
	$right_ret,
	'Simple stack tree.',
);
