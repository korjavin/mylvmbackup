
mylvmbackup - a utility for creating MySQL backups using LVM snapshots
----------------------------------------------------------------------

Home page: http://www.lenzg.net/mylvmbackup/
Source code, Bug Reports, Mailing List: https://launchpad.net/mylvmbackup
Maintainer: Lenz Grimmer <lenz@grimmer.com>


Description
===========

mylvmbackup is a tool for quickly creating full physical backups of a MySQL
server's data files. To perform a backup, mylvmbackup obtains a read lock on
all tables and flushes all server caches to disk, makes an LVM snapshot of the
volume containing the MySQL data directory, and unlocks the tables again. The
snapshot process takes only a small amount of time. When it is done, the server
can continue normal operations, while the actual file backup proceeds.

The LVM snapshot is mounted to a temporary directory and all data is backed up
using the tar program by default. The archive files are created using names in
the form of backup-YYYYMMDD_hhmmss_mysql.tar.gz, where YYYY, MM, DD, hh, mm and
ss represent the year, month, day, hour, minute, and second of the time at
which the backup occurred. The default prefix backup, date format and file
suffix may be modified. The use of timestamped archive names allows you to run
mylvmbackup many times without risking to overwrite old archives. It is
possible to preserve only a defined number of last backups, to avoid running
out of disk space.

Alternatively, instead of tar, you can use rsync or rsnap to perform the
archiving.

The rsync backup can perform both local backups as well as backing up to a
remote server using rsyncd or rsync via SSH.

rsnap is a wrapper around rsync to automatically maintain and rotate a given
number of last backups (7 by default). It utilizes hard links to link to
unchanged files for saving disk space.

Moreover, a backup type none is provided for cases where the user wants to use
mylvmbackup only for creating the snapshots and intends to perform the actual
backup by using the appropriate hooks. (Or for cases where the snapshot itself
is considered to be the backup).

mylvmbackup also provides several methods for logging and reporting the
progress and success of a backup run. The log messages can either be printed to
the console (STDOUT), logged via syslog or sent to you via email.

It is required to run mylvmbackup on the same host where the MySQL server runs.
If your MySQL daemon is not listening on localhost or using the default socket
location, you must specify --host or --socket. Even though mylvmbackup
communicates with the server through a normal client connection to obtain the
read lock and flush data, it performs the actual backup by accessing the file
system directly. It is also a requirement that the MySQL server's data
directory resides on an LVM volume. (It is, however, a good idea to do the LVM
backup to a different partition than the one where the data directory resides.
Otherwise, there is a good chance that LVM will run out of undo space for LVM
snapshot maintenance and the backup will fail.)

The user who invokes mylvmbackup must have sufficient filesystem permissions to
create the LVM snapshot and mount it. This includes read/write access to the
backup directory.


Requirements
============

For proper operation mylvmbackup requires Perl 5 with the DBI and DBD::mysql
modules. It also needs the Config::IniFiles to read the global configuration
file of the program. Date::Format is required to create the time stamp used in
the backup file names. In addition, it utilizes Getopt::Long, File::Basename
and File::Temp, which usually are part of the default Perl distribution.
Sys::Syslog is only required in case you want to enable the syslog log
facility. The MIME::Lite module is required when you enable the mail reporting
functionality. It also requires a functional local sendmail (or alternative)
facility.

It also requires several other external programs: GNU tar and gzip to back up
the data, LVM utilities (lvcreate, lvremove and lvs) to create and remove the
LVM snapshot, and the system utilities mount and umount. Please note that
mylvmbackup requires Linux LVM Version 2 or higher. It does not work on LVMv1,
as this version does not support writable snapshots.

Optionally, rsync or rsnap may be required instead of tar and gzip, depending
on which backup type you choose.


Getting involved
================

If you want to discuss the usage of mylvmbackup or ask for help, there is a
mailing list hosted on LaunchPad:

  https://launchpad.net/~mylvmbackup-discuss

The mailing list used to be on FreeLists.org before, but this one is no longer
maintained. The old discussions are archived at

  http://www.freelists.org/archives/mylvmbackup/


Travis CI
=============
[![Build Status](https://travis-ci.org/korjavin/mylvmbackup.png?branch=master)](https://travis-ci.org/korjavin/mylvmbackup)

