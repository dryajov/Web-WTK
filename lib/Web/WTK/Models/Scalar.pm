package Web::WTK::Models::Scalar;

use namespace::autoclean;

use Moose;

has 'object' => (
	is       => 'rw',
	isa      => 'Any',
	required => 1,
);

sub value {
	my $self = shift;
	
	$self->object(@_);	
}

with 'Web::WTK::Models::Model';
__PACKAGE__->meta->make_immutable;
1;
