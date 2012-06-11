package Web::WTK::Resolver::ClassToMarkupResource;

use Moose;
use IO::File;

use Web::WTK::Exception::ResourceExceptions;

extends 'Web::WTK::Resolver::FileSystemResource';

has 'class' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

sub BUILD {
    my ( $self, $params ) = @_;

    my $path = _get_path( $params->{class} );
    $self->path($path);
}

sub _get_path {
    my $file = shift;

    $file =~ s|::|/|x;
    $file .= ".html";

    return $file;
}

__PACKAGE__->meta->make_immutable;
1;
