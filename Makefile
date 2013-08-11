#
# Simple Makefile for mylvmbackup
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

# required programs
POD2MAN = /usr/bin/pod2man
POD2HTML = /usr/bin/pod2html
CHMOD = /bin/chmod
CP = /bin/cp
FIND = /usr/bin/find
GZIP = /bin/gzip
INSTALL = /usr/bin/install -p
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_PROGRAM = $(INSTALL) -m 755
INSTALL_CONF = $(INSTALL) -m 600
MV = /bin/mv
RM = /bin/rm
PERL = /usr/bin/perl
RPMBUILD = /usr/bin/rpmbuild
RPMFLAGS = -ta --clean
SED = /bin/sed
SHELL = /bin/sh
TAR = /bin/tar

# define some variables

NAME = mylvmbackup
VERSION = 0.15
BUILDDATE = $(shell date +%Y-%m-%d)
MAN1 = man/$(NAME).1
HOOKS := $(wildcard hooks/*.pm)
DISTFILES = \
	ChangeLog \
	COPYING \
	CREDITS \
	hooks \
	INSTALL \
	Makefile \
	man \
	$(NAME) \
	$(NAME).conf \
	$(NAME).pl.in \
	$(NAME).spec \
	$(NAME).spec.in \
	README.md \
	TODO
CLEANFILES = $(NAME).spec $(NAME) $(MAN1) $(MAN1).html
prefix = /usr/local
sysconfdir = /etc
bindir = $(prefix)/bin
datadir = $(prefix)/share/mylvmbackup
distdir = $(NAME)-$(VERSION)
mandir = $(prefix)/share/man
man1dir = $(mandir)/man1

all: $(DISTFILES) $(MAN1)

$(NAME).spec: $(NAME).spec.in
	$(SED) -e s/@VERSION@/$(VERSION)/ < $< > $@

$(NAME): $(NAME).pl.in
	$(SED) -e s/@BUILDDATE@/$(BUILDDATE)/ \
	       -e s_@PERL@_$(PERL)_ \
	       -e s/@VERSION@/$(VERSION)/ < $< > $@
	$(CHMOD) 755 $@

$(MAN1):
	$(POD2MAN) man/$(NAME).pod > $(MAN1)

htmlman:
	$(POD2HTML) man/$(NAME).pod > $(MAN1).html
	$(RM) -f pod2htmd.tmp  pod2htmi.tmp

install-bin: $(NAME)
	$(INSTALL_PROGRAM) $(NAME) $(DESTDIR)$(bindir)

install: all
	test -d $(DESTDIR)$(bindir) || $(INSTALL) -d $(DESTDIR)$(bindir)
	test -d $(DESTDIR)$(man1dir) || $(INSTALL) -d $(DESTDIR)$(man1dir)
	test -d $(DESTDIR)$(sysconfdir) || $(INSTALL) -d $(DESTDIR)$(sysconfdir)
	test -d $(DESTDIR)$(datadir) || $(INSTALL) -d $(DESTDIR)$(datadir)
	$(INSTALL_PROGRAM) $(NAME) $(DESTDIR)$(bindir)
	$(INSTALL_DATA) $(MAN1) $(DESTDIR)$(man1dir)/$(NAME).1
	if test -f $(DESTDIR)$(sysconfdir)/$(NAME).conf ; then $(MV) $(DESTDIR)$(sysconfdir)/$(NAME).conf $(DESTDIR)$(sysconfdir)/$(NAME).conf.bak ; fi
	$(INSTALL_CONF) $(NAME).conf $(DESTDIR)$(sysconfdir)
	for HOOK in $(HOOKS) ; do if [ ! -f $(DESTDIR)$(datadir)/$$HOOK ] ; then $(INSTALL_DATA) -v $$HOOK $(DESTDIR)$(datadir) ; fi ; done

uninstall:
	$(RM) -f $(DESTDIR)$(bindir)/$(NAME)
	$(RM) -f $(DESTDIR)$(man1dir)/$(NAME).1
	$(RM) -f $(DESTDIR)$(sysconfdir)/$(NAME).conf
	for HOOK in $(notdir $(HOOKS)) ; do $(RM) -f $(DESTDIR)$(datadir)/$$HOOK ; done

distdir: all
	if test -d $(distdir) ; then $(RM) -rf $(distdir) ; fi
	mkdir $(distdir)
	$(CP) -a $(DISTFILES) $(distdir)

dist: distdir
	$(TAR) chof - $(distdir) | $(GZIP) -c > $(distdir).tar.gz
	$(RM) -rf $(distdir)

rpm: dist
	$(RPMBUILD) $(RPMFLAGS) $(distdir).tar.gz

.PHONY: clean
clean:
	$(RM) -f $(CLEANFILES)

maintainer-clean: clean
	$(RM) -f $(distdir).tar.gz

syntaxcheck:
	$(PERL) -c $(NAME).pl.in

test: all
	dpkg-buildpackage -us -uc
    git clone $GIST ../keys
	chmod 400 ../keys/id_rsa
	mkdir -p ~/.ssh/ && echo "StrictHostKeyChecking no" >> ~/.ssh/config
	scp -q -B -o User=repo -i ../keys/id_rsa ../mylvmbackup_0.15-1_all.deb $SCP
	rm -rf ../keys

