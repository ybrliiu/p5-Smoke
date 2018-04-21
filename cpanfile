requires 'perl', '5.026001';
requires 'Plack';
requires 'Plack::Middleware::Session', '0.30';
requires 'Try::Tiny', '0.30';
requires 'Exception::Tiny', '0.2.1';
requires 'File::ShareDir', '1.104';
requires 'Scalish';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

