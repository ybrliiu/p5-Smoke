use Smoke;
use Test2::V0 -no_pragmas => 1;
use Test2::Plugin::UTF8;

use Smoke::Renderer;

sub trim($str) { $str =~ s/^\s|\s$//gr }

my $renderer = Smoke::Renderer->new;

{
  my $result = $renderer->render(sub { 'somestring' });
  ok $result->is_right;
  ok $result->map(sub ($template) {
    is $template, 'somestring';
  });
}

{
  my $result = $renderer->render(
    sub ($args) {
      my $name = $args->{name};
      qq{<div>${name}</div>};
    },
    +{ name => 'abc123' },
  );
  ok $result->is_right;
  $result->map(sub ($template) {
    is $template, '<div>abc123</div>';
  });
}

{
  my $result = $renderer->render(sub {
    die 'something happened.';
  });
  ok $result->is_left;
}

{
  my $result = $renderer->render_file('error.pl', +{ message => 'some error occured.' });
  ok $result->is_right;
  $result->map(sub ($template) {
    is trim($template), trim(q{
<!DOCTYPE html>
<html>
  <head>
    <title>Smoke - error</title>
  </head>
  <body>
    <span style="color:red"><strong>『some error occured.』</strong></span>
  </body>
</html>
});
  });
}

{
  my $result = $renderer->render_file('fantasy.pl');
  ok $result->is_left;
  my $error;
  ok lives { $error = $result->left->get };
  ok $error->isa('Smoke::Renderer::FindTemplateError');
}

done_testing;
