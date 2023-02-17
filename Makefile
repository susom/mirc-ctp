TARGET = install
VERSION = 1.0.0

.PHONY: clean

all: clean install docker

docker:
	docker build -f Dockerfile --pull -t starr-radio:$(VERSION) .

install: 
	git submodule update --init --recursive
	cd CTP
	git fetch
	cd ..
	cd DicomAnonymizerTool
	git fetch
	cd ..
	$(MAKE) -C CTP
	ant

check: 
	$(MAKE) -C tests check

all: clean install

	