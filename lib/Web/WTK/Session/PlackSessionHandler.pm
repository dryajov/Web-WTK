package Web::WTK::Session::PlackSessionHandler;

use Moose;

with 'Web::WTK::Session::Roles::Handleable';

sub handle {
	my ( $self, $ctx ) = @_;

	my $session = $ctx->env->{'psgix.session'}->{session};

	if ( !$session ) {
		$session =
		  Web::WTK::Session->new(
			id => $ctx->env->{'psgix.session.options'}->{id} );

		$ctx->env->{'psgix.session'}->{session} = $session;
	}

	return $session;
}

sub invalidate {
	my ( $self, $ctx ) = @_;

	delete $ctx->env->{'psgix.session'};
	$ctx->env->{'psgix.session.options'}->{expire} = 1;

	return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
