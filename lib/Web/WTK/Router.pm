package Web::WTK::Router;

use namespace::autoclean;

use Moose;

with 'Web::WTK::Router::Router';

has 'routes' => (
	traits  => ['Array'],
	is      => 'ro',
	isa     => 'ArrayRef[ArrayRef]',
	handles => {
		all_routes    => 'elements',
		add_route     => 'push',
		map_routes    => 'map',
		filter_routes => 'grep',
		find_route    => 'first',
		get_route     => 'get',
		join_routes   => 'join',
		count_routes  => 'count',
		has_routes    => 'count',
		has_no_routes => 'is_empty',
		sorted_routes => 'sort',
	}
);

# match a page and try to parse out the parameters
sub match {
	my ( $self, $request_route ) = @_;

	for my $route_struct (  $self->all_routes  ) {
		my $route  = $route_struct->[0];
		my $page   = $route_struct->[1];
		my $params = $route_struct->[2];
		$route = "/$route"
		  if $route !~ m|^/|;
		if ( $request_route =~ s|^$route||i ) {
			my @params = $request_route =~ m|$params|i
			  if length $request_route;
			@params = ( @params, %+ );
			return [ $route, $page, \@params ];
		}
	}
}

__PACKAGE__->meta->make_immutable;
1;
