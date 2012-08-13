package Web::WTK::Component::Container;

use namespace::autoclean;

use Moose;

extends 'Web::WTK::Component';

use Web::WTK::Exception::MarkupExceptions;
use Try::Tiny;

has 'is_root' => (
	is      => 'rw',
	isa     => 'Bool',
	default => sub { defined shift->parent ? 1 : 0; },
	lazy    => 1,
);

has 'components' => (
	traits  => ['Hash'],
	is      => 'ro',
	isa     => 'HashRef[Web::WTK::Component]',
	default => sub { {} },
	lazy    => 1,
	handles => {
		set_child    => 'set',
		get_child    => 'get',
		has_childs   => 'is_empty',
		num_childs   => 'count',
		delete_child => 'delete',
		child_pairs  => 'kv',
		child_ids    => 'keys',
		has_child    => 'exists'
	}
);

has '_comp_order' => (
	is      => 'rw',
	isa     => 'ArrayRef',
	default => sub { [] },
	lazy    => 1,
);

sub get_component_by_id {
	my $self = shift;
	my $id   = shift;

	my $component = $self->get_child($id);
	if ( $component && eval { $component->does(__PACKAGE__) } ) {
		my $found = $component->get_component_by_id($id);
		$component = $found;
	}

	return $component;
}

sub get_component_by_abs_route {
	my $self = shift;

	my $root = $self->is_root
	  if !$self->is_root;

	return __PACKAGE__->_find_component_by_route( @_, $root );
}

sub get_component_by_route {
	my $self = shift;
	return __PACKAGE__->_find_component_by_route( @_, $self );
}

sub _find_component_by_route {
	my ( $class, $path, $component ) = @_;

	my @parts = split /\./, $path;

	shift @parts
	  if $parts[0] eq lc( ref($component) );

	for my $part (@parts) {
		$component = $component->get_child($part);
		last if !$component;
	}

	return $component;
}

sub add {
	my ( $self, $component ) = @_;

	$self->components->{ $component->id } = $component;
	$component->parent($self);

	push @{ $self->_comp_order }, $component->id;

	# contruct the component
	$component->construct
	  if eval { $component->does('Web::WTK::Component::Constructable') };

	return $component;
}

sub render {
	my ( $self, $markup ) = @_;

	my $iterator = $markup->iterator();

	my $elements =
	  Web::WTK::Markup::ElementStream->new(
		stream => Web::WTK::Markup::Stream->new( markup => $markup ) );

	while ( my $elm = $elements->next ) {
		my $id = $elm->id || next;
		my $component = $self->get_component_by_id($id);
		if ($component) {
			$elm->component($component);
			$component->render($elm);
		}
	}

	return $self->SUPER::render($markup);
}

__PACKAGE__->meta->make_immutable;
1;

