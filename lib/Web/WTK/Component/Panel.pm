package Web::WTK::Component::Panel;

use Moose;

use Web::WTK::Markup::Element;
use Web::WTK::Markup::Stream;
use Web::WTK::Markup::ElementStream;

extends 'Web::WTK::Component::MarkupContainer';

sub render {
    my ( $self, $markup ) = @_;

    my $panel_markup = $self->markup;

    my $stream = Web::WTK::Markup::Stream->new( markup => $panel_markup );
    my $elements = Web::WTK::Markup::ElementStream->new( stream => $stream );
    while ( my $elm = $elements->next ) {
        # skip everything before the 'panel' tag
        if ( $elm->name eq 'panel' ) {
            # disable this tag from going to the output
            $elm->render_flag($Web::WTK::Markup::Element::RENDER_BODY); 
            $panel_markup = $self->SUPER::render($elm)
        }
    }

    $markup->replace_body($panel_markup);
    
    return $markup;
}

__PACKAGE__->meta->make_immutable;
1;
