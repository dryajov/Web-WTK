package Web::WTK::Runner::PlackAppRunner;

use Moose;

with 'Web::WTK::Roles::Runable';

use Web::WTK::Request::PlackRequestBuilder;

sub run {
	my ( $self, $env ) = @_;
	my $req = Web::WTK::Request::PlackRequestBuilder->new( env => $env );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
