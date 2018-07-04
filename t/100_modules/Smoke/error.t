use Smoke;
use Test2::V0 -no_pragmas => 1;
use Test2::Plugin::UTF8;

use Smoke::Error;

sub trim($str) { $str =~ s/^\s|\s$//gr }

sub some_func {
  Smoke::Error->new(cause => 'nothing');
}

ok( my $error = eval { Smoke::Error->new(cause => 'testing') } );
ok not $@;
like trim($error->description), trim(q{
@@ Smoke::Error @@

cause : testing

stack_trace : 
testing at t/100_modules/Smoke/error.t line 13.
	eval {...} called at t/100_modules/Smoke/error.t line 13
});

done_testing;
