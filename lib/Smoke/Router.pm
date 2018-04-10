package Smoke::Router {

  use Mouse;
  use Smoke;
  use Smoke::Util qw( validate_values );
  use Router::Boom::Method;
  use Smoke::Router::Root;

  has 'router_method' => (
    is      => 'ro',
    isa     => 'Router::Boom::Method',
    default => sub { Router::Boom::Method->new },
    handles => [qw/ add /],
  );

  sub match($self, $http_method, $path_info) {
    my ($dest, $captured, $is_method_not_allowed) = $self->router_method->match($http_method, $path_info);
    my $is_method_allowed = not $is_method_not_allowed;

    my ($last_uri) = ($path_info =~ m!([^/]+$)!);
    if ( exists $dest->{controller} and not exists $dest->{action} ) {
      $dest->{action} = $last_uri ? $last_uri =~ s/-/_/gr : 'root';
    }
    
    ($dest, $captured, $is_method_allowed);
  }

  sub get($self, @args) {
    $self->add('GET', @args);
  }

  sub post($self, @args) {
    $self->add('POST', @args);
  }

  sub any($self, @args) {
    $self->add([qw/ GET POST /], @args);
  }

  sub root($self, %args) {
    validate_values \%args => [qw/ path controller /];
    Smoke::Router::Root->new(
      router     => $self,
      path       => $args{path},
      controller => $args{controller},
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
