package Web::WTK::Component;

use Moose;

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
no Moose;
1;

