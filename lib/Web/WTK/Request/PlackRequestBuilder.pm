package Web::WTK::Request::PlackRequestBuilder;

use Moose;

extends 'Web::WTK::Request';

use URI::Escape;
use Hash::MultiValue;
use HTTP::Headers;
use Web::WTK::Request::Upload;

use Web::WTK::Request;

has 'env' => (
	is       => 'rw',
	isa      => 'HashRef',
	required => 1,
);

has '_cookie_str' => (
	is  => 'rw',
	isa => 'Str',
);

has '_input_buffered' => (
	is  => 'rw',
	isa => 'Bool',
);

sub BUILD {
	my $self = shift;

	$self->body( $self->_parse_request_body );
	$self->cookies( $self->_parse_cookies );
	$self->uri( $self->_parse_uri );
	$self->content( $self->_parse_content );
	$self->uploads( $self->_parse_uploads );
	$self->headers( $self->_parse_headers );

	$self->request_uri( $self->env->{REQUEST_URI} );
	$self->address( $self->env->{REMOTE_ADDR} );

	$self->remote_host(
		exists $self->env->{REMOTE_HOST} && defined $self->env->{REMOTE_HOST}
		? $self->env->{REMOTE_HOST}
		: $self->env->{REMOTE_ADDR}
	);

	$self->method( $self->env->{REQUEST_METHOD} );
	$self->protocol( $self->env->{SERVER_PROTOCOL} );
	$self->request_uri( $self->env->{REQUEST_URI} );
	$self->path_info( $self->env->{PATH_INFO} );
	$self->path( $self->path_info || "/" );
	$self->script_name( $self->env->{SCRIPT_NAME} );
	$self->scheme( $self->env->{'psgi.url_scheme'} );

	my $input = IO::Handle->new->fdopen( $self->env->{'psgi.input'}, "r" );
	$self->input_handle($input);

	$self->query_parameters( Hash::MultiValue->new( $self->uri->query_form ) );
	$self->base( URI->new( $self->_uri_base )->canonical );
	$self->user( $self->env->{REMOTE_USER} );
}

sub _parse_headers {
	my $self = shift;
	my $headers;
	if ( !defined $self->{headers} ) {
		my $env = $self->env;
		$headers = HTTP::Headers->new(
			map {
				( my $field = $_ ) =~ s/^HTTPS?_//;
				( $field => $env->{$_} );
			  }
			  grep { /^(?:HTTP|CONTENT|COOKIE)/i } keys %$env
		);
	}
	return $headers;
}

sub _uri_base {
	my $self = shift;

	my $env = $self->env;

	my $uri =
	  ( $env->{'psgi.url_scheme'} || "http" ) . "://"
	  . (
		$env->{HTTP_HOST}
		  || (( $env->{SERVER_NAME} || "" ) . ":"
			. ( $env->{SERVER_PORT} || 80 ) )
	  ) . ( $env->{SCRIPT_NAME} || '/' );

	return $uri;
}

sub _parse_content {
	my $self = shift;

	unless ( $self->_input_buffered ) {
		$self->_parse_request_body;
	}

	my $fh = $self->input or return '';
	my $cl = $self->env->{CONTENT_LENGTH} or return '';
	$fh->read( my ($content), $cl, 0 );
	$fh->seek( 0, 0 );

	return $content;
}

sub _parse_uri {
	my $self = shift;

	my $base = $self->_uri_base;

	# We have to escape back PATH_INFO in case they include stuff like
	# ? or # so that the URI parser won't be tricked. However we should
	# preserve '/' since encoding them into %2f doesn't make sense.
	# This means when a request like /foo%2fbar comes in, we recognize
	# it as /foo/bar which is not ideal, but that's how the PSGI PATH_INFO
	# spec goes and we can't do anything about it. See PSGI::FAQ for details.
	# http://github.com/miyagawa/Plack/issues#issue/118
	my $path_escape_class = '^A-Za-z0-9\-\._~/';

	my $path = URI::Escape::uri_escape( $self->env->{PATH_INFO} || '',
		$path_escape_class );

	$path .= '?' . $self->env->{QUERY_STRING}
	  if defined $self->env->{QUERY_STRING} && $self->env->{QUERY_STRING} ne '';

	$base =~ s!/$!! if $path =~ m!^/!;

	return URI->new( $base . $path )->canonical;
}

sub _parse_cookies {
	my $self = shift;

	return {} unless $self->env->{HTTP_COOKIE};

	my $cookie_str = $self->_cookie_str;

	# HTTP_COOKIE hasn't changed: reuse the parsed cookie
	if ( %{ $self->cookies }
		&& $cookie_str eq $self->env->{HTTP_COOKIE} )
	{
		return $self->cookies;
	}

	$cookie_str = $self->env->{HTTP_COOKIE};

	my %results;
	my @pairs = grep /=/, split "[;,] ?", $self->_cookie_str;
	for my $pair (@pairs) {

		# trim leading trailing whitespace
		$pair =~ s/^\s+//;
		$pair =~ s/\s+$//;

		my ( $key, $value ) = map URI::Escape::uri_unescape($_),
		  split( "=", $pair, 2 );

		# Take the first one like CGI.pm or rack do
		$results{$key} = $value unless exists $results{$key};
	}

	$self->_cookie_str($cookie_str);

	\%results;
}

sub _parse_request_body {
	my $self = shift;

	my $ct = $self->env->{CONTENT_TYPE};
	my $cl = $self->env->{CONTENT_LENGTH};
	return if ( !$ct && !$cl );

	my $body = HTTP::Body->new( $ct, $cl );

	# HTTP::Body will create temporary files in case there was an
	# upload.  Those temporary files can be cleaned up by telling
	# HTTP::Body to do so. It will run the cleanup when the request
	# env is destroyed. That the object will not go out of scope by
	# the end of this sub we will store a reference here.
	$body->cleanup(1);

	my $input = $self->input_handle;

	my $buffer;
	if ( $self->_input_buffered ) {

		# Just in case if input is read by middleware/apps beforehand
		$input->seek( 0, 0 );
	}

	$buffer = Plack::TempBuffer->new($cl);

	my $spin = 0;
	while ($cl) {
		$input->read( my $chunk, $cl < 8192 ? $cl : 8192 );
		my $read = length $chunk;
		$cl -= $read;
		$body->add($chunk);
		$buffer->print($chunk) if $buffer;

		if ( $read == 0 && $spin++ > 2000 ) {
			Carp::croak
"Bad Content-Length: maybe client disconnect? ($cl bytes remaining)";
		}
	}

	if ($buffer) {
		$self->_input_buffered(1);
		$self->env->{'psgi.input'} = $buffer->rewind;
	}
	else {
		$input->seek( 0, 0 );
	}

	return $body;
}

sub _parse_uploads {
	my $self = shift;

	my $uploads = $self->body ? $self->body->upload : undef;
	return Hash::MultiValue->new unless $uploads;

	my @uploads = Hash::MultiValue->from_mixed($uploads)->flatten;
	my @obj;
	while ( my ( $k, $v ) = splice @uploads, 0, 2 ) {
		push @obj, $k, $self->_make_upload($v);
	}

	return Hash::MultiValue->new(@obj);
}

sub _make_upload {
	my ( $self, $upload ) = @_;
	my %copy = %$upload;
	$copy{headers} = HTTP::Headers->new( %{ $upload->{headers} } );
	Web::WTK::Request::Upload->new(%copy);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

