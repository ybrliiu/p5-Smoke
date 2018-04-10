requires 'perl', '5.026001';
requires 'Plack';
requires 'Plack::Middleware::Session', '0.30';
# requires 'Scalish';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

