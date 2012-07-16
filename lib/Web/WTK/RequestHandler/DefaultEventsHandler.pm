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
		my $does_event = eval { $component->does("Web::WTK::Events::Event") };
		if ( $component && $does_event ) {

			# if the event handled returns possitive,
			# we want to rerender the page/componnent
			if ( $component->on_event ) {
				$component->rendered(0);
				$ctx->route_info->inc_render_count;
				my $route_info = $ctx->route_info;
				my $page_cache = $route_info->get_page_route_with_render_count;
				$ctx->session->page_store->set_page( $page_cache,
					$component->page );
			}
		}
	}

	return;
}

__PACKAGE__->meta->make_immutable;
1;
