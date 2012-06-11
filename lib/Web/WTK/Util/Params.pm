package Web::WTK::Util::Params;

use strict;
use warnings;

use Data::Dumper;
use Carp;

sub required_params {
    my ( $params, $required ) = @_;

    croak "no required parameters were defined"
      unless defined $params;

    my %params = @$params;
    for my $param (@$required) {
        _is_required( $param, \%params );

        croak "$param rquires a defined value"
          if defined $params{$param} && $params{$param} eq '';
    }

    return;
}

sub _is_required {
    my ( $required, $params ) = @_;

    if ($params) {
        croak "$required is a required parameter!!!"
          unless grep { /^$required$/x } %$params;
    }

    return;
}

1;
