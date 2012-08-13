package Web::WTK::Component::Simple::Link;

use namespace::autoclean;

use Moose;

extends 'Web::WTK::Component::Simple';

with 'Web::WTK::Roles::Addressable';
with 'Web::WTK::Events::Clickable';

has 'text' => (
	is      => 'rw',
	isa     => 'Str',
	trigger => \&_trigger_model,
);

sub _trigger_model {
	my ( $self, $new, $old ) = @_;
	$self->set_model_from($new);
}

sub _href {
	my $self = shift;

	my $href = '#';
	if ( $self->on_click ) {
		$href = $self->get_component_url;
	}

	return $href;
}

sub render {
	my ( $self, $elm ) = @_;

	$elm->replace_body( $self->model->value );
	$elm->attr( "href", $self->_href );
	$elm->name("a");
	return $self->SUPER::render($elm);
}

__PACKAGE__->meta->make_immutable;
1;
