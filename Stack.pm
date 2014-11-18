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

PYX::Stack - Processing PYX data or file and process element stack.

=head1 SYNOPSIS

 use PYX::Stack;
 my $obj = PYX::Stack->new(%parameters);
 $obj->parse($pyx, $out);
 $obj->parse_file($input_file, $out);
 $obj->parse_handle($input_file_handler, $out);

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item * C<output_handler>

 Output handler.
 Default value is \*STDOUT.

=item * C<verbose>

 Verbose flag.
 If set, each start element prints information to 'output_handler'.
 Default value is 0.

=back

=item C<parse($pyx[, $out])>

 Parse PYX text or array of PYX text.
 If $out not present, use 'output_handler'.
 Returns undef.

=item C<parse_file($input_file[, $out])>

 Parse file with PYX data.
 If $out not present, use 'output_handler'.
 Returns undef.

=item C<parse_handler($input_file_handler[, $out])>

 Parse PYX handler.
 If $out not present, use 'output_handler'.
 Returns undef.

=back

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

 parse():
         Stack has some elements.

 parse_file():
         Stack has some elements.

 parse_handler():
         Stack has some elements.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
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

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure;
 use PYX::Stack;

 # Error output.
 $Error::Pure::TYPE = 'Print';

 # Example data.
 my $pyx = <<'END';
 (begin
 (middle
 (end
 -data
 )middle
 )begin
 END

 # PYX::Stack object.
 my $obj = PYX::Stack->new;

 # Parse.
 $obj->parse($pyx);

 # Output:
 # PYX::Stack: Stack has some elements.

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
