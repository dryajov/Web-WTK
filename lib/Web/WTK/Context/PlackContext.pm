package Web::WTK::Context::PlackContext;

use namespace::autoclean;

use Moose;
extends 'Web::WTK::Context';

has 'env' => (
	is  => 'rw',
	isa => 'HashRef',
);

__PACKAGE__->meta->make_immutable;
1;
