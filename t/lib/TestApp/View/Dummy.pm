package TestApp::View::Dummy;
use Moose;

BEGIN { extends 'Catalyst::View' }

sub ACCEPT_CONTEXT {
    my($self, $c, $data) = @_;
    die 'ACCEPT_CONTEXT received no args' unless $data;
    return $self;
}

sub process {
    my($self, $c) = @_;
    push @{$c->stash->{forwarded_to}}, $self;
}

1;
