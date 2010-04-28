#!perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More tests => 2;
use Catalyst::Test 'TestApp';

my($res, $ctx) = ctx_request('http://localhost/action/forward/compobj');

my $ftarget = $ctx->stash->{forward_target};
my $fto = $ctx->stash->{forwarded_to} || [!$ftarget];
cmp_ok(scalar(@$fto), '==', 1);
cmp_ok($ftarget, '==', $fto->[0]);
