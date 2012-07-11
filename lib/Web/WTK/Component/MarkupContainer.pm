package Web::WTK::Component::MarkupContainer;

use Moose;

use Web::WTK::Parser::XML::SAX::Parser;
use Web::WTK::Markup::Stream;
use Web::WTK::Markup::ElementStream;
use Web::WTK::Resolver::ClassToMarkupResource;

extends 'Web::WTK::Component::Container';

has 'markup' => (
	is      => 'ro',
	isa     => 'Web::WTK::Markup::Element',
	builder => '_get_markup',
	lazy    => 1,
);

has 'parser' => (
	is  => 'rw',
	isa => 'Web::WTK::Parser::XML::SAX::Parser',
);

has 'handle' => (
	is  => 'rw',
	isa => 'IO::Handle',
);

sub _get_markup {
	my ( $self, $params ) = @_;

	# TODO: Need to change the bellow code to use some sort of factory to
	# return the correct markup based on the current configuration
	my $resource =
	  Web::WTK::Resolver::ClassToMarkupResource->new( class => ref $self );

	$self->handle( $resource->open );
	$self->parser( Web::WTK::Parser::XML::SAX::Parser->new() );

	return $self->parser->parse( $self->handle );
}

__PACKAGE__->meta->make_immutable;
1;

