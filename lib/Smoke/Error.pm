package Smoke::Error {

  use Mouse;
  use Smoke;
  use Carp ();

  has cause => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has longmess => (
    is      => 'ro',
    isa     => 'Str',
    builder => '_build_longmess',  
  );

  has stack_trace => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_stack_trace',
  );

  sub _build_longmess($self) {
    Carp::longmess();
  }

  sub _build_stack_trace($self) {
    $self->cause . $self->longmess;
  }

  sub description($self) {
    my $template = <<EOS
@@ @{[ ref $self ]} @@

cause : @{[ $self->cause ]}
@{[ $self->optional_description ]}
stack_trace : 
@{[ $self->stack_trace ]}
EOS
  }

  sub optional_description($self) {}

  __PACKAGE__->meta->make_immutable;

}

1;
