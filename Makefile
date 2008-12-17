#
# Simple Makefile for mylvmbackup
#

# required programs
POD2MAN = /usr/bin/pod2man
POD2HTML = /usr/bin/pod2html
CHMOD = /bin/chmod
CP = /bin/cp
FIND = /usr/bin/find
GZIP = /bin/gzip
INSTALL = /usr/bin/install
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_PROGRAM = $(INSTALL) -m 755
INSTALL_CONF = $(INSTALL) -m 600
MV = /bin/mv
RM = /bin/rm
RPMBUILD = /usr/bin/rpmbuild
RPMFLAGS = -ta --clean
SED = /bin/sed
SHELL = /bin/sh
TAR = /bin/tar

# define some variables

NAME = mylvmbackup
VERSION = 0.12
BUILDDATE = $(shell date +%Y-%m-%d)
MAN1 = man/$(NAME).1
DISTFILES = COPYING \
	CREDITS \
	INSTALL \
	ChangeLog \
	Makefile \
	man \
	$(NAME) \
	$(NAME).pl.in \
	$(NAME).spec \
	$(NAME).spec.in \
	$(NAME).conf \
	README \
	TODO
CLEANFILES = $(NAME).spec $(NAME) $(MAN1) $(MAN1).html
prefix = /usr/local
sysconfdir = /etc
bindir = $(prefix)/bin
datadir = $(prefix)/share/mylvmbackup
distdir = $(NAME)-$(VERSION)
mandir = $(prefix)/man
man1dir = $(mandir)/man1

all: $(DISTFILES) $(MAN1)

$(NAME).spec: $(NAME).spec.in
	$(SED) -e s/@VERSION@/$(VERSION)/ < $< > $@

$(NAME): $(NAME).pl.in
	$(SED) -e s/@BUILDDATE@/$(BUILDDATE)/ \
	       -e s/@VERSION@/$(VERSION)/ < $< > $@
	$(CHMOD) 755 $@

$(MAN1):
	$(POD2MAN) man/$(NAME).pod > $(MAN1)

htmlman:
	$(POD2HTML) man/$(NAME).pod > $(MAN1).html
	$(RM) -f pod2htmd.tmp  pod2htmi.tmp

install: all
	test -d $(DESTDIR)$(bindir) || $(INSTALL) -d $(DESTDIR)$(bindir)
	test -d $(DESTDIR)$(man1dir) || $(INSTALL) -d $(DESTDIR)$(man1dir)
	test -d $(DESTDIR)$(sysconfdir) || $(INSTALL) -d $(DESTDIR)$(sysconfdir)
	test -d $(DESTDIR)$(datadir) || $(INSTALL) -d $(DESTDIR)$(datadir)
	$(INSTALL_PROGRAM) $(NAME) $(DESTDIR)$(bindir)
	$(INSTALL_DATA) $(MAN1) $(DESTDIR)$(man1dir)/$(NAME).1
	if test -f $(DESTDIR)$(sysconfdir)/$(NAME).conf ; then $(MV) $(DESTDIR)$(sysconfdir)/$(NAME).conf $(DESTDIR)$(sysconfdir)/$(NAME).conf.bak ; fi
	$(INSTALL_CONF) $(NAME).conf $(DESTDIR)$(sysconfdir)

uninstall:
	$(RM) -f $(DESTDIR)$(bindir)/$(NAME)
	$(RM) -f $(DESTDIR)$(man1dir)/$(NAME).1
	$(RM) -f $(DESTDIR)$(sysconfdir)/$(NAME).conf

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
