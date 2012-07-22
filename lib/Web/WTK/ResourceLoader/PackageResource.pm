package Web::WTK::ResourceLoader::PackageResource;

use namespace::autoclean;

use Moose;

use Web::WTK;
use Web::WTK::Exception::ResourceExceptions;

extends 'Web::WTK::ResourceLoader::FileSystem';

has '+extension' => ( default => 'html', );

has 'package_name' => (
	is       => 'rw',
	isa      => 'Str',
	required => 1,
);

sub BUILD {
	my ( $self, $args ) = shift;

	my ( $package_name, $name ) = ( $self->package_name );
	$name = $1 if $package_name =~ s|(\w+)$||;
	$self->name($name);

	my $location = Web::WTK->instance->app_src_base;
	$location = "$location/"
	  if $location !~ m|/$|;

	$location .= $1 if $package_name =~ s|[\:\:]+|/|;
	$location =~ s|/$||;
	$self->location($location);
}

__PACKAGE__->meta->make_immutable;
1;
