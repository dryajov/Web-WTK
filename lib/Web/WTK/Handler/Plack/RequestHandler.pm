package Web::WTK::Handler::Plack::RequestHandler;

use Moose;

with 'Web::WTK::Roles::Handleable';

use Web::WTK::Request::PlackRequestBuilder;

sub handle {
	my ( $self, $ctx ) = @_;
	my $req = Web::WTK::Request::PlackRequestBuilder->new( env => $ctx->env );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
