package Web::WTK::Roles::Storage;

use namespace::autoclean;

use Moose::Role;

requires 'get';
requires 'put';
requires 'exists';

1;
