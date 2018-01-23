#
SCRIPTS=oodoc xssh
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
	done
	for n in $$(perl oodoc genman $(SCRIPTS)) ;\
	do \
		b=$$(basename $$n) ;\
		install --compare -D --mode=0644 $$b $(MANDIR)/$$b ;\
		rm -f $$b ;\
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
