package Web::WTK::Context;

use namespace::autoclean;

use Moose;
use Moose::Util::TypeConstraints;

use Web::WTK::Response;
use Web::WTK::Exception::Base;
use Web::WTK::Request::RouteInfo;

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
	isa => 'Web::WTK::Component::Container::Page',
);

has 'expire_session' => (
	is  => 'rw',
	isa => 'Bool',
);

class_type 'Web::WTK::Exception::Base';

has 'error' => (
	is  => 'rw',
	isa => 'Web::WTK::Exception::Base',
);

has 'route_info' => (
	is      => 'rw',
	isa     => 'Web::WTK::Request::RouteInfo',
	default => sub { Web::WTK::Request::RouteInfo->new },
	lazy    => 1,
);

has 'session' => (
	is      => 'rw',
	isa     => 'Web::WTK::Session',
	lazy    => 1,
	default => sub {
		Web::WTK->instance->runner->session_stash->get(shift);
	},
);

__PACKAGE__->meta->make_immutable;
1;
