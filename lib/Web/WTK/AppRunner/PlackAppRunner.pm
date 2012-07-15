package Web::WTK::AppRunner::PlackAppRunner;

use Moose;

use Web::WTK::Context::PlackContext;
use Web::WTK::Session::PlackSessionStash;

extends 'Web::WTK::AppRunner';

sub run {
	my ( $self, $env ) = @_;

	my $ctx = Web::WTK::Context::PlackContext->new( env => $env );
	$self->session_stash(
		Web::WTK::Session::PlackSessionStash->new 
	);

	$self->SUPER::run($ctx);
}

__PACKAGE__->meta->make_immutable;
1;
