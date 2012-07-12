package Web::WTK::Session::PlackSessionStash;

use namespace::autoclean;

use Moose;

with 'Web::WTK::Session::SessionStash';

sub get {
	my ( $self, $ctx ) = @_;

	my $session;

	if ( $self->is_valid ) {

		$session = $ctx->env->{'psgix.session'}->{session};

		if ( !$session ) {
			$session = Web::WTK::Session->new(
				id      => $ctx->env->{'psgix.session.options'}->{id},
				context => $ctx
			);

			$ctx->env->{'psgix.session'}->{session} = $session;
		}
	}

	return $session;
}

sub invalidate {
	my ( $self, $ctx ) = @_;

	$self->is_valid(0);
	delete $ctx->env->{'psgix.session'};
	$ctx->env->{'psgix.session.options'}->{expire} = 1;

	return;
}

sub detach {
	my ( $self, $ctx ) = @_;
}

__PACKAGE__->meta->make_immutable;
1;
