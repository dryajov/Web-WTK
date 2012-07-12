package Web::WTK::Component::Simple::Repeater;

use namespace::autoclean;

use Moose;

use Web::WTK::Markup::Element;

extends 'Web::WTK::Component::Simple';

has 'elements' => (
	is       => 'rw',
	isa      => 'ArrayRef[Any]',
	required => 1,
);

sub render {
	my ( $self, $elm ) = @_;

	$elm->clear_body;
	for my $data ( @{ $self->elements } ) {
		my $clone = $elm->clone;
		$clone->replace_body($data);
		$clone->remove_attr("wtk-id");
		$elm->child($clone);
	}

	$self->SUPER::render($elm);

	return $elm;
}

__PACKAGE__->meta->make_immutable;
1;
