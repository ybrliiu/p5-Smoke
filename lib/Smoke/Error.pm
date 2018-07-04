package Smoke::Error {

  use Mouse;
  use Smoke;

  has cause => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  __PACKAGE__->meta->make_immutable;

}

1;
