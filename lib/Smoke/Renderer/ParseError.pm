package Smoke::Renderer::ParseError {

  use Mouse;
  use Smoke;

  extends qw( Smoke::Renderer::Error );

  __PACKAGE__->meta->make_immutable;

}

1;
