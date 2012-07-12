package Web::WTK::Component::Simple::Label;

use namespace::autoclean;

use Moose;

extends 'Web::WTK::Component::Simple';

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
