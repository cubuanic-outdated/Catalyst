#!perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

our $iters;

BEGIN { $iters = $ENV{CAT_BENCH_ITERS} || 1; }

use Test::More tests => 18*$iters;
use Catalyst::Test 'TestApp';

if ( $ENV{CAT_BENCHMARK} ) {
    require Benchmark;
    Benchmark::timethis( $iters, \&run_tests );
}
else {
    for ( 1 .. $iters ) {
        run_tests();
    }
}

sub run_tests {
    {
        ok(
            my $response =
              request('http://localhost/action/pathmatchargs/one/1'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/pathmatchargs/one',
            'Test Action'
        );
        is(
            $response->header('X-Test-Class'),
            'TestApp::Controller::Action::PathMatchArgs',
            'Test Class'
        );
        like(
            $response->content,
            qr/^bless\( .* 'Catalyst::Request' \)$/s,
            'Content is a serialized Catalyst::Request'
        );
    }
    {
        ok(
            my $response =
              request('http://localhost/action/pathmatchargs/one/11'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/pathmatchargs/two',
            'Test Action'
        );
        is(
            $response->header('X-Test-Class'),
            'TestApp::Controller::Action::PathMatchArgs',
            'Test Class'
        );
        like(
            $response->content,
            qr/^bless\( .* 'Catalyst::Request' \)$/s,
            'Content is a serialized Catalyst::Request'
        );
    }
    {
        ok(
            my $response =
              request('http://localhost/action/pathmatchargs/one/111'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/pathmatchargs/three',
            'Test Action'
        );
        is(
            $response->header('X-Test-Class'),
            'TestApp::Controller::Action::PathMatchArgs',
            'Test Class'
        );
        like(
            $response->content,
            qr/^bless\( .* 'Catalyst::Request' \)$/s,
            'Content is a serialized Catalyst::Request'
        );
    }
}
