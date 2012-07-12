package Web::WTK::RequestHandler::DefaultErrorHandler;

use namespace::autoclean;

use Moose;

with 'Web::WTK::RequestHandler::Handler';

sub handle {
	my ( $self, $ctx ) = @_;
	return;
}


__PACKAGE__->meta->make_immutable;
1;
