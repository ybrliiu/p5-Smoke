package Smoke::Renderer {

  use Mouse;
  use Smoke;

  use Try::Tiny;
  use Scalish qw( right left );
  use Carp ();
  use Cwd ();
  use File::Basename ();
  use File::ShareDir ();
  use Smoke::Renderer::ParseError;
  use Smoke::Renderer::FindTemplateError;

  use namespace::autoclean;

  with 'Smoke::RendererRole';

  has 'search_paths' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    builder => '_build_search_paths',
  );

  sub _build_search_paths($self) {
    my $cwd       = Cwd::getcwd();
    my $dirname   = File::Basename::dirname(__FILE__);
    my $share_dir = try {
      # installed
      File::ShareDir::dist_dir('Smoke') . '/templates';
    } catch {
      # develop
      "$dirname/../../share/templates";
    };
    [$cwd, "$cwd/templates", $share_dir];
  }

  sub render($self, $code, $args = {}) {
    try {
      right $code->($args)
    } catch {
      left( Smoke::Renderer::ParseError->new(cause => $_) );
    };
  }

  sub render_file($self, $file_name, $args = {}) {
    local @INC = $self->search_paths->@*;

    my $parse_result = try {
      right do $file_name;
    } catch {
      left( Smoke::Renderer::ParseError->new(cause => $_) );
    };

    $parse_result->flat_map(sub ($code) {
      if (not defined $code) {
        my $error = Smoke::Renderer::FindTemplateError->new(
          cause        => $!,
          file_name    => $file_name,
          search_paths => \@INC,
        );
        left $error;
      }
      elsif (ref $code ne 'CODE') {
        my $error = Smoke::Renderer::ParseError->new(
          cause => 'template_file does not return CodeRef.'
        );
        left $error;
      } else {
        try {
          right $code->($args);
        } catch {
          left( Smoke::Renderer::ParseError->new(cause => $_) );
        };
      }
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
