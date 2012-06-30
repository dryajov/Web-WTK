package Web::WTK::Roles::Renderable;

use Moose::Role;

has 'rendered' => (
	is      => 'rw',
	isa     => 'Bool',
	default => 0,
);

# called inside the BUILD method
# used to contruct the component
sub construct { }

# called right before rendering
sub on_before_render { }

# called right after rendering
sub on_after_render { }

sub BUILD {
	my $self = shift;
	$self->construct(@_);
};

# make sure render is 
# implemented by components
requires 'render';

# just set the rendered flag
around 'render' => sub {
	my $orig = shift;
	my $self = shift;

	$self->on_before_render(@_);
	my $result = $self->$orig(@_);
	$self->on_after_render(@_);
	$self->rendered(1);

	return $result;
};

no Moose::Role;
1;
