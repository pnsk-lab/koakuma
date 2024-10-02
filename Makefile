# $Id$

PREFIX = /usr/local
REPLACE = sed "s%@@PREFIX@@%$(PREFIX)%g"

.PHONY: install

install: Component/* Tool/* Utility/* koakuma.cgi.in apache.conf.in
	mkdir -p $(PREFIX)/lib/koakuma/component/
	mkdir -p $(PREFIX)/lib/koakuma/utility/
	mkdir -p $(PREFIX)/lib/koakuma/htdocs/static/
	mkdir -p $(PREFIX)/etc/koakuma/
	mkdir -p $(PREFIX)/lib/koakuma/cgi-bin/
	mkdir -p $(PREFIX)/bin/
	mkdir -p $(PREFIX)/lib/koakuma/db
	mkdir -p $(PREFIX)/lib/koakuma/db/data
	if [ ! -e "$(PREFIX)/lib/koakuma/db/projects.db" ] ; then echo "<projects></projects>" > $(PREFIX)/lib/koakuma/db/projects.db ; fi
	cp -rf Component/* $(PREFIX)/lib/koakuma/component/
	cp -rf Utility/* $(PREFIX)/lib/koakuma/utility/
	$(REPLACE) Tool/create-project.in > $(PREFIX)/bin/create-project
	$(REPLACE) Tool/launch-job.in > $(PREFIX)/bin/launch-job
	cp -rf koakuma.png $(PREFIX)/lib/koakuma/htdocs/static/
	cp style.css $(PREFIX)/lib/koakuma/htdocs/static/
	$(REPLACE) koakuma.cgi.in > $(PREFIX)/lib/koakuma/cgi-bin/koakuma.cgi
	$(REPLACE) apache.conf.in > $(PREFIX)/etc/koakuma/apache.conf
	chmod +x $(PREFIX)/lib/koakuma/cgi-bin/koakuma.cgi
	chmod +x $(PREFIX)/bin/create-project
	chmod +x $(PREFIX)/bin/launch-job
	@echo
	@echo Make sure $(PREFIX)/lib/koakuma/db is writable by your HTTPd user.
	@echo Assuming your HTTPd user is www, just run: chmod -R www $(PREFIX)/lib/koakuma/db
	@echo
	@echo By default, Koakuma stock Apache config uses $(PREFIX)/etc/koakuma/passwd
	@echo for RPC authentication.
