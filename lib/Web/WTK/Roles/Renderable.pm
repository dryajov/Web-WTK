package Web::WTK::Roles::Renderable;

use namespace::autoclean;

use Moose::Role;

has 'rendered' => (
	is      => 'rw',
	isa     => 'Bool',
	default => 0,
);

# called right before rendering
# gets the parameters that render reseives
sub on_before_render { }

# called right after rendering
# gets the parameters that render reseives
sub on_after_render { }

# make sure render is
# implemented by components
requires 'render';

requires 'elm';

# just set the rendered flag
around 'render' => sub {
	my $orig = shift;
	my $self = shift;

	$self->on_before_render(@_);

	my $result;
	if ( !$self->rendered ) {
		$result = $self->$orig(@_);
		$self->elm($result);
	}
	else {
		$result = $self->elm;
	}

	$self->on_after_render(@_);
	$self->rendered(1);

	return $result;
};

1;
