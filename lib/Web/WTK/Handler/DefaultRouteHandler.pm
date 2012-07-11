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
	my $app_base = Web::WTK->instance->app_base;

	$path =~ s|^\Q$app_base\E||g
	  if $app_base ne $path;    # strip app_base from path

	my $component_path;
	while ( length $path && !Web::WTK->instance->exists_mount($path) ) {
		my ( $path_left, $reduced ) =
		  $path =~ s|^(.*)(?:/)|$1|g;    # reduce the path
		$path = $path_left;
		$component_path .= $reduced if $reduced;
	}

	return ( $path, $component_path );
}

sub handle {
	my ( $self, $ctx ) = @_;

	my ( $path, $component_path ) =
	  $self->_get_page_path( $ctx->request->path_info );

	$ctx->page_path($path);
	$ctx->component_path($component_path);

	return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
