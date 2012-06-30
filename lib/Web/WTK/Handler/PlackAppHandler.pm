package Web::WTK::Handler::PlackAppHandler;

use Moose;

extends 'Web::WTK::Handler';

use Web::WTK::Request::PlackRequestBuilder;

sub handle {
	my ( $self, $env ) = @_;

	my $req = Web::WTK::Request::PlackRequestBuilder->new( env => $env );
	my $res = $self->SUPER::handle($req);

	return $res;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
