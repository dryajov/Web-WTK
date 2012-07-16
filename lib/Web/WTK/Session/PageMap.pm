package Web::WTK::Session::PageMap;

use namespace::autoclean;

use Moose;

has 'backend' => (
	is       => 'rw',
	does     => 'Web::WTK::GenericStorage::Storage',
	required => 1,
	handles  => {
		get_page       => 'get',
		set_page       => 'set',
		remove_page    => 'remove',
		has_pages      => 'is_empty',
		num_pages      => 'count',
		get_page_pairs => 'get_pairs',
	}
);

__PACKAGE__->meta->make_immutable;
1;
