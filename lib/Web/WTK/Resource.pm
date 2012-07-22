package Web::WTK::Resource;

use namespace::autoclean;

use Moose;
use Moose::Util::TypeConstraints;

use File::Basename;

use Web::WTK::Exception::ResourceExceptions;

# the path of the resource
has 'path' => (
	is       => 'rw',
	isa      => 'Str',
	required => 1,
);

# name of the resource
has 'name' => (
	is  => 'rw',
	isa => 'Str',
);

has 'extension' => (
	is  => 'rw',
	isa => 'Str',
);

# the handle of the file - an IO::File object type
has 'handle' => (
	is      => 'ro',
	isa     => 'IO::File',
	builder => '_open',
	lazy    => 1,
);

sub _open {
	my $self = shift;

	my $path = $self->path . $self->name;
	return IO::File->new($path)
	  or
	  throw Web::WTK::Exception::ResourceExceptions::UnableToOpenResource->new(
		error => $! );
}

# the full path of the resource
has 'abs_path' => (
	is      => 'rw',
	isa     => 'Str',
	builder => '_abs_path',
	lazy    => 1,
);

sub _abs_path {
	my $self = shift;
	return $self->{path} . $self->{name};
}

sub BUILD {
	my ( $self, $params ) = @_;

	my ( $name, $path, $suffix ) = fileparse( $params->{path} );
	$self->path($path);
	$self->name($name);
}

__PACKAGE__->meta->make_immutable;
1;
