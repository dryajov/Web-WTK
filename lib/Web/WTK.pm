package Web::WTK;

use strict;
use warnings;

use Web::WTK::Parser;

sub new {
    my $class = shift;

    bless {
        _pages => [],    # the top level components
    }, $class;
}

sub add {
    my $self = shift;

    push @{ $self->{_pages} }, shift;
}

sub render {
    my $self = shift;

    my @pages;
    for my $page ( @{ $self->{_pages} } ) {
        my $rendered = $self->_internal_render($page);

        # render each component
        push @pages, $rendered;
    }

    return \@pages;
}

#===  CLASS METHOD  ============================================================
#        CLASS: WTK
#       METHOD: _internal_render
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: Recursively renders attached conmponents. This method will call parser's
#               get_next_wtk_element which returns HTMLELmenet, if an element is
#               returned then, the current component is searched for a corresponding
#               child component with the same id, if found and it's a MarkupContainer
#               this method is called recursivelly with the found component as parameter
#               if not, then, the found component's render method is called with the
#               HTMLElement as a parameter.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _internal_render {
    my $self      = shift;
    my $component = shift;

    # create a new parser
    my $parser = new Parser( $component->file );

    while ( my $element = $parser->get_next_wtk_element ) {
        my $found = $component->get_component_by_id( $element->attr("wtk-id") );
        if ( $found->isa("Web::WTK::Component:MarkupContainer") ) {
            $element = $self->_internal_render($found);
        }
        return $found->render($element);
    }
}

1;

