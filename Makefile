ROOT = /usr/local

QUICKLISP = $(HOME)/quicklisp

all: exlisp

exlisp: exlisp.lisp
	(cd $(QUICKLISP)/local-projects/; ln -sf $(CURDIR)/shell.asd)
	./exlisp.lisp

install:
	cp exlisp $(ROOT)/bin/.
