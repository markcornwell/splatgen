# makefile for splatgen

all:
	make build
	make run
	make install

build:
	stack build

run:
	stack run

install:
	cp out/*.png ../slgjff/assets

clean:
	rm out/*