package Web::WTK::Events::Clickable;

use namespace::autoclean;

use Moose::Role;
with 'Web::WTK::Events::Event';

has 'on_click' => (
	is  => 'rw',
	isa => 'CodeRef',
);

sub on_event {
	my $self = shift;

	my $res;
	$res = $self->on_click->( $self, @_ )
	  if $self->on_click;

	return $res;
}

1;
