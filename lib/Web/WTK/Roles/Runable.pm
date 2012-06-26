package Web::WTK::Roles::Runable;

use Moose::Role;

has 'running' => (
	is  => 'rw',
	isa => 'Bool',
);

requires 'run';

no Moose;
1;
