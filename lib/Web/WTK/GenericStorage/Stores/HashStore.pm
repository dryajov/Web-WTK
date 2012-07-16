package Web::WTK::GenericStorage::Stores::HashStore;

use namespace::autoclean;

use Moose;

has '_hash_store' => (
	traits  => ['Hash'],
	is      => 'ro',
	isa     => 'HashRef[Any]',
	default => sub { {} },
	handles => {
		set       => 'set',
		get       => 'get',
		remove    => 'delete',
		is_empty  => 'is_empty',
		count     => 'count',
		get_pairs => 'kv',
	}
);

with 'Web::WTK::GenericStorage::Storage';

__PACKAGE__->meta->make_immutable;
1;
