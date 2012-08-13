package Web::WTK::Models::Closure;

use namespace::autoclean;

use Moose;

has 'object' => (
	is       => 'rw',
	isa      => 'Maybe[CodeRef]',
	required => 1,
);

sub value {
	my $self = shift;
	
	$self->object->(@_);	
}

with 'Web::WTK::Models::Model';

__PACKAGE__->meta->make_immutable;
1;
