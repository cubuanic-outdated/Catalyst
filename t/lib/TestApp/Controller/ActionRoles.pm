package TestApp::Controller::ActionRoles;

use Moose;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(
    action_roles => ['~Kooh']
);

sub foo  : Local Does('Moo')  {}
sub bar  : Local Does('~Moo') {}
sub baz  : Local Does('+Moo') {}
sub quux : Local Does('Zoo')  {}

sub corge : Local Does('Moo') ActionClass('TestAfter') {
    my ($self, $ctx) = @_;
    $ctx->stash(after_message => 'moo');
}

1;
