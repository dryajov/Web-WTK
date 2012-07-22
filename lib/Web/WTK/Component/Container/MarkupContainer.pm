package Web::WTK::Component::Container::MarkupContainer;

use namespace::autoclean;

use Moose;

use Web::WTK::Parser::XML::SAX::Parser;
use Web::WTK::Markup::Stream;
use Web::WTK::Markup::ElementStream;
use Web::WTK::ResourceLoader::ResourceFactory;

extends 'Web::WTK::Component::Container';

has 'markup' => (
	is      => 'ro',
	isa     => 'Web::WTK::Markup::Element',
	builder => '_get_markup',
	lazy    => 1,
);

sub _get_markup {
	my $self = shift;
	
	return Web::WTK::ResourceLoader::ResourceFactory->load_markup( ref $self );
}

__PACKAGE__->meta->make_immutable;
1;

