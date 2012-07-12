package Web::WTK::RequestHandler::DefaultEventsHandler;

use namespace::autoclean;

use Moose;

with 'Web::WTK::RequestHandler::Handler';

sub handle {
	my ( $self, $ctx ) = @_;

	if ( $ctx->route_info->component_route ) {
		my $page = $ctx->page;

		my $component =
		  $page->get_component_by_route( $ctx->route_info->component_route );
		if ( $component
			&& eval { $component->does("Web::WTK::Events::Event") } )
		{
			$component->on_event;
		}
	}

	return;
}

__PACKAGE__->meta->make_immutable;
1;
