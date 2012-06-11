package Web::WTK::Exception::ResourceExceptions;

use strict;
use warnings;

use Web::WTK::Exception::Base;

use Exception::Class (
    'Web::WTK::Exception::ResourceExceptions::UnableToOpenResource' => {
        isa         => 'Web::WTK::Exception::Base',
        description => "Something went wrong when opening the resource file.",
        message     => "Unable to open the resource!",
    }
);

1;
