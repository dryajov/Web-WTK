package Web::WTK::Parser::XML::SAXParserHandler;

use Web::WTK::Markup::Element;

use parent qw/XML::SAX::Base/;
use Data::Dumper;

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(@_);
    $self->{elements} = [];       # stack of elements
    $self->{document} = undef;    # the parsed document

    return bless $self, $class;
}

sub document {
    return shift->{document};
}

sub start_element {
    my $self    = shift;
    my $sax_elm = shift;

    push @{ $self->{elements} }, _map_to_elm($sax_elm);

    return;
}

sub characters {
    my $self = shift;
    my $data = shift;

    my $elm = $self->{elements}->[-1];
    $elm->child( $data->{Data} );

    return;
}

sub end_element {
    my ( $self, $element ) = @_;
    if ( $element->{LocalName} eq "expand" ) {
        $self->{in_include}--;
        return;
    }

    my $elm    = pop @{ $self->{elements} };
    my $parent = $self->{elements}->[-1];

    if ($parent) {
        $parent->child($elm);
    }
    else {
        $self->{document} = $elm;
    }

    $elm->parent($parent) if $parent;
    return;
}

sub _map_to_elm {
    my $sax_elm = shift;

    my %attributes;
    while ( my ( $key, $val ) = each %{ $sax_elm->{Attributes} } ) {
        $attributes{ $val->{Name} } = $val->{Value};
    }

    my $elm = Web::WTK::Markup::Element->new(
        name       => $sax_elm->{LocalName},
        attributes => \%attributes,
    );

    return $elm;
}

1;
