package PYX::Stack;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use PYX::Parser;

# Version.
our $VERSION = 0.01;

# Global variables.
our $STACK;
our $VERBOSE;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Output handler.
	$self->{'output_handler'} = \*STDOUT;

	# Verbose.
	$self->{'verbose'} = 0;

	# Process params.
	set_params($self, @params);

	# PYX::Parser object.
	$self->{'pyx_parser'} = PYX::Parser->new(
		'end_tag' => \&_end_tag,
		'final' => \&_final,
		'output_handler' => $self->{'output_handler'},
		'start_tag' => \&_start_tag,
	);

	# Tag values.
	$STACK = [];

	# Verbose.
	$VERBOSE = $self->{'verbose'};

	# Object.
	return $self;
}

# Parse pyx text or array of pyx text.
sub parse {
	my ($self, $pyx, $out) = @_;
	$self->{'pyx_parser'}->parse($pyx, $out);
	return;
}

# Parse file with pyx text.
sub parse_file {
	my ($self, $file, $out) = @_;
	$self->{'pyx_parser'}->parse_file($file, $out);
	return;
}

# Parse from handler.
sub parse_handler {
	my ($self, $input_file_handler, $out) = @_;
	$self->{'pyx_parser'}->parse_handler($input_file_handler, $out);
	return;
}

# End of tag.
sub _end_tag {
	my ($pyx_parser_obj, $tag) = @_;
	my $out = $pyx_parser_obj->{'output_handler'};
	if ($STACK->[-1] eq $tag) {
		pop @{$STACK};
	}
	if ($VERBOSE && @{$STACK} > 0) {
		print {$out} join('/', @{$STACK}), "\n";
	}
	return;
}

# Finalize.
sub _final {
	my $pyx_parser_obj = shift;
	if (@{$STACK} > 0) {
		err 'Stack has some elements.';
	}
	return;
}

# Start of tag.
sub _start_tag {
	my ($pyx_parser_obj, $tag) = @_;
	my $out = $pyx_parser_obj->{'output_handler'};
	push @{$STACK}, $tag;
	if ($VERBOSE) {
		print {$out} join('/', @{$STACK}), "\n";
	}
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

PYX::Stack - TODO

=head1 SYNOPSIS

TODO

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item * C<output_handler>

TODO

=item * C<verbose>

TODO

=back

=item C<parse()>

TODO

=item C<parse_file()>

TODO

=item C<parse_handler()>

TODO

=back

=head1 ERRORS

 Mine:
   TODO

 From Class::Utils::set_params():
   Unknown parameter '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use PYX::Stack;

 # PYX::Stack object.
 my $pyx = PYX::Stack->new(
         TODO
 );

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<PYX::Parser>.

=head1 SEE ALSO

L<App::PYX::Stack>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>.

=head1 LICENSE AND COPYRIGHT

BSD 2-Clause License

=head1 VERSION

0.01

=cut
