package Web::WTK::Resolver::ClassToMarkupResource;

use namespace::autoclean;

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

# simply look for an html file in 
# the same location as the module
sub _get_path {
    my $file = shift;

    $file =~ s|::|/|;
    $file .= ".html";

    return $file;
}

__PACKAGE__->meta->make_immutable;
1;
