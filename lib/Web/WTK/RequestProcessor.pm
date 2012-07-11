package Web::WTK::RequestProcessor;

use Moose;

use Try::Tiny;

use Web::WTK::Handler::DefaultErrorHandler;
use Web::WTK::Handler::DefaultRouteHandler;
use Web::WTK::Handler::DefaultPageLoaderHandler;
use Web::WTK::Handler::DefaultEventsHandler;
use Web::WTK::Handler::DefaultPageRenderHandler;

has 'route_handler' => (
	is      => 'ro',
	isa     => 'Web::WTK::Roles::Handleable',
	builder => 'build_route_handler',
);

sub build_route_handler {
	Web::WTK::Handler::DefaultRouteHandler->new;
}

has 'page_loader_handler' => (
	is      => 'ro',
	isa     => 'Web::WTK::Roles::Handleable',
	builder => 'build_page_loader_handlers',
);

sub build_page_loader_handlers {
	return Web::WTK::Handler::DefaultPageLoaderHandler->new;
}

has 'event_handler' => (
	is      => 'ro',
	isa     => 'Web::WTK::Roles::Handleable',
	builder => 'build_event_handler',
);

sub build_event_handler {

	return Web::WTK::Handler::DefaultEventsHandler->new;
}

has 'render_handler' => (
	is      => 'ro',
	isa     => 'Web::WTK::Roles::Handleable',
	builder => 'build_render_handler',
);

sub build_render_handler {
	Web::WTK::Handler::DefaultPageRenderHandler->new;
}

has 'response_handler' => (
	is      => 'ro',
	isa     => 'Web::WTK::Roles::Handleable',
	builder => 'build_response_handler',
);

sub build_response_handler {
	Web::WTK::Handler::DefaultPageRenderHandler->new;
}

has 'error_handler' => (
	is      => 'rw',
	isa     => 'Web::WTK::Roles::Handleable',
	builder => 'build_error_handler',
);

sub build_error_handler {
	return Web::WTK::Handler::DefaultErrorHandler->new;
}

sub process {
	my ( $self, $ctx ) = @_;

	try {

		# trigger the route handler
		$self->route_handler->handle($ctx);

		# trigger the page handler
		$self->page_loader_handler->handle($ctx);

		# trigger the page and components render handler
		$self->render_handler->handle($ctx);

		# trigger the component handler
		$self->event_handler->handle($ctx);
	}
	catch {
		$ctx->error($_);
		$self->error_handler->handle($ctx);
	};

	return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
