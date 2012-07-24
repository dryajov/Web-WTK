package Web::WTK::Request;

use namespace::autoclean;

use Moose;
use Moose::Util::TypeConstraints;

use HTTP::Body;
use URI;
use Hash::MultiValue;
use HTTP::Headers;
use IO::Handle;

my $id;

has 'id' => (
	is      => 'ro',
	isa     => 'Int',
	default => sub { $id++ },
);

has 'method' => (
	is  => 'rw',
	isa => enum(
		qw/ OPTIONS GET HEAD POST PUT
		  DELETE TRACE CONNECT PATCH/
	),
);

has 'address' => (
	is  => 'rw',
	isa => 'Str',
);

has 'remote_host' => (
	is  => 'rw',
	isa => 'Str',
);

has 'request_uri' => (
	is  => 'rw',
	isa => 'Str',
);

has 'query_parameters' => (
	is  => 'rw',
	isa => 'Hash::MultiValue',
);

has 'base' => (
	is  => 'rw',
	isa => 'URI',
);

has 'body_parameters' => (
	is      => 'rw',
	isa     => 'Hash::MultiValue',
	default => sub {
		my $params = $_[0]->body ? $_[0]->body->param : {};
		Hash::MultiValue->from_mixed($params);
	},
	lazy => 1,
);

has 'content' => (
	is  => 'rw',
	isa => 'Str',
);

has 'raw_body' => (
	is      => 'rw',
	isa     => 'Str',
	default => sub { $_[0]->content },
	lazy    => 1,
);

has 'cookies' => (
	is      => 'rw',
	isa     => 'HashRef',
	default => sub { {} },
);

has 'headers' => (
	is      => 'rw',
	isa     => 'HTTP::Headers',
	handles => [
		qw/content_encoding content_length content_type header referer user_agent/
	],
);

has 'query_keywords' => (
	is  => 'rw',
	isa => 'ArrayRef',
);

has 'parameters' => (
	is      => 'rw',
	isa     => 'Hash::MultiValue',
	default => sub {
		my $s = shift;
		Hash::MultiValue->new( $s->body_parameters->flatten,
			$s->query_parameters->flatten );
	},
	lazy => 1,
);

has 'url_params' => (
	is      => 'rw',
	isa     => 'Hash::MultiValue',
	trigger => \&_set_url_params,
);

sub _set_url_params {
	my ( $self, $new, $old ) = @_;

	if ( $new && !$old) {
		$new->each( sub { $self->parameters->add( $_[0], $_[1] ) } );
	}
}

has 'path_info' => (
	is  => 'rw',
	isa => 'Str',
);

has 'script_name' => (
	is  => 'rw',
	isa => 'Str',
);

has 'protocol' => (
	is  => 'rw',
	isa => 'Str',
);

has 'secure' => (
	is      => 'rw',
	isa     => 'Bool',
	default => sub { $_[0]->scheme eq 'https' },
	lazy    => 1,
);

has 'uri' => (
	is      => 'rw',
	isa     => 'URI',
	handles => {
		hostname  => 'host',
		path      => 'path',
		ihost     => 'ihost',
		port      => 'port',
		scheme    => 'scheme',
		host_port => 'host_port',
	}
);

has 'user' => (
	is  => 'rw',
	isa => 'Str|Undef',
);

has 'raw_body' => (
	is  => 'rw',
	isa => 'Str'
);

has 'body' => (
	is  => 'rw',
	isa => 'HTTP::Body'
);

has 'input' => (
	is      => 'rw',
	isa     => 'HTTP::Body|Undef',
	default => sub { $_[0]->body },
	lazy    => 1
);

has 'input_handle' => (
	is  => 'rw',
	isa => 'IO::Handle',
);

has 'uploads' => (
	is      => 'rw',
	isa     => 'Hash::MultiValue',
	default => sub { Hash::MultiValue->new },
	lazy    => 1,
);

__PACKAGE__->meta->make_immutable;
1;
