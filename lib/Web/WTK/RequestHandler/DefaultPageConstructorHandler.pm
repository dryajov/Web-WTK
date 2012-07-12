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
	my ( $self, $ctx, $path ) = @_;

	# TODO: need to construct proper identifier with version info
	my $session    = $ctx->session;
	my $page       = $session->get_page($path);
	my $params     = $ctx->request->parameters;
	my $page_class = Web::WTK->instance->get_mount($path);
	
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
			$page = $page_class->new(
				parameters => $params,
				context    => $ctx
			);
			$page->construct;
			$page->bootstrap;
		}
		catch {

			# TODO: we should pass that in as an
			# inner exception to InternalError...
			my $error = $_;
			throw Web::WTK::Exception::EndpointExeptions::InternalError->new;
		};

		$ctx->session->set_page( $path, $page );
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
