package Web::WTK::Component::Container::MarkupContainer;

use namespace::autoclean;

use Moose;

use Web::WTK::Parser::XML::SAX::Parser;
use Web::WTK::Markup::Stream;
use Web::WTK::Markup::ElementStream;
use Web::WTK::Resolver::ClassToMarkupResource;

extends 'Web::WTK::Component::Container';
with 'Web::WTK::Component::Construct';

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

sub bootstrap {
	my ($self) = @_;

	my $markup   = $self->markup;
	my $iterator = $markup->iterator();

	my $stream = Web::WTK::Markup::Stream->new( markup => $markup );
	my $elements = Web::WTK::Markup::ElementStream->new( stream => $stream );

	while ( my $elm = $elements->next ) {
		my $id = $elm->id || next;
		my $component = $self->get_component_by_id($id);
		if ($component) {
			$elm->component($component);
			$component->elm($elm);
			if ( eval { $component->isa(__PACKAGE__) } ) {
				$component->bootstrap($elm);
			}
		}
	}

	return;
}

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

