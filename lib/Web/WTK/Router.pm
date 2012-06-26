package Web::WTK::Router;

use Moose;

sub process {
	my ($self, $request);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
