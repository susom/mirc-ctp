TARGET = install
VERSION = 1.0.0

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

all: clean install

	