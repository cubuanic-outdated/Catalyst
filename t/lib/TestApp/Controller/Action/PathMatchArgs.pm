package TestApp::Controller::Action::PathMatchArgs;

use strict;
use base 'TestApp::Controller::Action';

__PACKAGE__->config(
    actions => {
      'one' => { 'Path' => 'one', 'Args' => '1', 'MatchArgs' => '\d' },
      'two' => { 'Path' => 'one', 'Args' => '1', 'MatchArgs' => '\d\d' },
      'three' => { 'Path' => 'one', 'Args' => '1', 'MatchArgs' => '\d\d\d' },   
    },
);

sub one : Action {
    my ( $self, $c, $arg ) = @_;
    $c->forward('TestApp::View::Dump::Request');
}

sub two : Action {
    my ( $self, $c, @args ) = @_;
    $c->forward('TestApp::View::Dump::Request');
}

sub three : Action {
    my ( $self, $c, @args ) = @_;
    $c->forward('TestApp::View::Dump::Request');
}

1;
