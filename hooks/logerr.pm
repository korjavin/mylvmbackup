#!/usr/bin/perl -w

package logerr;

use strict;

sub execute()
{
	my ($class, $dbh, $msg) = @_;

	# send an email with $msg to admin....

	return 1;
}

1;
