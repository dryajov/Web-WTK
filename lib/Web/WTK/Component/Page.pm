package Web::WTK::Component::Page;

use Moose;

use Web::WTK::Markup::Stream;
use Web::WTK::Markup::ElementStream;

extends 'Web::WTK::Component::MarkupContainer';

has 'title' => (
	is   => 'rw',
	isa  => 'Str',
);

has 'parameters' => (
	is       => 'rw',
	isa      => 'Hash::MultiValue',
	required => 1,
);

has 'context' => (
	is       => 'rw',
	isa      => 'Web::WTK::Context',
	required => 1,
);

sub BUILDARGS {
	my ($class) = shift;

	my %params = @_ ? @_ : ();
	my $name = $class;
	$name =~ s/::/_/;
	$params{id} = lc $name;
	return \%params;
}

sub render {
	my $self = shift;

	my $markup = $self->markup;

	my $stream = Web::WTK::Markup::Stream->new( markup => $markup );
	my $elements = Web::WTK::Markup::ElementStream->new( stream => $stream );
	while ( my $elm = $elements->next ) {

		if ( $elm->name eq 'title' && $self->title ) {
			$elm->replace_body( $self->title );
		}
		elsif ( $elm->name eq 'body' ) {
			$self->SUPER::render($elm);    # render the body
			last;
		}

	}

	return $markup;
}

__PACKAGE__->meta->make_immutable;
1;

