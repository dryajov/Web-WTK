package Web::WTK::Resolver::FileSystemResource;

use Moose;

use Web::WTK::Resource;

has 'resource' => (
    is      => 'rw',
    isa     => 'Web::WTK::Resource',
    builder => '_resource',
    lazy    => 1,
);

sub _resource {
    my $self = shift;

    return Web::WTK::Resource->new( path => $self->path );
}

has 'path' => (
    is  => 'rw',
    isa => 'Str',
);

sub open {
    my $self = shift;

    return $self->resource->handle;
}

__PACKAGE__->meta->make_immutable;
1;
