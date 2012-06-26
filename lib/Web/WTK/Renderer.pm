package Web::WTK::Renderer;

use Moose;

use Carp;

has 'markup' => (
	is  => 'rw',
	isa => 'Web::WTK::Markup::Element',
);

sub render {
	my $self = shift;
	croak "Method unimplemented by subclass!";
}

__PACKAGE__->meta->make_immutable;
1;
