package Web::WTK::Request::Mappers::Plack::RequestMapper;

use namespace::autoclean;

use Moose;

with 'Web::WTK::Request::Mappers::Mapper';

use Web::WTK::Request::PlackRequestBuilder;

sub map {
	my ( $self, $ctx ) = @_;
	my $req = Web::WTK::Request::PlackRequestBuilder->new( env => $ctx->env );
}

__PACKAGE__->meta->make_immutable;
1;
