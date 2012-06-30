package Web::WTK::Roles::Addressable;

use Moose::Role;

requires 'parent';

sub get_component_url {
    my $self = shift;

    my $url = "";
    my $parent = $self->parent;
    do{
        $url = $parent->id . "/" . $url;
    }while($parent = $parent->parent);
    
    $url .= $self->id;
    return $url;
}

no Moose::Role;
1;
