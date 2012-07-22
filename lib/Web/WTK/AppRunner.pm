package Web::WTK::AppRunner;

use namespace::autoclean;

use Moose;
with 'Web::WTK::Roles::Runnable';

use Web::WTK::Request::Mappers::Mapper;
use Web::WTK::Session::SessionStash;
use Web::WTK::RequestHandler;
use Web::WTK::Context;
use Web::WTK::Session;

has 'request_processor' => (
	is      => 'rw',
	isa     => 'Web::WTK::RequestHandler',
	default => sub { Web::WTK::RequestHandler->new },
);

has 'request_mapper' => (
	is       => 'rw',
	isa      => 'Web::WTK::Request::Mappers::Mapper',
	required => 1,
);

has 'response_mapper' => (
	is       => 'rw',
	isa      => 'Web::WTK::Request::Mappers::Mapper',
	required => 1,
);

has 'session_stash' => (
	is  => 'rw',
	isa => 'Web::WTK::Session::SessionStash',
);

# NOTE: this is intended as a global shared state
# so the storage *has* to be synchronized to avoid 
# raise condition
has 'resources_cache' => (
	is   => 'rw',
	does => 'Web::WTK::GenericStorage::Storage',
);

# expects a context object
sub run {
	my $self = shift;
	my $ctx  = shift;

	# construct the request and session
	# (response is constructed implicitelly)
	my $req = $self->request_mapper->map($ctx);

	# fetch session or create a new one
	$self->session_stash->get($ctx);
	$ctx->request($req);

	$self->request_processor->process($ctx);

	# detach any transient data
	$self->session_stash->detach($ctx);

	return $self->response_mapper->map($ctx);
}

__PACKAGE__->meta->make_immutable;
1;
