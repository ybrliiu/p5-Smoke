package Smoke::Session {

  use Mouse;
  use Smoke;
  use Plack::Session;

  has 'env' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has 'session' => (
    is      => 'ro',
    isa     => 'Plack::Session',
    lazy    => 1,
    handles => [qw( id keys get set remove dump )],
    builder => '_build_session',
  );

  sub _build_session($self) {
    Plack::Session->new($self->env);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
