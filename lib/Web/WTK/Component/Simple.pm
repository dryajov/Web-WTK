package Web::WTK::Component::Simple;

use namespace::autoclean;

use Moose;
use Carp;

use Web::WTK::Markup::Element;

extends 'Web::WTK::Component';

has 'page' => (
	is      => 'rw',
	isa     => 'Web::WTK::Component::Container::Page',
	lazy    => 1,
	default => sub { shift->get_root_component },
);

__PACKAGE__->meta->make_immutable;
1;
