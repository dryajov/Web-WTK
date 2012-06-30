package Web::WTK::Handler;

use Moose;
use Try::Tiny;
use Module::Load;

use Web::WTK::Printers::Html;
use Web::WTK::Response;

with 'Web::WTK::Roles::Handleable';

sub _load_page {
	my ( $self, $request ) = @_;

	my $page;
	my $page_class =
	  Web::WTK->instance->get_mount( $request->path_info || '/' );

	if ($page_class) {
		load $page_class;

		my $params = $request->parameters;
		$page = $page_class->new( parameters => $params );
	}

	return $page;
}

sub handle {
	my ( $self, $request ) = @_;

	my $response =
	  Web::WTK::Response->new( status => 200, content_type => 'text/html' );
	my $page = $self->_load_page($request);

	if ( !$page ) {
		$response->status(404);
		$response->content_type('text/html');
	}
	else {
		my $markup = $page->render;
		$response->body(
			Web::WTK::Printers::Html->new( markup => $markup )->print()
		);
	}

	return $response;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
