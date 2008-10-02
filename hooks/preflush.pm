#!/usr/bin/perl -w

package preflush;

use strict;

my $errstr;

sub execute()
{
	my ($class, $dbh, $msg) = @_;

	if(!$dbh->do("FLUSH LOGS"))
	{
		$errstr = "Unable to flush logs: " . $DBI::errstr;
		return 0;
	}

	return 1;
}

sub errmsg()
{
	return $errstr;
}

1;
