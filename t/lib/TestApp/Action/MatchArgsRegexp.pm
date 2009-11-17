package TestApp::Action::MatchArgsRegexp;

use strict;
use warnings;

use base qw/Catalyst::Action/;

sub match {
	my $self = shift;
	if($self->next::method(@_)) {
		my $c = shift;
		if(my $match_args = $self->attributes->{MatchArgsRegexp}) {
			$match_args = join(',', @$match_args);
			return $self->compare_args_to_signature($c, $match_args);
		} else {
			return 1;
		}
	}
}

## MatchArgsRegexp("/d/d","/w/d",...)
sub compare_args_to_signature {
    my ($self, $c, $match_args) = @_;
    my @incoming_args = @{ $c->req->args };
    my $splitter = qr/,(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))/;
    my @parsed_match_args = split($splitter, $match_args);
    foreach my $arg (@incoming_args) {
        my $match_arg = shift(@parsed_match_args);
        $match_arg =~s/^"//;
        $match_arg =~s/"$//;        
        $match_arg = qr[$match_arg];
        if($arg =~ m/^$match_arg$/x) {
            next;
        } else {
            return 0;
        }
    }
    return 1;
}

1;

