package Web::WTK::Markup::ElementStream;

use namespace::autoclean;

use Moose;

has 'stream' => (
    is       => 'rw',
    isa      => 'Web::WTK::Markup::Stream',
    required => 1,
);

sub next {
    my $self = shift;

    while ( my $elm = $self->stream->next() ) {

        # we're only interested in elements
        return $elm if ( Web::WTK::Markup::Element->isa_elm($elm) );
    }
}

__PACKAGE__->meta->make_immutable;
1;
