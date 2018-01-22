#
SCRIPTS=oodoc runapi xssh
BINDIR=/usr/bin
MANDIR=/usr/share/man

help:
	@echo "Use:"
	@echo "	sudo make install - to install"
	@echo "	sudo make uninstall - to un-install"
	@echo "	sudo make deps - to install dependancies"

install:
	for n in $(SCRIPTS) ;\
	do \
		install --compare -D --mode=0755 $$n $(BINDIR)/$$n ;\
		mann=$$(perl oodoc man --query=sn $$n) ;\
		pg=$$n.$$mann.gz ;\
		perl oodoc man --zroff=$$pg $$n ;\
		install --compare -D --mode=0644 $$pg $(MANDIR)/man$$mann/$$pg ;\
		rm -f $$pg ;\
	done

uninstall:
	for n in $(SCRIPTS) ;\
	do \
		mann=$$(perl oodoc man --query=sn $$n) ;\
		pg=$$n.$$mann.gz ;\
		rm -f $(BINDIR)/$$n $$pg $(MANDIR)/man$$mann/$$pg ;\
	done

deps:
	yum install -y epel-release
	yum install -y openssh-clients nmap-ncat
	yum install -y pandoc perl perl-YAML
	yum install -y curl jq
