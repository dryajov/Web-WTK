package Web::WTK::Events::Clickable;

use namespace::autoclean;

use Moose::Role;
with 'Web::WTK::Events::Event';

has 'on_click' => (
	is => 'rw',
	isa => 'CodeRef',
	trigger => \&_set_handler,
);

sub _set_handler {
	my ( $self, $handler, $old_handler ) = @_;

	$self->_handler($handler);
}

1;
