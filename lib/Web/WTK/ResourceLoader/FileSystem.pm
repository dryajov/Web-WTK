package Web::WTK::ResourceLoader::FileSystem;

use namespace::autoclean;

use Moose;

use Web::WTK::Resource;

has 'extension' => (
	is  => 'rw',
	isa => 'Str',
);

has 'name' => (
	is       => 'rw',
	isa      => 'Str',
);

has '_resource' => (
	is      => 'rw',
	isa     => 'Web::WTK::Resource',
	builder => '_build_resource',
	lazy    => 1,
);

sub _build_resource {
	my $self = shift;

	return Web::WTK::Resource->new( path => $self->path );
}

has 'location' => (
	is      => 'rw',
	isa     => 'Str',
	builder => '_build_location',
	lazy    => 1,
);

sub _build_location {
	"";
}

has 'path' => (
	is      => 'rw',
	isa     => 'Str',
	builder => '_build_path',
	lazy    => 1,
);

sub _build_path {
	my $self = shift;

	return
	    $self->location . "/"
	  . $self->name . "."
	  . $self->extension;
}

sub open {
	my $self = shift;

	return $self->_resource->handle;
}

__PACKAGE__->meta->make_immutable;
1;
