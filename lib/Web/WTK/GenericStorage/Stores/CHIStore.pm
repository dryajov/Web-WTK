package Web::WTK::GenericStorage::Stores::CHIStore;

use namespace::autoclean;

use CHI;

use Moose;

# just a hash that implements the store
has 'store' => (
	is      => 'ro',
	isa     => 'CHI::Driver',
	builder => '_build_store',
);

sub _build_store {
	return CHI->new( driver => 'RawMemory', global => 1 );
}

sub get {
	return shift->store->get(@_);
}

sub set {
	return shift->store->set(@_);
}

sub remove {
	return shift->store->remove(@_);
}

sub is_empty {

	return shift->store->get_keys() ? 1 : 0;
}

sub count {
	return scalar @{ shift->store->get_keys() };
}

sub get_pairs {
	my $self = shift;

	return
	  map { ( $_, $self->storage->get($_) ) }
	  $self->storage->get_keys();
}

with 'Web::WTK::GenericStorage::Storage';

__PACKAGE__->meta->make_immutable;
1;
