package Smoke::Router::Root {

  use Mouse;
  use Smoke;
  use Smoke::Util qw( validate_values );

  has 'path'       => ( is => 'ro', isa => 'Str', required => 1 );
  has 'router'     => ( is => 'ro', isa => 'Smoke::Router', required => 1 );
  has 'controller' => ( is => 'ro', required => 1 );

  sub root($self, %args) {
    validate_values \%args => [qw/ path controller /];
    __PACKAGE__->new(
      router     => $self->router,
      path       => $self->path . $args{path},
      controller => $self->controller . '::' . $args{controller},
    );
  }

  sub any($self, $path) {
    $self->router->any("$self->{path}${path}", +{ controller => $self->controller });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
