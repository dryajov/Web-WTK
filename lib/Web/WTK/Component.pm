package Web::WTK::Component;

use namespace::autoclean;

use Moose;

use Web::WTK::Markup::Element;

with 'Web::WTK::Roles::Renderable';

has 'parent' => (
	is       => 'rw',
	isa      => 'Web::WTK::Component',
	weak_ref => 1,
);

has 'visible' => (
	is      => 'rw',
	isa     => 'Bool',
	default => 1,
);

has 'render_container_tag' => (
	is      => 'rw',
	isa     => 'Bool',
	default => 1,
);

has 'id' => (
	is       => 'rw',
	isa      => 'Str',
	required => 1
);

has 'elm' => (
	is       => 'rw',
	isa      => 'Web::WTK::Markup::Element',
	weak_ref => 1,
);

sub get_root_component {
	my $self   = shift;
	my $parent = $self->parent;
	while ( $parent->parent ) {
		if ( defined $parent->parent ) {
			$parent = $parent->parent;
		}
	}
	return $parent;
}

sub render {
	my ( $self, $markup ) = @_;
	if ( !$self->rendered ) {
		if ( !$self->visible ) {
			$markup->render_flag($Web::WTK::Markup::Element::RENDER_NONE);
		}
	}

	return $markup;
}

__PACKAGE__->meta->make_immutable;
1;

