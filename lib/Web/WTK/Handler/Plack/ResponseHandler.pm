package Web::WTK::Handler::Plack::ResponseHandler;

use Moose;

with 'Web::WTK::Roles::Handleable';

sub handle {
	my ( $self, $ctx ) = @_;

	# TODO: for now "finalize" returns a plack array ref,
	# this should be moved out of the response object
	$ctx->response->finalize();
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
