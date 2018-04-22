package Smoke::Util {

  use Smoke;
  use Try::Tiny;
  use Smoke::Template::FindException;
  use Smoke::Template::ParseException;

  use Carp ();
  use Cwd ();
  use File::Basename ();
  use File::ShareDir qw( dist_dir );

  use Exporter 'import';
  our @EXPORT_OK = qw( take_in validate_values );
  our %EXPORT_TAGS = (all => \@EXPORT_OK);

  sub take_in($template_file, $paths = []) {

    # @INCの中身は cwd/templates, Smoke/resources/templates
    my $cwd = Cwd::getcwd;
    my $dirname = File::Basename::dirname(__FILE__);
    my $share_dir = try {
      # installed
      dist_dir('Smoke') . '/templates';
    } catch {
      # develop
      "$dirname/../../share/templates";
    };
    local @INC = (@$paths, $cwd, "$cwd/templates", $share_dir);

    my $template = try {
      do $template_file;
    } catch {
      Smoke::Template::ParseException->throw($_);
    };

    unless (defined $template) {
      Smoke::Template::FindException->throw(
        inc           => \@INC,
        message       => $!,
        template_file => $template_file,
      );
    }

    unless (ref $template eq 'CODE') {
      Smoke::Template::ParseException->throw("template_file does not return CodeRef.");
    }

    $template;
  }

  sub validate_values($args, $keys, $name = '') {
    $name = "${name}の" if $name;

    Carp::confess 'HashRefが渡されていません' if ref $args ne 'HASH';

    my @not_exists = grep { not exists $args->{$_} } @$keys;
    if (@not_exists) {
      my ($file, $line) = (caller 1)[1 .. 2];
      # die関数の最後に\nを入れるとdieした時にファイル名と行が出力されなくなる
      Carp::confess "$name キーが足りません(@{[ join(', ', @not_exists) ]}) at $file line $line\n";
    }
  }

}

1;
