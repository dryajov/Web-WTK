package Web::WTK;

use MooseX::Singleton;

has 'mounts' => (
	traits  => ['Hash'],
	is      => 'rw',
	isa     => 'HashRef',
	default => sub { {} },
	lazy    => 1,
	handles => {
		set_mount    => 'set',
		get_mount    => 'get',
		has_mounts   => 'is_empty',
		num_mounts   => 'count',
		delete_mount => 'delete',
		mount_pairs  => 'kv',
	},
);

has 'resources_path' => (
	is  => 'rw',
	isa => 'Str'
);

has 'hadnlers' => (
	is  => 'ro',
	isa => 'Web::WTK::Roles::Handleable',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;
