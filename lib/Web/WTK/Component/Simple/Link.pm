package Web::WTK::Component::Simple::Link;

use namespace::autoclean;

use Moose;

extends 'Web::WTK::Component::Simple';

with 'Web::WTK::Roles::Addressable';
with 'Web::WTK::Events::Clickable';

has 'text' => (
	is  => 'rw',
	isa => 'Str',
);

has '_href' => (
	is  => 'rw',
	isa => 'Str',
);

# construct the component
override construct => sub {
	my $self = shift;

	my $component_url = '#';
	if ( $self->on_click ) {
		my $page_url = $self->page->page_url;

		$page_url = "$page_url/"
		  if $page_url !~ m|/$|;

		$component_url = $page_url . $self->get_component_path;
	}

	$self->_href($component_url);
};

sub render {
	my ( $self, $elm ) = @_;

	$elm->replace_body( $self->text );
	$elm->attr( "href", $self->_href );
	$elm->name("a");
	return $self->SUPER::render($elm);
}

__PACKAGE__->meta->make_immutable;
1;
