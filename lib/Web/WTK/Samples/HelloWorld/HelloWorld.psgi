use strict;
use warnings;

use Plack::Builder;

use Data::Dumper;
use Cwd;

use Web::WTK;
use Web::WTK::Printers::Html;
use Web::WTK::AppRunner::PlackAppRunner;
use Web::WTK::GenericStorage::Stores::CHIStore;
use Web::WTK::Request::Mappers::Plack::RequestMapper;
use Web::WTK::Request::Mappers::Plack::ResponseMapper;

my $wtk_app = Web::WTK->initialize(
	routes => [ [ 'HelloWorld' => 'Index' => qr|/(id)/(\d+)| ] ],
	app_base     => "dryajov",
	app_src_base => getcwd(),
	runner       => Web::WTK::AppRunner::PlackAppRunner->new(
		request_mapper => Web::WTK::Request::Mappers::Plack::RequestMapper->new,
		response_mapper =>
		  Web::WTK::Request::Mappers::Plack::ResponseMapper->new,
		resources_cache => Web::WTK::GenericStorage::Stores::CHIStore->new,
	),
);

my $app = sub {
	return $wtk_app->runner->run(@_);
};

builder {

#	enable 'Debug', panels => [
#		[
#			'Profiler::NYTProf',
#			base_URL => 'http://localhost:8001/',
#			root     => '/home/dryajov/Projects/WTKHelloWorld',
#			minimal  => 1,
#		]
#	];

	enable 'Session';

	# Enable Interactive debugging
	enable "InteractiveDebugger";

	# Make Plack middleware render some static for you
	enable "Static",
	  path => qr{\.(?:js|css|jpe?g|gif|ico|png|html?|swf|txt)$},
	  root => './htdocs';

	# Let Plack care about length header
	enable "ContentLength";

	$app;
}
