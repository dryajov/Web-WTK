use strict;
use warnings;

use Data::Dumper;
use Web::WTK::Printers::Html;
use Index;
use HelloWorld;
use Hash::MultiValue;

my $container = Index->new( parameters => Hash::MultiValue->new );
my $markup = $container->render();
print Web::WTK::Printers::Html->new( markup => $markup )->print();

1;
