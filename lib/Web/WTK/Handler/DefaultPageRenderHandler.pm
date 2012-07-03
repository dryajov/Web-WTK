package Web::WTK::Handler::DefaultPageRenderHandler;

use Moose;

with 'Web::WTK::Roles::Handleable';

use Try::Tiny;
use Module::Load;

use Web::WTK;
use Web::WTK::Printers::Html;
use Web::WTK::Exception::EndpointExceptions;

sub handle {
	my ( $self, $ctx ) = @_;

	$ctx->response->status(200);
	$ctx->response->content_type('text/html');

	my $markup = $ctx->page->render;
	$ctx->response->body(
		Web::WTK->instanse->print($markup)
	);

	return 1;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
