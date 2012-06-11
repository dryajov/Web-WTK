package Web::WTK::Component::Label;
use strict;
use warnings;

use Moose;

use Web::WTK::Util::Params;

extends 'Web::WTK::Component';

has 'text' => (
    is      => 'rw',
    isa     => 'Str',
);

sub render {
    my ( $self, $elm ) = @_;

    $elm->replace_body( $self->text );
    return $self->SUPER::render($elm);
}

__PACKAGE__->meta->make_immutable;
1;
