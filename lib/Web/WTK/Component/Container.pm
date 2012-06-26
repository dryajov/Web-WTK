package Web::WTK::Component::Container;

use Moose;

extends 'Web::WTK::Component';

use Web::WTK::Exception::MarkupExceptions;
use Try::Tiny;

has 'children' => (
    is      => 'ro',
    isa     => 'ArrayRef[Web::WTK::Component]',
    default => sub { [] },
    lazy    => 1,
);

sub iterator {
    my $self = shift;

    my $pos = 0;
    my $end = $#{ $self->children };
    return sub {
        return if $pos++ >= $end;
        return $self->children->[$pos];
    };
}

sub get_component_by_id {
    my $self = shift;
    my $id   = shift;

    my $found = undef;
    for my $component ( @{ $self->children } ) {
        if ( $component->isa(__PACKAGE__) ) {
            last if ( $found = $component->get_component_by_id($id) );
        }

        if ( $component->id eq $id ) {
            $found = $component;
            last;
        }
    }

    return $found;
}

sub add {
    my ( $self, $component ) = @_;

    push @{ $self->children }, $component;
    $component->parent($self);

    return;
}

sub render {
    my ( $self, $markup ) = @_;

    my $iterator = $markup->iterator();

    my $stream = Web::WTK::Markup::Stream->new( markup => $markup );
    my $elements = Web::WTK::Markup::ElementStream->new( stream => $stream );

    while ( my $elm = $elements->next ) {
        my $id = $elm->id() || next;
        my $component = $self->get_component_by_id($id);
        if ($component) {
            $elm->component($component);
            $component->render($elm);
        }
    }

    return $self->SUPER::render($markup);
}

__PACKAGE__->meta->make_immutable;
1;

