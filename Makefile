ROOT = /usr/local

QUICKLISP = $(HOME)/quicklisp

all: exlisp

shell: shell.lisp shell.asd
	(cd $(QUICKLISP)/local-projects/; ln -sf $(CURDIR)/shell.asd)


exlisp: exlisp.lisp shell
	./exlisp.lisp

exlisp-cgi: exlisp.lisp shell
	EXLISP_LIBS=


install:
	cp exlisp $(ROOT)/bin/.

clean:
	rm -f exlisp *.fasl
