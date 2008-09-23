#
# Simple Makefile for mylvmbackup
#

# required programs
A2X = /usr/bin/a2x
A2XMANFLAGS = -d manpage -f manpage
A2XHTMLFLAGS = -d manpage -f xhtml
CHMOD = /bin/chmod
CP = /bin/cp
FIND = /usr/bin/find
GZIP = /bin/gzip
INSTALL = /usr/bin/install
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_PROGRAM = $(INSTALL) -m 755
INSTALL_CONF = $(INSTALL) -m 600
MV = /bin/mv
POD2MAN = /usr/bin/pod2man
POD2TEXT = /usr/bin/pod2text
RM = /bin/rm
RPMBUILD = /usr/bin/rpmbuild
RPMFLAGS = -ta --clean
SED = /bin/sed
SHELL = /bin/sh
TAR = /bin/tar

# define some variables

NAME = mylvmbackup
VERSION = 0.11
MAN1 = man/$(NAME).1
DISTFILES = COPYING \
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
	$(SED) -e s/@VERSION@/$(VERSION)/ < $< > $@
	$(CHMOD) 755 $@

$(MAN1):
	$(A2X) $(A2XMANFLAGS) $(MAN1).txt
	$(RM) $(MAN1).xml

htmlman:
	$(A2X) $(A2XHTMLFLAGS) $(MAN1).txt
	$(RM) $(MAN1).xml

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
