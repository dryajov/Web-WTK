package Web::WTK::RequestHandler::DefaultPageRenderHandler;

use namespace::autoclean;

use Moose;

with 'Web::WTK::RequestHandler::Handler';

use Web::WTK;

sub handle {
	my ( $self, $ctx ) = @_;

	$ctx->response->status(200);
	$ctx->response->content_type('text/html');

	my $markup = $ctx->page->render;
	$ctx->response->body( Web::WTK->instance->printer->print($markup) );
	return;
}

__PACKAGE__->meta->make_immutable;
1;
