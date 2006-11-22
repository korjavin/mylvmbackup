#
# Simple Makefile for mylvmbackup
#

# required programs
CHMOD = /bin/chmod
CP = /bin/cp
GZIP = /bin/gzip
INSTALL = /usr/bin/install
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_PROGRAM = $(INSTALL) -m 755
INSTALL_CONF = $(INSTALL) -m 600
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
VERSION = 0.2
MAN1 = man/$(NAME).en.1 
DISTFILES = COPYING \
	INSTALL \
	ChangeLog \
	Makefile \
	$(NAME) \
	$(NAME).pl.in \
	$(NAME).spec \
	$(NAME).spec.in \
	$(NAME).conf \
	README \
	TODO
CLEANFILES = $(NAME).spec $(NAME)
prefix = /usr/local
sysconfdir = /etc
bindir = $(prefix)/bin
distdir = $(NAME)-$(VERSION)
mandir = $(prefix)/man
man1dir = $(mandir)/man1

all: $(DISTFILES)

$(NAME).spec: $(NAME).spec.in
	$(SED) -e s/@VERSION@/$(VERSION)/ < $< > $@

$(NAME): $(NAME).pl.in
	$(SED) -e s/@VERSION@/$(VERSION)/ < $< > $@
	$(CHMOD) 755 $@

install: all
	test -d $(DESTDIR)$(bindir) || $(INSTALL) -d $(DESTDIR)$(bindir)
	test -d $(DESTDIR)$(man1dir) || $(INSTALL) -d $(DESTDIR)$(man1dir)
	$(INSTALL_PROGRAM) $(NAME) $(DESTDIR)$(bindir)
	$(INSTALL_DATA) $(MAN1) $(DESTDIR)$(man1dir)/$(NAME).1
	$(INSTALL_CONF) $(NAME).conf $(DESTDIR)$(sysconfdir)

uninstall:
	$(RM) -f $(DESTDIR)$(bindir)/$(NAME)
	$(RM) -f $(DESTDIR)$(man1dir)/$(NAME).1
	$(RM) -f $(DESTDIR)$(sysconfdir)/$(NAME).conf

distdir: all
	if test -d $(distdir) ; then $(RM) -rf $(distdir) ; fi
	mkdir $(distdir)
	$(CP) $(DISTFILES) $(distdir)
	mkdir $(distdir)/man
	$(CP) $(MAN1) $(distdir)/man

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
