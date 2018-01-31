#
#<<
# % installation
#
# # Installation
#
# Installing oo-tools is quite straight forward.
#
# From the oo-tools directory enter:
#
#     sudo make install
#
# Similarly, to un-install:
#
#     sudo make uninstall
#>>
ROOT=
SCRIPTS=oodoc xssh smtp_gw cfme-ci cfme-api
BINDIR=/usr/bin
MANDIR=/usr/share/man
CMSDIR=/var/www/html/pico/content/oo-tools

help:
	@echo "Use:"
	@echo "	sudo make install - to install"
	@echo "	sudo make uninstall - to un-install"
	@echo "	sudo make deps - to install dependancies"

install:
	for n in $(SCRIPTS) ;\
	do \
		install --compare -D --mode=0755 $$n $(ROOT)$(BINDIR)/$$n ;\
	done
	for n in $$(perl oodoc genman $(SCRIPTS)) ;\
	do \
		b=$$(basename $$n) ;\
		install --compare -D --mode=0644 $$b $(ROOT)$(MANDIR)/$$n ;\
		rm -f $$b ;\
	done
	install --compare -D --mode=0644 smtp_gw.service $(ROOT)/etc/systemd/system/smtp_gw.service
	[ ! -f $(ROOT)/etc/smtp_gw.config ] && install --mode=0644 smtp_gw.config $(ROOT)/etc/smtp_gw.config || :

uninstall:
	for n in $(SCRIPTS) ;\
	do \
		mann=$$(perl oodoc man --query=sn $$n) ;\
		pg=$$n.$$mann.gz ;\
		rm -f $(ROOT)$(BINDIR)/$$n $$pg $(ROOT)$(MANDIR)/man$$mann/$$pg ;\
	done
	rm -f $(ROOT)/etc/systemd/system/smtp_gw.service
	@echo Keeping /etc/smtp_gw.config

deps:
	yum install -y epel-release
	yum install -y openssh-clients nmap-ncat
	yum install -y pandoc perl perl-YAML
	yum install -y python-requests

cms:
	./oodoc exdoc --outdir=$(CMSDIR) .

