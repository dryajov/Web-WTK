package Web::WTK::Markup::Stream;

use Moose;

# the marup elements tree
has 'markup' => (
    is       => 'rw',
    isa      => 'Web::WTK::Markup::Element',
    required => 1,
);

# this stream uses a stack
# to hold the current markup iterator
has 'iterators' => (
    is      => 'rw',
    isa     => 'ArrayRef[CodeRef]',
    lazy    => 1,
    default => sub { [] },
);

sub BUILD {
    my ( $self, $params ) = @_;

    push @{ $self->iterators },
      $params->{markup}->iterator;    # push the topmost iterator
}

sub next {
    my $self = shift;

    my $iterator = $self->{iterators}->[-1];

    my $elm;
    if ($iterator) {
        $elm = $iterator->();         # get the next element

        # if the current iterator is at the end,
        # pop the next in line and process
        unless ($elm) {
            pop( @{ $self->{iterators} } );
            do {
                $iterator = $self->{iterators}->[-1];
                $elm = $iterator->() if $iterator;
                pop @{ $self->{iterators} }
                  unless $elm;        # pop the iterator if we're at the end
            } while ( !$elm && @{ $self->{iterators} } );
        }

        if ( Web::WTK::Markup::Element->isa_elm($elm) ) {
            push @{ $self->{iterators} },
              $elm->iterator;         # push the next iterator
        }
    }

    return $elm;
}

__PACKAGE__->meta->make_immutable;
1;
