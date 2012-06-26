package Web::WTK::Markup::Element;

use Moose;

use Readonly;
Readonly::Scalar our $RENDER_NONE => 0x0;    # don't render anything
Readonly::Scalar our $RENDER_TAG  => 0x1;    # render self only
Readonly::Scalar our $RENDER_BODY => 0x2;    # render body only
Readonly::Scalar our $RENDER_ALL  => 0x3;    # render body and self

# the parent of this element
has 'parent' => (
    is        => 'rw',
    isa       => 'Web::WTK::Markup::Element',
    predicate => 'has_parent',
    weak_ref  => 1,
);

has 'component' => (
    is       => 'rw',
    isa      => 'Web::WTK::Component',
    weak_ref => 1,
);

# name of this element e.g. whats inside the <>
has 'name' => (
    is  => 'rw',
    isa => 'Str',
);

# the body of this element, mixture of
# Web::WTK::Markup::Element objects and strings
has 'body' => (
    is      => 'rw',
    isa     => 'ArrayRef[Any]',
    default => sub { [] },
    lazy    => 1,
    clearer => 'clear_body'
);

# the attributes of this element
has 'attributes' => (
    is      => 'rw',
    isa     => 'HashRef[Any]',
    default => sub { {} },
    lazy    => 1,
);

# the namespace of the current element
has 'namespace' => (
    is  => 'rw',
    isa => 'Str',
);

# flag to control the rendering of this element
has 'render_flag' => (
    is      => 'rw',
    isa     => 'Int',
    default => $RENDER_ALL,
    lazy    => 1,
);

# helper method to get the id of this element
sub id {
    my $self = shift;

    return
      unless exists $self->attributes->{'wtk-id'};

    return $self->attributes->{'wtk-id'};
}

sub child {
    my $self = shift;

    if (@_) {
        push @{ $self->body }, @_;
    }

    return;
}

sub replace_body {
    my $self = shift;
    $self->body( [shift] );
}

sub attr {
    my $self = shift;
    my $name = shift;

    if (@_) {
        $self->attributes->{$name} = shift;
    }

    return $self->attributes->{$name};
}

sub remove_attr {
    my $self = shift;
    my $name = shift;

    return delete $self->attributes->{$name};
}

sub attrs {
    return shift->attributes;
}

sub iterator {
    my $self = shift;

    my $index = 0;
    my $size  = $#{ $self->body };
    return sub {
        return $self->body->[ $index++ ]
          if $index <= $size;

        return;
      }
}

# helper to determine if we got a MarkupElement
sub isa_elm {
    my ( $self, $elm ) = @_;
    return eval { $elm->isa(__PACKAGE__); };
}

# remove an element from the tree
sub child_remove {
    my ( $self, $elm ) = @_;

    my $size = $#{ $self->body };
    for ( my $i = 0 ; $i <= $size ; $i++ ) {
        next unless $self->isa_elm( $self->body->[$i] );
        my $child = $self->body->[$i];

        if ( $child == $elm ) {
            return splice( @{ $self->body }, $i, 1 );
        }
    }

    return;
}

sub clone {
    my ( $self, %params ) = @_;

    my %attrs = %{ $self->attributes };
    %params = ( %params, attributes => \%attrs );
    $self->meta->clone_object( $self, %params );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
