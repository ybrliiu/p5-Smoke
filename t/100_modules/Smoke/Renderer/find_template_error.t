use Smoke;
use Test2::V0 -no_pragmas => 1;
use Test2::Plugin::UTF8;

use Smoke::Renderer::FindTemplateError;

sub trim($str) { $str =~ s/^\s|\s$//gr }

sub some_func {
  Smoke::Error->new(cause => 'nothing');
}

ok(my $error = eval {
  Smoke::Renderer::FindTemplateError->new(
    cause        => 'testing',
    file_name    => 'tmp.pl',
    search_paths => \@INC,
  );
});
ok not $@;

done_testing;
