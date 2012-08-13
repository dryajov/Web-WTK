package HelloWorld;

use Moose;

extends 'Web::WTK::Component::Container::Panel';

use Web::WTK::Component::Simple::Label;
use Web::WTK::Component::Simple::List;
use Web::WTK::Component::Simple::Link;
use Web::WTK::Component::Simple::Repeater;

override construct => sub {
	my $self = shift;

	$self->add(
		Web::WTK::Component::Simple::Label->new(
			id   => "user",
			text => sub { "Dmitriy Ryajov" }
		)
	);
	$self->add(
		Web::WTK::Component::Simple::List->new(
			id   => "list",
			list => [qw(one two tree four five)]
		)
	);

	my $count = 0;
	$self->add(
		Web::WTK::Component::Simple::Link->new(
			id       => "link_address",
			text     => "Click Me!",
			on_click => sub {
				my $self = shift;

				$self->text("I was clicked times: $count");
				$count++;

				# possitive return from event handler means
				# that the page/component gets re-rendered
				return 0;
			}
		)
	);

	$self->add(
		Web::WTK::Component::Simple::Repeater->new(
			id       => "repeater",
			elements => [qw(one two tree four five)]
		)
	);
};

1;
