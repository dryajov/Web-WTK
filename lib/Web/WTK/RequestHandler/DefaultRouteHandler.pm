package Web::WTK::RequestHandler::DefaultRouteHandler;

use namespace::autoclean;

use Moose;

with 'Web::WTK::RequestHandler::Handler';

use Try::Tiny;
use Module::Load;

use Web::WTK;
use Web::WTK::Printers::Html;
use Web::WTK::Exception::EndpointExceptions;

# Parse the current request path and
# extract its different elements
#
# a path  can contain:
#
# - The requested page
# - The current request count
#	-used to look up the page in the page store for proper
#	 state handling (mainly used but not limited to,
#	 the back button problem)
# - Url embeded parameters
# - Any externally accessible componnent and its
#	associated event and parameters
sub _parse_location_info {
	my ( $self, $ctx ) = @_;

	my $path     = $ctx->request->path_info;
	my $app_base = Web::WTK->instance->app_base;

	$path = "/$path" if $path !~ m|^/|;

	if ( $app_base eq $path ) {
		$ctx->route_info->page_route($path);
		return;
	}
	else {

		# strip app_base from path
		$path =~ s|^\Q$app_base\E||g
		  if $app_base ne "/";

		# get the page path from the request path
		my ( $page_route, $reduced );
		while ( length $path ) {

			if ( Web::WTK->instance->exists_mount($path) ) {
				$page_route = $path;
				$path       = $reduced;
				last;
			}

			# reduce the path
			($reduced) = $2 . $reduced
			  if $path =~ s|^(.*)(/.*/?)$|$1|;
		}

		$ctx->route_info->page_route($page_route);

		# get the current request count from the request path
		my $render_count;
		if ( length $path ) {

			# reduce the path
			$ctx->route_info->render_count( $1 || 0 )
			  if $path =~ s|^/(\d)||;
		}

		# get the component path and the event to be triggered
		if ( length $path ) {

			if ( $path =~ s|^/?([\w.]+)/?||g ) {
				$ctx->route_info->component_route($1);
			}
		}

	}
}

sub handle {
	my ( $self, $ctx ) = @_;

	$self->_parse_location_info($ctx);

	return;
}

__PACKAGE__->meta->make_immutable;
1;
