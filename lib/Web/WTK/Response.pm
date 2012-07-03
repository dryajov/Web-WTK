package Web::WTK::Response;

use Moose;

use Scalar::Util;
use IO::Handle;
use Carp;

has 'status' => (
	is      => 'rw',
	isa     => 'Int',
	default => "200",
	lazy    => 1,
);

has 'headers' => (
	is      => 'rw',
	isa     => 'HTTP::Headers',
	default => sub { HTTP::Headers->new },
	handles => [qw/header content_type content_length content_encoding/],
	lazy    => 1,
);

has 'body' => (
	is  => 'rw',
	isa => 'IO::Handle | Str',
);

has 'cookies' => (
	traits  => ['Hash'],
	is      => 'rw',
	isa     => 'HashRef',
	default => sub { {} },
	lazy    => 1,
	handles => {
		set_cookie    => 'set',
		get_cookie    => 'get',
		has_cookies   => 'is_empty',
		num_cookies   => 'count',
		delete_cookie => 'delete',
		cookies_pairs => 'kv',
	}
);

sub redirect {
	my $self = shift;

	if (@_) {
		my $url = shift;
		my $status = shift || 302;
		$self->location($url);
		$self->status($status);
	}

	return $self->location;
}

sub location {
	my $self = shift;

	$self->header( 'Location' => @_ );
}

sub finalize {
	my $self = shift;
	Carp::croak "missing status" unless $self->status();

	my $headers = $self->headers->clone;
	$self->_finalize_cookies($headers);

	return [
		$self->status,
		+[
			map {
				my $k = $_;
				map {
					my $v = $_;
					$v =~ s/\015\012[\040|\011]+/chr(32)/ge
					  ;    # replace LWS with a single SP
					$v =~ s/\015|\012//g
					  ;    # remove CR and LF since the char is invalid here

					( $k => $v )
				} $headers->header($_);

			  } $headers->header_field_names
		],
		$self->_body,
	];
}

sub _body {
	my $self = shift;
	my $body = $self->body;
	$body = [] unless defined $body;
	if ( !ref $body
		or Scalar::Util::blessed($body)
		&& overload::Method( $body, q("") )
		&& !$body->can('getline') )
	{
		return [$body];
	}
	else {
		return $body;
	}
}

sub _finalize_cookies {
	my ( $self, $headers ) = @_;

	while ( my ( $name, $val ) = $self->cookies_pairs ) {
		my $cookie = $self->_bake_cookie( $name, $val );
		$headers->push_header( 'Set-Cookie' => $cookie );
	}
}

sub _bake_cookie {
	my ( $self, $name, $val ) = @_;

	return '' unless defined $val;
	$val = { value => $val } unless ref $val eq 'HASH';

	my @cookie =
	  (     URI::Escape::uri_escape($name) . "="
		  . URI::Escape::uri_escape( $val->{value} ) );

	push @cookie, "domain=" . $val->{domain} if $val->{domain};
	push @cookie, "path=" . $val->{path}     if $val->{path};

	push @cookie, "expires=" . $self->_date( $val->{expires} )
	  if $val->{expires};

	push @cookie, "secure"   if $val->{secure};
	push @cookie, "HttpOnly" if $val->{httponly};

	return join "; ", @cookie;
}

my @MON  = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
my @WDAY = qw( Sun Mon Tue Wed Thu Fri Sat );

sub _date {
	my ( $self, $expires ) = @_;

	if ( $expires =~ /^\d+$/ ) {

		# all numbers -> epoch date
		# (cookies use '-' as date separator, HTTP uses ' ')
		my ( $sec, $min, $hour, $mday, $mon, $year, $wday ) = gmtime($expires);
		$year += 1900;

		return sprintf( "%s, %02d-%s-%04d %02d:%02d:%02d GMT",
			$WDAY[$wday], $mday, $MON[$mon], $year, $hour, $min, $sec );
	}

	return $expires;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
