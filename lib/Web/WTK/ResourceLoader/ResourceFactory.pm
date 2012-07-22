package Web::WTK::ResourceLoader::ResourceFactory;

use Moose;

use Web::WTK;
use Web::WTK::ResourceLoader::FileSystem;
use Web::WTK::ResourceLoader::PackageResource;
use Web::WTK::Parser::XML::SAX::Parser;

sub load_markup {
	my ( $class, $resource_name ) = @_;

	my $cache  = Web::WTK->instance->runner->resources_cache;
	my $markup = $cache->get($resource_name);
	if ( !$markup ) {
		my $resource;
		if ( Web::WTK->instance->resources_path ) {
			$resource = Web::WTK::ResourceLoader::FileSystem->new(
				path      => Web::WTK->instance->resources_path,
				extension => 'html',
				name      => $resource_name,
			)->open;
		}
		else {

			$resource =
			  Web::WTK::ResourceLoader::PackageResource->new(
				package_name => $resource_name )->open;
		}

		if ($resource) {

			# TODO: Probably a parser pool would be more efficient here
			my $parser = Web::WTK::Parser::XML::SAX::Parser->new();
			$markup = $parser->parse($resource);
			$cache->set( $resource_name, $markup );
		}
	}

	return $markup;
}

__PACKAGE__->meta->make_immutable;
1;
