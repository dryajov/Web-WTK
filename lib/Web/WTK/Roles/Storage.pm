package Web::WTK::Roles::Storage;

use Moose::Role;

requires 'get';
requires 'put';
requires 'exists';

no Moose::Role;
1;
