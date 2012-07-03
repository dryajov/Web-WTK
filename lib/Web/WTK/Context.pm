package Web::WTK::Context;

use Moose;

use Web::WTK::Response;

has 'env' => (
	is  => 'rw',
	isa => 'Any',    # can't use a type here, since it can be virtualy anything
);

has 'request' => (
	is  => 'rw',
	isa => 'Web::WTK::Request',
);

has 'response' => (
	is      => 'rw',
	isa     => 'Web::WTK::Response',
	default => sub { Web::WTK::Response->new },
	lazy    => 1,
);

has 'page' => (
	is  => 'rw',
	isa => 'Web::WTK::Component::Page',
);

has 'page_path' => (
	is  => 'rw',
	isa => 'Str',
);

has 'component_path' => (
	is  => 'rw',
	isa => 'Str',
);

has 'page_version' => (
	is  => 'rw',
	isa => 'Int',
);

# provission for a session
has 'session' => (
	is  => 'rw',
	isa => 'Any',    # change to the correct type
);

has 'error' => (
	is  => 'rw',
	isa => 'Web::WTK::Exception::Base',
);

__PACKAGE__->meta->make_immutable;
no Moose;
1;
