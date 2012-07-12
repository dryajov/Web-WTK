package Web::WTK::Request::RouteInfo;

use namespace::autoclean;

use Moose;

has 'page_route' => (
	is  => 'rw',
	isa => 'Str',
);

has 'component_route' => (
	is  => 'rw',
	isa => 'Str|Undef',
);

has 'event_id' => (
	is  => 'rw',
	isa => 'Str|Undef',
);

has 'route_parameters' => (
	is  => 'rw',
	isa => 'HasRef',
);

has 'render_count' => (
	traits  => ['Counter'],
	is      => 'rw',
	isa     => 'Int',
	default => 0,
	handles => { inc_render => 'inc', }
);

__PACKAGE__->meta->make_immutable;
1;
