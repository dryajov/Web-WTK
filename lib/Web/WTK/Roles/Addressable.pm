package Web::WTK::Roles::Addressable;

use namespace::autoclean;

use Moose::Role;

requires 'parent';

sub get_component_parents {
	my $self = shift;

	my @path;
	push @path, $self->id;
	my $parent = $self->parent;
	while ($parent) {
		push @path, $parent->id;
		$parent = $parent->parent;
	}

	return reverse @path;
}

sub get_component_path {
	my $self = shift;

	return join '.', $self->get_component_parents;
}

1;
