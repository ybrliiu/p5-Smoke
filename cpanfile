requires 'perl', '5.008001';
requires 'Plack::Middleware::Session', '0.30';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

