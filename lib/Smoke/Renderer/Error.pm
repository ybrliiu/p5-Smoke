package Smoke::Renderer::Error {

  use Mouse;
  use Smoke;

  extends qw( Smoke::Error );

  __PACKAGE__->meta->make_immutable;

}

1;
