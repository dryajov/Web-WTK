package Web::WTK::Session::SessionStash;

use namespace::autoclean;

use Moose::Role;

has 'is_valid' => (
	is      => 'rw',
	isa     => 'Bool',
	default => 1,
);

requires 'get';
requires 'invalidate';
requires 'detach';

1;
