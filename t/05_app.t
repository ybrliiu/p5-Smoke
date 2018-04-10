use Smoke;
use Test::More;
use Test::Exception;

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

=head1
my $app = App->new;
use Plack::Runner;
my $runner = Plack::Runner->new;
$runner->run($app->run);
use LWP::UserAgent;
my $ua = LWP::UserAgent->new;
my $res = $ua->get('http://127.0.0.1:5000');
if ( $res->is_success ) {
  diag $res->cotent;
}
=cut

ok 1;

done_testing;
