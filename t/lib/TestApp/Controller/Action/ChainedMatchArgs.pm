package TestApp::Controller::Action::ChainedMatchArgs;

use strict;
use warnings;

use HTML::Entities;

use base qw/Catalyst::Controller/;

sub begin :Private { }


sub foo
    :PathPrefix
    :CaptureArgs(1)
    :Chained('/') {
        my ( $self, $c, @args ) = @_;
        die "missing argument" unless @args;
        die "more than 1 argument" if @args > 1;
}

sub partway1
	:ActionClass('+TestApp::Action::MatchCapturesRegexp')
    :PathPart('partway') 
    :Chained('foo')
    :MatchCapturesRegexp('\dx\d')
    :CaptureArgs(1) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }

sub endpointx
	:ActionClass('+TestApp::Action::MatchCapturesRegexp')
    :PathPart('end') 
    :Chained('partway1')
    :MatchCapturesRegexp('\d')
    :Args(1) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }

sub endpoint1
	:ActionClass('+TestApp::Action::MatchCapturesRegexp')
    :PathPart('end') 
    :Chained('foo')
    :MatchCapturesRegexp('\d')
    :Args(1) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }

sub endpoint2
	:ActionClass('+TestApp::Action::MatchCapturesRegexp')
    :PathPart('end') 
    :Chained('foo')
    :MatchCapturesRegexp('\d\d')
    :Args(1) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }

sub endpoint3
	:ActionClass('+TestApp::Action::MatchCapturesRegexp')
    :PathPart('end') 
    :Chained('foo')
    :MatchCapturesRegexp('\d,"\d\d"')
    :Args(2) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }

sub endpoint4
	:ActionClass('+TestApp::Action::MatchCapturesRegexp')
    :PathPart('end') 
    :Chained('foo')
    :MatchCapturesRegexp('\d\d,\d')
    :Args(2) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }
1;
