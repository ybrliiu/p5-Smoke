package Smoke::Controller {

  use Mouse;
  use Smoke;

  use Encode qw( encode_utf8 );
  use Scalish qw( option );
  use JSON::XS qw( encode_json );
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

  sub create_response($self, $params) {
    Plack::Response->new(@$params);
  }

  sub render($self, $template_file, $args = {}) {
    my $header = HTTP::Headers->new(
      Pragma           => 'no-cache',
      Content_Type     => 'text/html; charset=UTF-8',
      Cache_Control    => 'no-cache',
      Content_Language => 'ja',
    );

    my $render_result = $self->renderer->render_file($template_file, $args);
    my $res_params    = $render_result->match(
      Right => sub ($template) {
        [INTERNAL_SERVER_ERROR, $header, encode_utf8 $template];
      },
      Left => sub ($error) {
        warn $error->description;
        $args->{message} = $error->description;
        my $template = $self->renderer->render_file('error.pl', $args)->get;
        [OK, $header, encode_utf8 $template];
      },
    );
    my $res = $self->create_response($res_params);
    $res->finalize;
  }

  sub render_error($self, $message) {
    $self->render('error.pl', +{ message => $message });
  }

  sub render_json($self, $hash) {
    my $header = HTTP::Headers->new(
      Pragma           => 'no-cache',
      Content_Type     => 'application/json; charset=UTF-8',
      Cache_Control    => 'no-cache',
      Content_Language => 'ja',
    );
    $self->create_response([OK, $header, encode_json $hash])->finalize;
  }

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
