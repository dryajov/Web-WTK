package Web::WTK::Parser;

use Moose;

use Carp;
use Web::WTK::Util::Params;

# the root of the parsed doc
has 'document' => (
    is      => 'rw',
    isa     => 'Web::WTK::Markup::Element',
    builder => 'parse',
    lazy    => 1,
);

sub parse {
    my ( $self, $content ) = @_;
    croak "Method unimplemented!";
}

1;
