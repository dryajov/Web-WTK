package Web::WTK::Roles::Addressable;

use namespace::autoclean;

use Moose::Role;

requires 'parent';
requires 'page';

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

sub get_component_url {
	my $self = shift;

	my $page_url = $self->page->page_url;
	$page_url = "$page_url/"
	  if $page_url !~ m|/$|;

	my $render_count = $self->page->render_count;
	my $component_url =
	  $page_url . "$render_count/" . $self->get_component_path;
	return $component_url;
}

1;
