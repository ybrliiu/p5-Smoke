use Smoke;
use Test2::V0 -no_pragmas => 1;
use Test::LoadAllModules;

all_uses_ok(search_path => 'Smoke');

done_testing;

