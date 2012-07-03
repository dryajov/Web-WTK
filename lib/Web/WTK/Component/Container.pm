package Web::WTK::Component::Container;

use Moose;

extends 'Web::WTK::Component';

use Web::WTK::Exception::MarkupExceptions;
use Try::Tiny;

has 'children' => (
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

has 'addressable' => (
	traits  => ['Hash'],
	is      => 'rw',
	isa     => 'HashRef[Web::WTK::Roles::Addressable]',
	default => sub { {} },
	lazy    => 1,
	handles => {
		set_addressable    => 'set',
		get_addressable    => 'get',
		has_addressables   => 'is_empty',
		num_addressables   => 'count',
		delete_addressable => 'delete',
		addressable_pairs  => 'kv',
		addressable_ids    => 'keys',
		has_addressable    => 'exists',
	}
);

sub get_component_by_id {
	my $self = shift;
	my $id   = shift;

	my $component = $self->get_child($id);
	return $component;
}

sub add {
	my ( $self, $component ) = @_;

	$self->children->{ $component->id } = $component;
	$component->parent($self);

	$self->set_addressable( $component->get_component_url )
	  if $component->does('Web::WTK::Roles::Addressable');

	return $component;
}

sub render {
	my ( $self, $markup ) = @_;

	my $iterator = $markup->iterator();

	my $stream = Web::WTK::Markup::Stream->new( markup => $markup );
	my $elements = Web::WTK::Markup::ElementStream->new( stream => $stream );

	while ( my $elm = $elements->next ) {
		my $id = $elm->id() || next;
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

