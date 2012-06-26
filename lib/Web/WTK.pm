package Web::WTK;

use Moose;

has 'mounts' => (
	trait   => 'Hash',
	is      => 'rw',
	isa     => 'HashRef[ClassName]',
	default => sub { {} },
	handles => {
		set_mount     => 'set',
		get_mount     => 'get',
		has_no_mounts => 'is_empty',
		num_mounts    => 'count',
		delete_mount  => 'delete',
		mount_pairs   => 'kv',
	},
);

1;
