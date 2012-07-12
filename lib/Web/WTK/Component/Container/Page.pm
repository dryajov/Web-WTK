package Web::WTK::Component::Container::Page;

use Moose;

use Web::WTK::Markup::Stream;
use Web::WTK::Markup::ElementStream;

extends 'Web::WTK::Component::Container::MarkupContainer';

has 'title' => (
	is  => 'rw',
	isa => 'Str',
);

has 'parameters' => (
	is       => 'rw',
	isa      => 'Hash::MultiValue',
	required => 1,
);

has 'context' => (
	is       => 'rw',
	isa      => 'Web::WTK::Context',
	required => 1,
);

has 'uri' => (
	is      => 'rw',
	isa     => 'URI',
	builder => '_build_page_uri',
	lazy    => 1,
	handles => {
		page_url           => 'as_string',
		page_relative_path => 'path'
	},
);

sub _build_page_uri {
	my $self = shift;

	my $host_port  = $self->context->request->host_port;
	my $scheme     = $self->context->request->scheme;
	my $page_route = $self->context->route_info->page_route;
	my $app_base   = Web::WTK->instance()->app_base;

	my $url = $scheme . "://" . $host_port . $app_base . $page_route;
	return URI->new($url)->canonical();
}

sub BUILDARGS {
	my ($class) = shift;

	my %params = @_ ? @_ : ();
	my $name = $class;
	$name =~ s/::/_/;
	$params{id} = lc $name;
	return \%params;
}

sub render {
	my $self = shift;

	my $markup = $self->markup;

	my $stream = Web::WTK::Markup::Stream->new( markup => $markup );
	my $elements = Web::WTK::Markup::ElementStream->new( stream => $stream );
	while ( my $elm = $elements->next ) {

		if ( $elm->name eq 'title' && $self->title ) {
			$elm->replace_body( $self->title );
		}
		elsif ( $elm->name eq 'body' ) {
			$self->SUPER::render($elm);    # render the body
			last;
		}

	}

	return $markup;
}

__PACKAGE__->meta->make_immutable;
1;

