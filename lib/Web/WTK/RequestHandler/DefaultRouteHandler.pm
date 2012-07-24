package Web::WTK::RequestHandler::DefaultRouteHandler;

use namespace::autoclean;

use Moose;

with 'Web::WTK::RequestHandler::Handler';

use Try::Tiny;
use Module::Load;
use Hash::MultiValue;

use Web::WTK;
use Web::WTK::Printers::Html;
use Web::WTK::Exception::EndpointExceptions;

# Parse the current request path and
# extract it's different elements
#
# a route should contain:
#
# - The requested page
# - The current request count
#	-used to look up the page in the page store for proper
#	 state handling (mainly used but not limited to,
#	 the back button problem)
#
# a route can contain:
#
# - Url embeded parameters
# - Any externally accessible componnent and it's
#	associated parameters
#
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

		my $router = Web::WTK->instance->router;
		my $route  = $router->match($path);

		if ($route) {
			$ctx->route_info->page_route( $route->[0] );
			$ctx->page_class( $route->[1] );
			$ctx->request->url_params(
				Hash::MultiValue->new( @{ $route->[2] } )
			);

			# get the current render count from the url params
			$ctx->route_info->render_count(
				$ctx->request->parameters->get("rc") );

			# get the component route from the url params
			$ctx->route_info->component_route(
				$ctx->request->parameters->get("route") );
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
