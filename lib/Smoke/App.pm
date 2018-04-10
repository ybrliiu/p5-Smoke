package Smoke::App {

  use Mouse::Role;
  use Smoke;
  use Module::Load qw( load );
  use Smoke::Router;
  use Smoke::Controller;

  requires qw( dispatch );

  has 'router' => (
    is      => 'ro',
    isa     => 'Smoke::Router',
    default => sub { Smoke::Router->new }
  );

  sub BUILD($self, $args) {
    $self->dispatch;
  }

  sub run($self) {
    sub ($env) {
      my ($dest, $capture, $is_method_allowed)
        = $self->router->match($env->{REQUEST_METHOD}, $env->{PATH_INFO});
      if (%$dest && $is_method_allowed) {
        my $controller = $dest->{controller};
        my $action     = $dest->{action};
        state $is_loaded = {};
        unless ($is_loaded->{$controller}) {
          load $controller;
          $is_loaded->{$controller} = 1;
        }
        my $c = $controller->new(env => $env);
        $c->$action;
      } else {
        my $c = Smoke::Controller->new(env => $env);
        $c->render_error('そのページは存在しません');
      }
    };
  }

}

1;

