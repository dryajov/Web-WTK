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

# the currently requested render count
has 'render_count' => (
	is      => 'rw',
	isa     => 'Num',
);

sub get_page_route_with_render_count {
	my $self = shift;

	return $self->page_route . "/" . ($self->render_count // "");

}

__PACKAGE__->meta->make_immutable;
1;
