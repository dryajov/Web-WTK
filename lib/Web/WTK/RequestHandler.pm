package Web::WTK::RequestHandler;

use namespace::autoclean;

use Moose;

use Try::Tiny;

use Web::WTK::RequestHandler::DefaultErrorHandler;
use Web::WTK::RequestHandler::DefaultRouteHandler;
use Web::WTK::RequestHandler::DefaultPageConstructorHandler;
use Web::WTK::RequestHandler::DefaultEventsHandler;
use Web::WTK::RequestHandler::DefaultPageRenderHandler;

has 'route_handler' => (
	is      => 'ro',
	does    => 'Web::WTK::RequestHandler::Handler',
	builder => 'build_route_handler',
	lazy    => 1,
);

sub build_route_handler {
	Web::WTK::RequestHandler::DefaultRouteHandler->new;
}

has 'page_construct_handler' => (
	is      => 'ro',
	does    => 'Web::WTK::RequestHandler::Handler',
	builder => 'build_page_loader_handlers',
	lazy    => 1,
);

sub build_page_loader_handlers {
	return Web::WTK::RequestHandler::DefaultPageConstructorHandler->new;
}

has 'event_handler' => (
	is      => 'ro',
	does    => 'Web::WTK::RequestHandler::Handler',
	builder => 'build_event_handler',
	lazy    => 1,
);

sub build_event_handler {

	return Web::WTK::RequestHandler::DefaultEventsHandler->new;
}

has 'render_handler' => (
	is      => 'ro',
	does    => 'Web::WTK::RequestHandler::Handler',
	builder => 'build_render_handler',
	lazy    => 1,
);

sub build_render_handler {
	Web::WTK::RequestHandler::DefaultPageRenderHandler->new;
}

has 'response_handler' => (
	is      => 'ro',
	does    => 'Web::WTK::RequestHandler::Handler',
	builder => 'build_response_handler',
	lazy    => 1,
);

sub build_response_handler {
	Web::WTK::RequestHandler::DefaultPageRenderHandler->new;
}

has 'error_handler' => (
	is      => 'rw',
	does    => 'Web::WTK::RequestHandler::Handler',
	builder => 'build_error_handler',
	lazy    => 1,
);

sub build_error_handler {
	return Web::WTK::RequestHandler::DefaultErrorHandler->new;
}

sub process {
	my ( $self, $ctx ) = @_;

	try {

		# trigger the route handler
		$self->route_handler->handle($ctx);

		# trigger the page handler
		$self->page_construct_handler->handle($ctx);

		# trigger the component handler
		$self->event_handler->handle($ctx);

		# trigger the page and components render handler
		$self->render_handler->handle($ctx);
	}
	catch {
		$ctx->error($_);
		$self->error_handler->handle($ctx);
	};

	return;
}

__PACKAGE__->meta->make_immutable;
1;
