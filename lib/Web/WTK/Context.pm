package Web::WTK::Context;

use Moose;
use Moose::Util::TypeConstraints;

use Web::WTK::Response;
use Web::WTK::Exception::Base;

has 'env' => (
	is  => 'rw',
	isa => 'HashRef',
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
	isa => 'Str | Undef',
);

has 'session' => (
	is  => 'rw',
	isa => 'Web::WTK::Session',
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

__PACKAGE__->meta->make_immutable;
no Moose;
1;
