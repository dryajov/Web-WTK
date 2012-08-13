package Web::WTK::Models::Factory;

use strict;
use warnings;

use Web::WTK::Models::Closure;
use Web::WTK::Models::Scalar;

sub get_model_from {
	my ( $class, $object ) = @_;

	my $model;
	if ( eval { $object->does('Web::WTK::Models::Model') } ) {
		$model = $object;
	}
	elsif ( ref $object eq 'CODE' ) {
		$model = Web::WTK::Models::Closure->new( object => $object );
	}
	else {
		$model = Web::WTK::Models::Scalar->new( object => $object );
	}

	return $model;
}

1;
