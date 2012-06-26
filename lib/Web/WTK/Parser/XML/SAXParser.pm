package Web::WTK::Parser::XML::SAXParser;

use Moose;

use XML::SAX::ParserFactory;
use Web::WTK::Parser::XML::SAXParserHandler;

extends 'Web::WTK::Parser';

has 'parser' => (
	is      => 'rw',
	builder => '_build_parser',
);

has 'handler' => (
	is      => 'ro',
	isa     => 'Web::WTK::Parser::XML::SAXParserHandler',
	default => sub { Web::WTK::Parser::XML::SAXParserHandler->new() },
	lazy    => 1,
);

sub _build_parser {
	my ($self) = @_;

	return XML::SAX::ParserFactory->parser( Handler => $self->handler );
}

sub parse {
	my $self    = shift;
	my $content = shift;

	$self->parser->parse_file($content);
	return $self->handler->document;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
