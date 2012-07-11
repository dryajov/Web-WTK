package Web::WTK::Handler::DefaultPageRenderHandler;

use Moose;

with 'Web::WTK::Roles::Handleable';

use Web::WTK;
use Web::WTK::Printers::Html;

sub handle {
	my ( $self, $ctx ) = @_;

	$ctx->response->status(200);
	$ctx->response->content_type('text/html');

	my $markup = $ctx->page->render;
	$ctx->response->body(
		Web::WTK->instance->printer->print($markup)
	);

	return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
