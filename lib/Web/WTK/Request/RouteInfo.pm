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

has 'route_parameters' => (
	is  => 'rw',
	isa => 'HasRef',
);

has 'render_count' => (
	traits  => ['Counter'],
	is      => 'rw',
	isa     => 'Num',
	default => 0,
	handles => {
		inc_render_count   => 'inc',
		dec_render_count   => 'dec',
		reset_render_count => 'reset',
	},
);

sub get_page_route_with_render_count {
	my $self = shift;

	my $route;
	if ( $self->render_count > 0 ) {
		$route = $self->page_route . "/" . $self->render_count;
	}

	return $route;
}

__PACKAGE__->meta->make_immutable;
1;
