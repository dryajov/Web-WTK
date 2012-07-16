package Web::WTK::GenericStorage::Storage;

use namespace::autoclean;

use Moose::Role;

#TODO: rethink interface

requires 'get';
requires 'set';
requires 'remove';
requires 'is_empty';
requires 'count';
requires 'get_pairs';

1;
