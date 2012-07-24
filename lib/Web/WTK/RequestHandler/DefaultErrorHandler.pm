package Web::WTK::RequestHandler::DefaultErrorHandler;

use namespace::autoclean;

use Moose;

with 'Web::WTK::RequestHandler::Handler';

sub handle {
	my ( $self, $ctx ) = @_;

	# TODO: Reimplement. This is simply a
	# place holder so that we can propage the
	# error to the browser.
	# This would have to handle all error related stuff
	# it would have to figure out the error type
	# and then probably trigger a secondary *internal* request
	# that would among other things, return an error page
	if ( eval { $ctx->error->can("trace") } ) {
		die $ctx->error->trace->as_string;
	}
	else {
		die $ctx->error;
	}

	return;
}

__PACKAGE__->meta->make_immutable;
1;
