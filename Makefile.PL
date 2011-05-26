# Pragmas.
use strict;
use warnings;

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Špaček <skim@cpan.org>',
	'EXE_FILES' => [
		'bin/pyx_stack',
	],
	'NAME' => 'PYX',
	'PREREQ_PM' => {
		'Class::Utils' => 0.01,
		'Error::Pure' => 0.01,
		'PYX::Parser' => 0.01,
	},
	'VERSION_FROM' => 'Stack.pm',
	'test' => {
		'TESTS' => 't/PYX::Stack/*.t',
	},
);
