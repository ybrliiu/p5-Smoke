package Smoke::Template::FindException {

  use Mouse;
  use Smoke;
  use Data::Dumper ();
  extends 'Smoke::Exception';

  has 'template_file' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'inc' => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
  );

  override as_string => sub ($self, @) {
    my $dumper = Data::Dumper->new([ $self->inc ]);
    $dumper->Terse(1);
    << "EOS";
[@{[ ref $self ]}]

reason : @{[ $self->message ]}

\@INC : @{[ $dumper->Dump ]}

stack_trace :
  @{[ $self->stack_trace ]}
EOS
  };

  __PACKAGE__->meta->make_immutable;

}

1;
