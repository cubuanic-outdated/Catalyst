package Catalyst::Action::TestAfter;

use Moose;

extends 'Catalyst::Action';

after execute => sub {
    my ($self, $controller, $ctx) = @_;
    $ctx->res->header( 'X-Action-After', $ctx->stash->{after_message} );
};

1;
