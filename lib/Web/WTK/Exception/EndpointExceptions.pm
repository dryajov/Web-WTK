package Web::WTK::Exception::EndpointExeptions;

use strict;
use warnings;

use Web::WTK::Exception::Base;

use Exception::Class (
    'Web::WTK::Exception::EndpointExeptions::PageNotFound' => {
        isa         => 'Web::WTK::Exception::Base',
        message     => 'Requested location was not found',
        description => "The requested page or location was not found on the server"
    },
    'Web::WTK::Exception::EndpointExeptions::InternalError' => {
        isa         => 'Web::WTK::Exception::Base',
        message     => 'An internal error has occured!',
        description => "The server encountered an internal error"
    }
);

1;
