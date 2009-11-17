package TestApp::Action::MatchCapturesRegexp;

use strict;
use warnings;

use base qw/Catalyst::Action/;

sub match_captures {
	my $self = shift;
	if($self->next::method(@_)) {
		my $c = shift;
		if(my $match_captures = $self->attributes->{MatchCapturesRegexp}) {
			$match_captures = join(',', @$match_captures);
			return $self->compare_captures_to_signature($c, $match_captures)
		} else {
			return 1;
		}
	}
}

sub compare_captures_to_signature {
    my ($self, $c, $match_captures) = @_;
    my @incoming_args = @{ $c->req->args };
    my $splitter = qr/,(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))/;
    my @parsed_match_captures = split($splitter, $match_captures);
    foreach my $arg (@incoming_args) {
        my $match_capture = shift(@parsed_match_captures);
        $match_capture =~s/^"//;
        $match_capture =~s/"$//;        
        $match_capture = qr[$match_capture];
        if($arg =~ m/^$match_capture$/x) {
            next;
        } else {
            return 0;
        }
    }
    return 1;
}

1;

