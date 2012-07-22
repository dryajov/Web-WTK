package Web::WTK;

# ABSTRACT: Main WTK module, holds global settings ans such

use namespace::autoclean;

use MooseX::Singleton;
use Web::WTK::Printers::Roles::Printable;

# the routes of the application
has 'mounts' => (
	traits  => ['Hash'],
	is      => 'ro',
	isa     => 'HashRef[Str]',
	default => sub { {} },
	lazy    => 1,
	handles => {
		get_mount           => 'get',
		has_mounts          => 'is_empty',
		num_mounts          => 'count',
		mount_pairs         => 'kv',
		get_all_mount_paths => 'keys',
		exists_mount        => 'defined',
	},
);

# resource such as xHTML and properties
# are assumed to be in the same place that
# the page/panel is, unless this is set to a
# valid path, in which case they are going
# to be lookued up there
has 'resources_path' => (
	is  => 'rw',
	isa => 'Str',
);

# the base of the source -
has 'app_src_base' => (
	is       => 'ro',
	isa      => 'Str',
	required => 1,
);

# the virtual url base
# of the application
has 'app_base' => (
	is      => 'ro',
	isa     => 'Str',
	builder => 'build_app_base',
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

sub BUILDARGS {
	my ( $self, %args ) = @_;

	my $mounts = $args{mounts};
	my %fixed_mounts;

	# remove trailing /
	while ( my ( $path, $page ) = each %$mounts ) {
		$path =~ s|\z/||x;
		$fixed_mounts{ lc $path } = $page;
	}

	$args{app_base} = "/$args{app_base}"
	  if $args{app_base} !~ m|^/|;

	$args{mounts} = \%fixed_mounts;

	return \%args;
}

__PACKAGE__->meta->make_immutable;
1;
