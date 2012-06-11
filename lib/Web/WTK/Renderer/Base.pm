package Web::WTK::Renderer::Base;

use Moose;

use Carp;

has 'markup' => (
    is  => 'rw',
    isa => 'Web::WTK::Markup::Element',
);

sub render {
    my $self = shift;
    croak "Method Unimplemented!";
}

__PACKAGE__->meta->make_immutable;
1;
