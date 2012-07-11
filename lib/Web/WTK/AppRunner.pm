package Web::WTK::AppRunner;

use MooseX::Singleton;
with 'Web::WTK::Roles::Runnable';

use Web::WTK::RequestProcessor;
use Web::WTK::Context;
use Web::WTK::Session;

use Web::WTK::Session::Roles::Handleable;

has 'request_processor' => (
	is      => 'rw',
	isa     => 'Web::WTK::RequestProcessor',
	default => sub { Web::WTK::RequestProcessor->new },
);

has 'request_mapper' => (
	is       => 'rw',
	isa      => 'Web::WTK::Roles::Handleable',
	required => 1,
);

has 'response_mapper' => (
	is       => 'rw',
	isa      => 'Web::WTK::Roles::Handleable',
	required => 1,
);

has 'session_handler' => (
	is       => 'rw',
	isa      => 'Web::WTK::Session::Roles::Handleable',
	required => 1,
);

sub run {
	my $self = shift;
	my $env  = shift;

	my $ctx = Web::WTK::Context->new( env => $env );

	# construct the request and session
	# (response is constructed implicit)
	my $req     = $self->request_mapper->handle($ctx);
	my $session = $self->session_handler->handle($ctx);

	$ctx->request($req);
	$ctx->session($session);
	$self->request_processor->process($ctx);

	return $self->response_mapper->handle($ctx);
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
