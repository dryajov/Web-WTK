package Web::WTK::Parser::XML::SAX::Parser;

use namespace::autoclean;

use Moose;

use XML::SAX::ParserFactory;
use Web::WTK::Parser::XML::SAX::ParserHandler;

with 'Web::WTK::Parser';

has 'parser' => (
	is      => 'rw',
	builder => '_build_parser',
);

sub _build_parser {
	my ($self) = @_;

	return XML::SAX::ParserFactory->parser( Handler => $self->handler );
}

has 'handler' => (
	is      => 'ro',
	isa     => 'Web::WTK::Parser::XML::SAX::ParserHandler',
	default => sub { Web::WTK::Parser::XML::SAX::ParserHandler->new() },
	lazy    => 1,
);

sub parse {
	my $self    = shift;
	my $content = shift;

	$self->parser->parse_file($content);
	return $self->handler->document;
}

__PACKAGE__->meta->make_immutable;
1;
