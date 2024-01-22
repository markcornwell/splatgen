# makefile for splatgen

build:
	stack build

run:
	stack run

install:
	cp out/*.png ../slgjff/assets
