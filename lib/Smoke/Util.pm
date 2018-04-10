package Smoke::Util {

  use Smoke;
  use Exporter 'import';
  our @EXPORT_OK = qw( take_in validate_values );
  our %EXPORT_TAGS = (all => \@EXPORT_OK);
  use Carp ();
  use Cwd ();
  use File::Basename ();

  sub take_in($template_file, $paths = []) {
    my $file = (caller)[1];
  
    my ($template, $err) = do {
      # @INCの中身は cwd/templates, Smoke/resources/templates
      my ($cwd, $dirname) = (Cwd::getcwd, File::Basename::dirname(__FILE__));
      local @INC = (@$paths, $cwd, "$cwd/templates/", "$dirname/resources/templates/");
      my $template = do $template_file;
      my $error_template = << "EOS";
[system error]
reason : $!
filename : $template_file
\@INC : @{[ Data::Dumper::Dumper \@INC ]}
EOS
      ($template, $error_template);
    };
  
    Carp::croak $@ if $@;
    Carp::croak $err unless defined $template;
    unless (ref $template eq 'CODE') {
      Carp::croak "$template_file does not return CodeRef.";
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
