package Web::WTK::Component::Constructable;

use namespace::autoclean;

use Moose::Role;

# called inside the BUILD method
# used to contruct the component
requires 'construct';

1;
