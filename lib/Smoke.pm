package Smoke 0.01 {

  use strict;
  use warnings;
  use utf8;
  use feature qw( :5.26 signatures );
  no warnings 'experimental::signatures';

  sub import {
    $_->import for qw/ strict warnings utf8 /;
    feature->import(qw/ :5.26 signatures /);
    warnings->unimport('experimental::signatures');
  }

  # Data::Dumper utf8対応
  use Data::Dumper;
  {
    no warnings 'redefine';
    *Data::Dumper::qquote = sub { shift };
  }
  $Data::Dumper::Useperl = 1;

}

1;

__END__

=encoding utf-8

=head1 NAME

Smoke - WAF

=head1 SYNOPSIS

    use Smoke;

=head1 DESCRIPTION

Smoke is ...

=head1 LICENSE

Copyright (C) mp0liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mp0liiu E<lt>raian@reeshome.orgE<gt>

=cut

