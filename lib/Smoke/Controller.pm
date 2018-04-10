package Smoke::Controller {

  use Mouse;
  use Smoke;
  use HTTP::Headers;
  use Plack::Request;
  use Plack::Response;
  use Smoke::Session;
  use Scalish qw( option );
  use Smoke::Util qw( take_in );
  use Encode qw( encode_utf8 );

  use constant {
    # success
    OK      => 200,
    CREATED => 201,

    # redirection
    TEMPORARY_REDIRECT => 307,
    PERMANENT_REDIRECT => 308,

    # client error
    BAD_REQUEST  => 400,
    UNAUTHORIZED => 401,
    FORBIDDEN    => 403,
    NOT_FOUND    => 404,

    # server error
    INTERNAL_SERVER_ERROR => 500,
  };

  has 'env' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has 'req' => (
    is      => 'ro',
    isa     => 'Plack::Request',
    lazy    => 1,
    handles => ['parameters'],
    builder => '_build_req',
  );

  sub _build_req($self) {
    Plack::Request->new($self->env);
  }

  sub render($self, $template_file, $args = {}) {

    $args->{CSS_FILES} //= [];
    $args->{JS_FILES}  //= [];

    $self->hook_before_render($args);

    my $header = HTTP::Headers->new(
      Pragma           => 'no-cache',
      Content_Type     => 'text/html; charset=UTF-8',
      Cache_Control    => 'no-cache',
      Content_Language => 'ja',
    );

    my $template = take_in $template_file;
    my $body = encode_utf8 eval { $template->($args) };
    my $res = do {
      if (my $e = $@) {
        my $error = take_in "error.pl";
        $args->{message} = $e;
        my $body = encode_utf8 $error->($args);
        Plack::Response->new(INTERNAL_SERVER_ERROR, $header, $body);
      } else {
        Plack::Response->new(OK, $header, $body);
      }
    };
    $res->finalize;
  }

  sub hook_before_render {}

  sub param($self, $key) {
    option( $self->req->param($key) );
  }

  sub render_error($self, $message) {
    $self->render('error.pl', {message => $message});
  }

  sub redirect_to($self, $path) {
    my $res = Plack::Response->new($path);
    $res->redirect;
  }

  sub session($self) {
    Smoke::Session->new($self->env);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
