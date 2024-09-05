TARGET = install
VERSION = latest

all: submodule docker deinit

docker:
	docker build -f Dockerfile --pull -t stanford-mirc-ctp:$(VERSION) .

submodule: 
	git submodule update --init --recursive
	git submodule update --remote --merge

deinit:
	git submodule deinit -f .
