package Smoke::Exception {

  use Mouse;
  use Smoke;
  extends 'Exception::Tiny';
  use Carp;

  has [qw( message file line package subroutine stack_trace )] => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );
  
  override throw => sub {
    my $class = shift;

    my %args;
    if (@_ == 1) {
        $args{message} = shift;
    } else {
        %args = @_;
    }
    $args{message} = $class unless defined $args{message} && $args{message} ne '';

    ($args{package}, $args{file}, $args{line}) = caller(0);
    $args{subroutine}  = (caller(1))[3];
    $args{stack_trace} = $args{message} . Carp::longmess();

    die $class->new(%args);
  };

  override as_string => sub ($self, @) { super . "\n" . $self->stack_trace };

}

1;

