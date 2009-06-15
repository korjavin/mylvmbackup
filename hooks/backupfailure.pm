#!/usr/bin/perl -w

package backupfailure;

use strict;

use Date::Format;
use Sys::Hostname;

sub execute()
{
	my ($class, $dbh, $msg) = @_;

	my $hostname = hostname;
	my $today = time2str("%C", time);
	my $content = "Date: $today\nHost: $hostname\n";

	# send an email here...or something..

	return 1;
}

1;
