package Web::WTK::Exception::MarkupExceptions;

use strict;
use warnings;

use Web::WTK::Exception::Base;

use Exception::Class (
    'Web::WTK::Exception::MarkupExceptions::InvalidComponentMarkup' => {
        isa         => 'Web::WTK::Exception::Base',
        message     => 'Invalid markup structure detected!',
        description => "Your markup file does not correspond with the current component structure." .
                       "You might be tiying the wrong elements together.",
    }
);

1;
