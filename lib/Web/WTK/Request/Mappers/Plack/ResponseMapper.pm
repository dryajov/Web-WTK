package Web::WTK::Request::Mappers::Plack::ResponseMapper;

use namespace::autoclean;

use Moose;

with 'Web::WTK::Request::Mappers::Mapper';

sub map {
	my ( $self, $ctx ) = @_;

	# TODO: for now "finalize" returns a plack array ref,
	# this should be moved out of the response object
	$ctx->response->finalize();
}

__PACKAGE__->meta->make_immutable;
1;
