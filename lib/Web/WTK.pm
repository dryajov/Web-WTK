package Web::WTK;

# ABSTRACT: Main WTK module, holds global settings ans such

use namespace::autoclean;

use MooseX::Singleton;
use Cwd 'abs_path';

use Web::WTK::Printers::Roles::Printable;

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

has 'resources_path' => (
	is      => 'ro',
	isa     => 'Str',
	builder => 'build_resource_path',
);

sub build_resource_path {
	abs_path($0);
}

has 'src_base' => (
	is      => 'ro',
	isa     => 'Str',
	builder => 'build_src_base',
);

sub build_src_base {
	abs_path($0);
}

# the virtual url base of the application
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
