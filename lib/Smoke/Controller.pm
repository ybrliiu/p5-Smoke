package Smoke::Controller {

  use Mouse;
  use Smoke;

  use Encode qw( encode_utf8 );
  use Scalish qw( option );
  use HTTP::Headers;
  use Plack::Request;
  use Plack::Response;
  use Smoke::Session;
  use Smoke::Renderer;

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

  has env => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has req => (
    is      => 'ro',
    isa     => 'Plack::Request',
    lazy    => 1,
    handles => ['parameters'],
    builder => '_build_req',
  );

  has renderer => (
    is      => 'ro',
    does    => 'Smoke::RendererRole',
    lazy    => 1,
    builder => '_build_renderer',
  );

  sub _build_req($self) {
    Plack::Request->new($self->env);
  }

  sub _build_renderer($self) {
    Smoke::Renderer->new;
  }

  sub render($self, $template_file, $args = {}) {

    $self->hook_before_render($args);

    my $header = HTTP::Headers->new(
      Pragma           => 'no-cache',
      Content_Type     => 'text/html; charset=UTF-8',
      Cache_Control    => 'no-cache',
      Content_Language => 'ja',
    );

    my $render_result = $self->renderer->render_file($template_file, $args);
    my $res = $render_result->match(
      Right => sub ($template) {
        Plack::Response->new(INTERNAL_SERVER_ERROR, $header, encode_utf8 $template);
      },
      Left => sub ($error) {
        warn $error->description;
        $args->{message} = $error->description;
        my $template = $self->renderer->render_file('error.pl', $args)->get;
        Plack::Response->new(OK, $header, encode_utf8 $template);
      },
    );
    $res->finalize;
  }

  sub render_error($self, $message) {
    $self->render('error.pl', +{ message => $message });
  }

  sub hook_before_render {}

  sub param($self, $key) {
    option( $self->req->param($key) );
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
