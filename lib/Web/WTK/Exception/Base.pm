package Web::WTK::Exception::Base;

use strict;
use warnings;

use Exception::Class (
    'Web::WTK::Exception::Base' => {
        description => "Base exception type for all WTK exceptions.",
        message     => 'An error has occured!',
    },
);

1;
