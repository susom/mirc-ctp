TARGET = install
VERSION = 1.1.0

.PHONY: clean

all: clean install docker

clean:
	git submodule update --init --recursive
	# This one brings the changes to local
	git submodule update --remote --merge
	cd CTP
	git fetch
	cd ..
	cd DicomAnonymizerTool
	git fetch
	cd ..

install: 
	$(MAKE) -C CTP
	ant

docker:
	docker build -f Dockerfile --pull -t starr-radio-kit:$(VERSION) .

check: 
	$(MAKE) -C tests check

flush:
	$(info Flushing the WDL run and call AnonymizeDicomImages caches)
	rm -rf tests/wdl/_LAST 
	rm -rf tests/wdl/20[2-9][2-9][0-9][0-9][0-9][0-9]_*_*
	rm -rf ~/.cache/miniwdl/AnonymizeDicomImagesTest/*

all: clean install

	