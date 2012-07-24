package Web::WTK;

# ABSTRACT: Main WTK module, holds global settings ans such

use namespace::autoclean;

use MooseX::Singleton;

use Web::WTK::Router;
use Web::WTK::Printers::Roles::Printable;

# the router of the application
has 'router' => (
	is      => 'ro',
	does    => 'Web::WTK::Router::Router',
	builder => 'build_router',
	lazy    => 1,
);

sub build_router {
	return Web::WTK::Router->new;
}

# resource such as xHTML and properties
# are assumed to be in the same place that
# the page/panel is, unless this is set to a
# valid path, in which case they are going
# to be lookued up there
has 'resources_path' => (
	is  => 'rw',
	isa => 'Str',
);

# the base of the source
has 'app_src_base' => (
	is  => 'rw',
	isa => 'Str',
);

# the virtual url base
# of the application
has 'app_base' => (
	is      => 'rw',
	isa     => 'Str',
	builder => 'build_app_base',
	lazy    => 1,
	writer	=> '_set_app_base'
);

sub build_app_base {
	"/";
}

has 'runner' => (
	is       => 'rw',
	isa      => 'Web::WTK::AppRunner',
	required => 1,
);

has 'printer' => (
	is      => 'rw',
	isa     => 'Web::WTK::Printers::Roles::Printable',
	default => sub { Web::WTK::Printers::Html->new },
);

sub BUILD {
	my ( $self, $args ) = @_;

	# add routes
	my $routes = $args->{routes};
	for my $route (@$routes) {
		$self->router->add_route($route);
	}

	# fix app_base to have a leading slash
	my $app_base = $args->{app_base};
	if ( $app_base !~ m|^/| ) {
		$self->_set_app_base("/$app_base");
	}
}

1;
