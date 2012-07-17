package Web::WTK::Session;

use namespace::autoclean;

use Moose;

use Web::WTK::Context;
use Web::WTK::Session::PageMap;
use Web::WTK::GenericStorage::Stores::HashStore;

has 'id' => (
	is       => 'rw',
	isa      => 'Any',
	required => 1,
);

has 'page_store' => (
	is      => 'rw',
	isa     => 'Web::WTK::Session::PageMap',
	builder => '_build_page_store',
);

has 'render_count' => (
	is      => 'rw',
	isa     => 'HashRef[Num]',
	default => sub { {} },
	lazy    => 1,
);

sub _build_page_store {
	return Web::WTK::Session::PageMap->new(
		backend => Web::WTK::GenericStorage::Stores::HashStore->new );
}

has 'data' => (
	traits  => ['Hash'],
	is      => 'rw',
	isa     => 'HashRef[Any]',
	default => sub { {} },
	handles => {
		set_data    => 'set',
		get_data    => 'get',
		has_data    => 'is_empty',
		num_data    => 'count',
		delete_data => 'delete',
		data_pairs  => 'kv',
	}
);

__PACKAGE__->meta->make_immutable;
1;
