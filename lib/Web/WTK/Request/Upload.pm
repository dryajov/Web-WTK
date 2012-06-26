package Web::WTK::Request::Upload;

use Carp ();
use Moose;

has 'headers' => (
	is  => 'rw',
	isa => 'Any'
);

has 'tempname' => (
	is  => 'rw',
	isa => 'Str',
);

has 'size' => (
	is  => 'rw',
	isa => 'Int',
);

has 'filename' => (
	is  => 'rw',
	isa => 'Str',
);

has 'path' => (
	is      => 'rw',
	isa     => 'Str',
	default => sub { $_[0]->filename },
);

has '_basename' => (
	is  => 'rw',
	isa => 'Str',
);

sub content_type {
	my $self = shift;
	$self->headers->content_type(@_);
}

sub type { shift->content_type(@_) }

sub basename {
	my $self = shift;

	my $basename;
	unless ( defined $self->_basename ) {
		require File::Spec::Unix;
		$basename = $self->filename;
		$basename =~ s|\\|/|g;
		$basename = ( File::Spec::Unix->splitpath($basename) )[2];
		$basename =~ s|[^\w\.-]+|_|g;
		$self->_basename($basename);
	}

	return $basename;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
