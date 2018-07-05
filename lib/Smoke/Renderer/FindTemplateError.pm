package Smoke::Renderer::FindTemplateError {

  use Mouse;
  use Smoke;
  use Data::Dumper ();

  extends qw( Smoke::Renderer::Error );

  has file_name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has search_paths => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1,
  );

  override optional_description => sub ($self) {
    my $dumper = Data::Dumper->new([ $self->search_paths ]);
    $dumper->Terse(1);
    << "EOS";

file_name : @{[ $self->file_name ]}

search_paths : @{[ $dumper->Dump ]}
EOS
  };

  __PACKAGE__->meta->make_immutable;

}

1;
