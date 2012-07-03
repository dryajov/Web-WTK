package Web::WTK::AppRunner;

use Try::Tiny;

use MooseX::Singleton;
with 'Web::WTK::Roles::Runnable';

use Web::WTK::Handler::DefaultErrorHandler;
use Web::WTK::Handler::DefaultRouteHandler;
use Web::WTK::Handler::DefaultPageLoaderHandler;
use Web::WTK::Handler::DefaultPageRenderHandler;
use Web::WTK::Context;

has 'route_handlers' => (
	is      => 'ro',
	isa     => 'ArrayRef[Web::WTK::Roles::Handleable]',
	builder => 'build_route_handlers',
);

sub build_route_handlers {
	my $self = shift;

	my @default_handlers;
	push @default_handlers, Web::WTK::Handler::DefaultRouteHandler->new;

	return \@default_handlers;
}

has 'page_loader_handlers' => (
	is      => 'ro',
	isa     => 'ArrayRef[Web::WTK::Roles::Handleable]',
	builder => 'build_page_loader_handlers',
);

sub build_page_loader_handlers {
	my $self = shift;

	my @default_handlers;
	push @default_handlers, Web::WTK::Handler::DefaultPageLoaderHandler->new;

	return \@default_handlers;
}

has 'component_handlers' => (
	is      => 'ro',
	isa     => 'ArrayRef[Web::WTK::Roles::Handleable]',
	builder => 'build_component_handlers',
);

sub build_component_handlers {
	my $self = shift;

	my @default_handlers;
	#push @default_handlers, Web::WTK::Handler::DefaultPageHandler->new;

	return \@default_handlers;
}

has 'render_handlers' => (
	is      => 'ro',
	isa     => 'ArrayRef[Web::WTK::Roles::Handleable]',
	builder => 'build_render_handlers',
);

sub build_render_handlers {
	my $self = shift;

	my @default_handlers;
	push @default_handlers, Web::WTK::Handler::DefaultPageRenderHandler->new;

	return \@default_handlers;
}

has 'error_handler' => (
	is      => 'rw',
	isa     => 'Web::WTK::Roles::Handleable',
	builder => 'build_error_handler',
);

sub build_error_handler {
	my $self = shift;

	return Web::WTK::Handler::DefaultErrorHandler->new;
}

has 'request_handler' => (
	is       => 'rw',
	isa      => 'Web::WTK::Roles::Handleable',
	required => 1,
);

has 'response_handler' => (
	is       => 'rw',
	isa      => 'Web::WTK::Roles::Handleable',
	required => 1,
);

sub run {
	my $self = shift;
	my $env  = shift;

	my $ctx = Web::WTK::Context->new( env => $env );

	# construct the request and session 
	# (response is constructed implicit)
	my $req = $self->request_handler->handle($ctx);
	my $session;    # TODO: Initialize session here

	$ctx->request($req);
	$ctx->session($session);

	try {
		# trigger the route handlers
		for my $handler ( @{ $self->router_handlers } ) {
			$handler->handle($ctx);
		}
		
		# trigger the page handlers
		for my $handler ( @{ $self->page_loader_handlers } ) {
			$handler->handle($ctx);
		}
		
		# trigger the component handlers
		for my $handler ( @{ $self->component_handlers } ) {
			$handler->handle($ctx);
		}
	
		# trigger the render handlers
		for my $handler ( @{ $self->render_handlers } ) {
			$handler->handle($ctx);
		}
	}
	catch {
		$ctx->error($_);
		$self->error_handler->handle($ctx);
	};

	return $self->response_handler->handle($ctx);
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
