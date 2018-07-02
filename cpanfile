requires 'perl', '5.026001';
requires 'Plack';
requires 'Plack::Middleware::Session', '0.30';
requires 'Try::Tiny', '0.30';
requires 'Exception::Tiny', '0.2.1';
requires 'File::ShareDir', '1.104';
requires 'Scalish';

on test => sub {
  requires 'HTTP::Request::Common';
  requires 'Plack::Test';
  requires 'Test2::Bundle::More';
  requires 'Test2::Plugin::UTF8';
  requires 'Test::Exception';
  requires 'Test::LoadAllModules';
  requires 'Test::More';
};
