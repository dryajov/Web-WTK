package Web::WTK::Handler::DefaultErrorHandler;

use Moose;

with 'Web::WTK::Roles::Handleable';

sub handle {
	my $self = shift;
	my $ctx  = shift;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
