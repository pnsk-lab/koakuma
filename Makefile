# $Id$

PREFIX = /usr/local
REPLACE = sed "s%@@PREFIX@@%$(PREFIX)%g"

.PHONY: install

install: Components/* Tool/* koakuma.cgi.in
	mkdir -p $(PREFIX)/lib/koakuma/components/
	mkdir -p $(PREFIX)/lib/koakuma/htdocs/static/
	mkdir -p $(PREFIX)/etc/koakuma/
	mkdir -p $(PREFIX)/lib/koakuma/cgi-bin/
	mkdir -p $(PREFIX)/bin/
	cp -rf Components/* $(PREFIX)/lib/koakuma/components/
	cp -rf Tool/* $(PREFIX)/bin/
	cp -rf koakuma.png $(PREFIX)/lib/koakuma/htdocs/static/
	$(REPLACE) koakuma.cgi.in > $(PREFIX)/lib/koakuma/cgi-bin/koakuma.cgi
	$(REPLACE) apache.conf.in > $(PREFIX)/etc/koakuma/apache.conf
	chmod +x $(PREFIX)/lib/koakuma/cgi-bin/koakuma.cgi
	chmod +x $(PREFIX)/bin/create-task
	chmod +x $(PREFIX)/bin/launch-job
