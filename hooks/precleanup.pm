#!/usr/bin/perl -w

package precleanup;

use strict;

use Config::IniFiles;
use Date::Format;
use File::Basename;

my $errstr;

sub execute()
{
	my ($class, $dbh, $msg) = @_;

	# load the mylvmbackup config file
	my $cfg = new Config::IniFiles( -file => '/etc/mylvmbackup.conf' );
	if(!$cfg)
	{
		$errstr = 'Unable to load config';
		return 0;
	}
	
	# destination of backups
	my $dest = dirname(time2str($cfg->val('fs', 'backupdir'), time));
	my $retention = $cfg->val('misc', 'rsnaparg');
	
	local *DIR;
	
	if(!opendir(DIR, $dest))
	{
		$errstr = "Unable to open $dest for pruning: $!";
		return 0;
	}
	
	while($_ = readdir(DIR))
	{
		next if /^\.{1,2}$/;
		my $path = "$dest/$_";
	
		if(-d $path && int(-M $path) > $retention)
		{
			if(system("/bin/rm -rf $path") != 0)
			{
				$errstr .= "Unable to prune $path: $!\n";
			}
		}
	}
	closedir DIR;

	return 1;
}

sub errmsg()
{
	return $errstr;
}

1;
