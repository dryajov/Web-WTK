package Web::WTK::Handler::DefaultEventsHandler;

use Moose;

with 'Web::WTK::Roles::Handleable';

sub handle {
	my ( $self, $ctx ) = @_;
	
	return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
