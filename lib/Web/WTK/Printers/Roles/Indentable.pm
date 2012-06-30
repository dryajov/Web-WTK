package Web::WTK::Printers::Roles::Indentable;

use Moose::Role;

with 'Web::WTK::Printers::Roles::Printable';

has 'indent' => (
	is  => 'rw',
	isa => 'Bool',
);

has 'indent_char' => (
	is      => 'rw',
	isa     => 'Str',
	default => sub { '    ' },
	lazy    => 1,
);

has 'indent_break_char' => (
	is      => 'rw',
	isa     => 'Str',
	default => sub { "\n" },
	lazy    => 1,
);

has '_indent_level' => (
	is      => 'rw',
	isa     => 'Int',
	default => sub { 0 },
	lazy    => 1,
);

has '_prev_indent_level' => (
	is      => 'rw',
	isa     => 'Int',
	default => sub { 0 },
	lazy    => 1,
);

requires '_generate_str_content';    # generate the content

around '_generate_str_content' => sub {
	my $orig = shift;
	my $self = shift;

	$self->_indent_level( $self->_indent_level + 1 );
	my $content = $self->$orig(@_);
	$self->_indent_level( $self->_indent_level - 1 );

	if ( $self->_prev_indent_level < $self->_indent_level ) {
		$content = $content . $self->indent_break_char;
		$content = $content . ( $self->indent_char x $self->_indent_level );
	}
	elsif ( $self->_prev_indent_level > $self->_indent_level ) {
		$content = ( $self->indent_char x $self->_indent_level ) . $content;
		$content = $self->indent_break_char . $content;
	}
	$self->_prev_indent_level( $self->_indent_level );

	return $content;
};

no Moose;
1;
