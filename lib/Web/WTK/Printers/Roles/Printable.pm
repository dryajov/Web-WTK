package Web::WTK::Printers::Roles::Printable;

use Moose::Role;

has 'markup' => (
	is  => 'rw',
	isa => 'Web::WTK::Markup::Element',
);

requires 'print';

no Moose;
1;
