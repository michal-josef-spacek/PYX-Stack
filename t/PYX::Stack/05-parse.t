# Modules.
use File::Object;
use PYX::Stack;
use Test::More 'tests' => 1;

# Directories.
my $data_dir = File::Object->new->up->dir('data');

# Include helpers.
do File::Object->new->up->file('get_stdout.inc')->s;

print "Testing: parse_file() method.\n";
my $obj = PYX::Stack->new(
	'verbose' => 1,
);
my $ret = get_stdout($obj, $data_dir->file('example8.pyx')->s);
my $right_ret = <<'END';
xml
xml/xml2
xml/xml2/xml3
xml/xml2
xml
END
is($ret, $right_ret);
