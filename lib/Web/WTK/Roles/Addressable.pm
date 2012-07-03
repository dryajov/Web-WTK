package Web::WTK::Roles::Addressable;

use Moose::Role;

requires 'parent';

sub get_component_path {
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

sub get_component_url {
	my $self = shift;

	return join '/', $self->get_component_path;
}

no Moose::Role;
1;
