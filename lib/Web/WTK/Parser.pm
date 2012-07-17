package Web::WTK::Parser;

use namespace::autoclean;

use Moose::Role;

# the root of the parsed doc
has 'document' => (
	is      => 'rw',
	isa     => 'Web::WTK::Markup::Element',
	builder => 'parse',
	lazy    => 1,
);

requires 'parse';
1;
