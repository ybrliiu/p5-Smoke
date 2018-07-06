use Smoke;
use Test2::V0 -no_pragmas => 1;
# use Test2::Plugin::UTF8;
use Plack::Test;
use HTTP::Request::Common;
use Encode qw( decode_utf8 );

sub trim { my $s = shift; $s =~ s{^\n|\n$}{}gr; }

package Controller {

  use Mouse;
  use Smoke;
  extends qw( Smoke::Controller );

  sub root($self) {
    $self->render_error('おはよーーー');
  }

  sub json($self) {
    my $hash = +{ name => '四条桃花' };
    $self->render_json($hash);
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
    $root->any('/json');
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

my $res2 = $tester->request(GET '/json');
is trim(decode_utf8 $res2->content), trim(q{
{"name":"四条桃花"}
});

done_testing;
