package Web::WTK::Events::Event;

use namespace::autoclean;

use Moose::Role;

has '_handler' => (
	is       => 'rw',
	isa      => 'CodeRef',
	init_arg => undef,
);

sub on_event {
	my $self = shift;

	my $res;
	$res = $self->_handler->( $self, @_ )
	  if $self->_handler;

	return $res;
}

1;
