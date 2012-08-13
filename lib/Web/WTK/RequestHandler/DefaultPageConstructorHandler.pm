package Web::WTK::RequestHandler::DefaultPageConstructorHandler;

use namespace::autoclean;

use Moose;

with 'Web::WTK::RequestHandler::Handler';

use Try::Tiny;
use Module::Load;

use Web::WTK;
use Web::WTK::Printers::Html;
use Web::WTK::Exception::EndpointExceptions;

sub _load_page {
	my ( $self, $ctx, $page_path ) = @_;

	# try to get the current requested page version
	my $page_cache_id = $ctx->route_info->get_page_route_with_render_count
	  || $page_path;

	my $session    = $ctx->session;
	my $page       = $session->page_store->get_page($page_cache_id);
	my $page_class = $ctx->page_class;
	my $params     = $ctx->request->parameters;

	if ($page) {
		$page->parameters($params);
		$page->context($ctx);
	}
	else {
		try {
			load $page_class;
		}
		catch {

			# TODO: we should pass that in as an
			# inner exception to PageNotFound...
			my $error = $_;
			throw Web::WTK::Exception::EndpointExeptions::PageNotFound->new;
		};

		try {
			if ( $page_path && exists $session->render_count->{$page_path} ) {
				$session->render_count->{$page_path}++;
			}
			elsif ($page_path) {
				$session->render_count->{$page_path} = 0;
			}

			# instantiate page
			$page = $page_class->new(
				parameters   => $params,
				context      => $ctx,
				render_count => $session->render_count->{$page_path},
			);

			# construct page
			$page->construct;
			$page_cache_id = "$page_path/" . $page->render_count;
			$ctx->session->page_store->set_page( $page_cache_id, $page );
		}
		catch {

			# TODO: we should pass that in as an
			# inner exception to InternalError...
			my $error = $_;
			throw Web::WTK::Exception::EndpointExeptions::InternalError->new;
		};
	}

	return $page;
}

sub handle {
	my ( $self, $ctx ) = @_;

	my $page_path = $ctx->route_info->page_route;

	my $page = $self->_load_page( $ctx, $page_path );
	$ctx->page($page);

	return;
}

__PACKAGE__->meta->make_immutable;
1;
