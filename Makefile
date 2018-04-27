PYTHON = $(shell which python3)
VENV = venv/

mkdir = mkdir -p $(dir $@/)

HTML = index.html
HOST = 0.0.0.0
PORT = 5000
SHOWDOWN = showdown
SHOWDOWN_VERSION = 1.8.6
WSGI = wsgi.py

SHOWDOWN_TARBALL = $(SHOWDOWN)-$(SHOWDOWN_VERSION).tar.gz
SHOWDOWN_DIR = $(SHOWDOWN)-$(SHOWDOWN_VERSION)/
SHOWDOWN_JS = static/js/$(SHOWDOWN)/

.PHONY: all
all: wsgi

.PHONY: wsgi
wsgi: $(VENV) $(SHOWDOWN_JS) $(WSGI) $(HTML)
	@echo "Hosted @ http://$(shell hostname -I | xargs):$(PORT)/"
	@FLASK_ENV=development FLASK_RUN_HOST=$(HOST) FLASK_RUN_PORT=$(PORT) $</bin/flask run

$(SHOWDOWN_JS): $(SHOWDOWN_DIR)
	@$(mkdir)
	@cp $</dist/$(SHOWDOWN).min.js $@
	@cp $</dist/$(SHOWDOWN).min.js.map $@
	@rm -rf $<

.INTERMEDIATE: $(SHOWDOWN_DIR)
$(SHOWDOWN_DIR): $(SHOWDOWN_TARBALL)
	@tar \
		--extract \
		--gzip \
		--file $<
	@rm -f $<

.INTERMEDIATE: $(SHOWDOWN_TARBALL)
$(SHOWDOWN_TARBALL):
	@curl \
		--location \
		--silent \
		--output $@ \
		https://github.com/showdownjs/showdown/archive/$(SHOWDOWN_VERSION).tar.gz

$(HTML): $(VENV) $(WSGI) $(shell find static/md/ -type f)
	@$</bin/python $(WSGI) > $@

$(VENV): requirements.txt
	@virtualenv \
		--no-site-packages \
		--python=$(PYTHON) \
		$@
	@$@/bin/pip install \
		--requirement $<
	@$@/bin/pip install \
		--upgrade pip
	@touch $@

.PHONY: clean
clean:
	@rm -rf $(VENV)
	@find . -name '*.pyc' -delete
	@find . -name '__pycache__' -type d -delete
