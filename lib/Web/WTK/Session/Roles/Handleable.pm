package Web::WTK::Session::Roles::Handleable;

use Moose::Role;

with 'Web::WTK::Roles::Handleable';

requires 'invalidate';

no Moose::Role;
1;
