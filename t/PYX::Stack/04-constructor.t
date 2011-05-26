# Modules.
use English qw(-no_match_vars);
use PYX::Stack;
use Test::More 'tests' => 2;

eval {
	PYX::Stack->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

eval {
	PYX::Stack->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");
