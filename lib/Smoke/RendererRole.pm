package Smoke::RendererRole {

  use Mouse::Role;
  use Smoke;

  requires qw(
    render
    render_file
  );

}

1;
