use Smoke;
use Test::More;
use Test::Exception;
use Smoke::Util ':all';

my $template;
lives_ok { $template = take_in 'error.pl' };
is $template->({ message => 'HELLO' }), << 'EOS';

<!DOCTYPE html>
<html>
  <head>
    <title>Smoke - error</title>
  </head>
  <body>
    <span style="color:red"><strong>『HELLO』</strong></span>
  </body>
</html>
EOS

dies_ok { take_in 'hogehoge.pl' };
ok $@->isa('Smoke::Template::FindException');
is $@->inc->@*, 3;

lives_ok { validate_values { a => 10, b => 20 }, [qw( a  b )] };
dies_ok { validate_values {}, [qw( a b )] };
like $@, qr!キーが足りません\(a, b\)!;

done_testing;
