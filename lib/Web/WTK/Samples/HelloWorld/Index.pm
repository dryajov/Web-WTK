package Index;

use Moose;
extends 'Web::WTK::Component::Container::Page';

use HelloWorld;

override construct => sub {
	my $self = shift;

	$self->title("HelloWorld!!!");
	my $helloworld = HelloWorld->new( id => "header" );
	$self->add($helloworld);
	$self->add(
		Web::WTK::Component::Simple::Label->new(
			id   => "text",
			text => "This is the first WTK Program ever!"
		)
	);

	return;
};

1;
