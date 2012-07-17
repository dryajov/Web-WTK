package Web::WTK::Component::Constructable;

use namespace::autoclean;

use Moose::Role;

# used to contruct the component
requires 'construct';

1;
