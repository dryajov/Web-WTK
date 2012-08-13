use strict;
use Plack::Runner;

my $runner = Plack::Runner->new;
my @ARGV = (qw/-p 8001 HelloWorld.psgi/);
$runner->parse_options(@ARGV);
$runner->run;

1;
