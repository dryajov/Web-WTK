package Web::WTK::Session;

use Moose;

use Web::WTK::Context;

has 'id' => (
	is       => 'rw',
	isa      => 'Any',
	required => 1,
);

has 'page_store' => (
	traits  => ['Hash'],
	is      => 'rw',
	isa     => 'HashRef[Web::WTK::Component::Page]',
	default => sub { {} },
	handles => {
		set_page    => 'set',
		get_page    => 'get',
		has_page    => 'is_empty',
		num_page    => 'count',
		delete_page => 'delete',
		page_pairs  => 'kv',
	}
);

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
no Moose;

1;
