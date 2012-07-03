package Web::WTK::Handler::DefaultRouteHandler;

use Moose;

with 'Web::WTK::Roles::Handleable';

use Try::Tiny;
use Module::Load;

use Web::WTK;
use Web::WTK::Printers::Html;
use Web::WTK::Exception::EndpointExceptions;

sub _get_page_path {
	my ( $self, $path_info ) = @_;

	my $path     = $path_info;
	my $app_base = Web::WTK->instanse->app_base;

	$path =~ s|^$app_base||g;    # strip app_base from path

	my $component_path;
	while ( !Web::WTK->instanse->exists_mount($path) || length $path ) {
		my ( $path_left, $reduced ) =
		  $path =~ s|^(.*)(/)|$1|g;    # reduse the path
		$path = $path_left;
		$component_path .= $reduced;
	}

	return ( $path, $component_path );
}

sub handle {
	my ( $self, $ctx ) = @_;

	my ( $path, $component_path ) =
	  $self->_get_page_path( $ctx->request->path_info );

	return 1;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
