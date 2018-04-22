PYTHON = $(shell which python3)
VENV = venv/

mkdir = mkdir -p $(dir $@/)

HOST = host.py
HTML = index.html
PORT = 5000
SHOWDOWN = showdown
SHOWDOWN_VERSION = 1.8.6

SHOWDOWN_TARBALL = $(SHOWDOWN)-$(SHOWDOWN_VERSION).tar.gz
SHOWDOWN_DIR = $(SHOWDOWN)-$(SHOWDOWN_VERSION)/
SHOWDOWN_JS = static/js/$(SHOWDOWN)/

.PHONY: all
all: $(SHOWDOWN_JS) host

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

.PHONY: host
host: $(VENV) $(HOST) $(HTML)
	@echo "Hosted @ http://$(shell hostname -I | xargs):$(PORT)/"
	@FLASK_APP=$(HOST) $</bin/flask \
		run \
			--host '0.0.0.0' \
			--port $(PORT) \
			--reload

$(HTML): $(VENV) $(shell find static/md/ -type f)
	@$</bin/python build.py > $@

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
	@rm -rf $(SHOWDOWN_JS)
	@rm -rf $(VENV)
	@find . -name '*.pyc' -delete
	@find . -name '__pycache__' -type d -delete
