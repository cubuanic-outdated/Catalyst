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

sub endpoint1
    :PathPart('end') 
    :Chained('foo')
    :MatchArgs('\d')
    :Args(1) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }

sub endpoint2
    :PathPart('end') 
    :Chained('foo')
    :MatchArgs('\d\d')
    :Args(1) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }

sub endpoint3
    :PathPart('end') 
    :Chained('foo')
    :MatchArgs('\d,"\d\d"')
    :Args(2) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }

sub endpoint4
    :PathPart('end') 
    :Chained('foo')
    :MatchArgs('\d\d,\d')
    :Args(2) {
    	my ($self, $c, @args) = @_;
        $c->forward('TestApp::View::Dump::Request');    
    }
1;
