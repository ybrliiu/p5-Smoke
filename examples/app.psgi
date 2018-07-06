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

use Smoke;
my $app = App->new;
$app->run;
