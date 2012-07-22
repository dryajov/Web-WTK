package Web::WTK::GenericStorage::Stores::InMemoryStore;

use namespace::autoclean;

use Moose;

# just a hash that implements the store
has '_store' => (
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
