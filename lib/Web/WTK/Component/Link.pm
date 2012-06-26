package Web::WTK::Component::Link;
use strict;
use warnings;

use Moose;

extends 'Web::WTK::Component';
with 'Web::WTK::Roles::Addressable';

has 'text' => (
    is  => 'rw',
    isa => 'Str',
);

has 'href' => (
    is  => 'rw',
    isa => 'Str'
);

sub render {
    my ( $self, $elm ) = @_;

    $elm->replace_body( $self->text );
    $elm->attr( "href", $self->href );
    $elm->name("a");
    return $self->SUPER::render($elm);
}

__PACKAGE__->meta->make_immutable;
1;
