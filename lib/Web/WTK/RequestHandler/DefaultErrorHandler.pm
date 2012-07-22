package Web::WTK::RequestHandler::DefaultErrorHandler;

use namespace::autoclean;

use Moose;

with 'Web::WTK::RequestHandler::Handler';

sub handle {
	my ( $self, $ctx ) = @_;

	if ( eval {$ctx->error->can("trace")}) {
		die $ctx->error->trace->as_string;	
	} else {
		die $ctx->error;
	}
	
	return;
}

__PACKAGE__->meta->make_immutable;
1;
