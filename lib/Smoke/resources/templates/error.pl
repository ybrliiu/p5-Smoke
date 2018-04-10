use Smoke;

sub ($args) {
  qq{
<!DOCTYPE html>
<html>
  <head>
    <title>Smoke - error</title>
  </head>
  <body>
    <span style="color:red"><strong>『$args->{message}』</strong></span>
  </body>
</html>
};
};

