package Web::WTK::Component::Repeater;

use Moose;
use Carp;

use Web::WTK::Markup::Element;

extends 'Web::WTK::Component';

has 'elements' => (
    is       => 'rw',
    isa      => 'ArrayRef[Str]',
    required => 1,
);

sub render {
    my ( $self, $elm ) = @_;

    $elm->clear_body;
    for my $data (@{ $self->elements }) {
        my $clone = $elm->clone;
        $clone->replace_body($data);
        $clone->remove_attr("wtk-id");
        $elm->child($clone);
    }
    
    $self->SUPER::render($elm);

    return $elm;
}

__PACKAGE__->meta->make_immutable;
1;
