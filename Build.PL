use 5.008_001;
use strict;
use Module::Build::Tiny 0.035;
use ExtUtils::Install qw( pm_to_blib );

Build_PL();
{
  my $path = 'lib/Smoke/resources/templates/error.pl';
  pm_to_blib({ $path => "blib/${path}" });
}
