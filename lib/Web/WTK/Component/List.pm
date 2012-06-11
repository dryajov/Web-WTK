package Web::WTK::Component::List;

use Moose;
use Carp;

use Web::WTK::Markup::Element;

extends 'Web::WTK::Component';

has 'list' => (
    is       => 'rw',
    isa      => 'ArrayRef[Str]',
    required => 1,
);

sub render {
    my ( $self, $elm ) = @_;

    my $list = Web::WTK::Markup::Element->new( name => 'ul' );
    for my $entry ( @{ $self->list } ) {
        $list->child(
            Web::WTK::Markup::Element->new(
                name => 'li',
                body => [$entry],
            )
        );
    }

    $elm->replace_body($list);
    $self->SUPER::render($elm);

    return $elm;
}

__PACKAGE__->meta->make_immutable;
1;
