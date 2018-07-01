use Smoke;
use HTTP::Request::Common;
use Plack::Test;
use Test2::Bundle::More;
use Test2::Plugin::UTF8;
use Encode qw( decode_utf8 );

sub trim { my $s = shift; $s =~ s{^\n|\n$}{}gr; }

package Controller {

  use Mouse;
  use Smoke;
  extends qw( Smoke::Controller );

  sub root($self) {
    $self->render_error('おはよーーー');
  }

  __PACKAGE__->meta->make_immutable;

}

package App {

  use Mouse;
  use Smoke;
  with 'Smoke::App';

  sub dispatch($self) {
    my $router = $self->router;
    my $root = $router->root(path => '', controller => 'Controller');
    $root->any('/');
  }

  __PACKAGE__->meta->make_immutable;

}

my $app    = App->new;
my $tester = Plack::Test->create($app->run);
my $res    = $tester->request(GET '/');
is trim(decode_utf8 $res->content), trim(q{
<!DOCTYPE html>
<html>
  <head>
    <title>Smoke - error</title>
  </head>
  <body>
    <span style="color:red"><strong>『おはよーーー』</strong></span>
  </body>
</html>
});

ok 1;

done_testing;
