package Web::WTK::Component::Simple::Label;

use namespace::autoclean;

use Moose;
use Moose::Util::TypeConstraints;
extends 'Web::WTK::Component::Simple';

use Web::WTK::Models::Factory;

has 'text' => (
	is      => 'rw',
	isa     => 'Str|Web::WTK::Models::Model|CodeRef',
	trigger => \&_trigger_model,
);

sub _trigger_model {
	my ( $self, $new, $old ) = @_;
	$self->set_model_from($new);
}

sub render {
	my ( $self, $elm ) = @_;

	$elm->replace_body( $self->model->value );
	return $self->SUPER::render($elm);
}

__PACKAGE__->meta->make_immutable;
1;
