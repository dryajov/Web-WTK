package Web::WTK::Component;

use namespace::autoclean;

use Moose;

use Web::WTK::Markup::Element;

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

has 'model' => (
	is   => 'rw',
	does => 'Web::WTK::Models::Model',
);
 
sub set_model_from {
	my ( $self, $val ) = @_;

	$self->model( Web::WTK::Models::Factory->get_model_from($val) );
}

# called during construction
# all components *have* to
# override this method in order
# to be able to construct them self.
# usually those components that are user
# defined or extended, would put the
# page/component logic here.
sub construct {

}

sub get_root_component {
	my $self   = shift;
	my $parent = $self->parent;

	while ( $parent->parent ) {
		$parent = $parent->parent
		  if defined $parent->parent;
	}

	return $parent;
}

sub render {
	my ( $self, $markup ) = @_;
#	if ( !$self->visible ) {
#		$markup->render_flag($Web::WTK::Markup::Element::RENDER_NONE);
#	}
	return $markup;
}

with 'Web::WTK::Roles::Renderable';
with 'Web::WTK::Component::Constructable';

__PACKAGE__->meta->make_immutable;
1;

