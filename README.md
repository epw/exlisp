This makes it easy to use SBCL for shell scripts with a shebang line.

The key is that it creates a new executable that works exactly like SBCL, but
has several useful modules pre-included, so you don't have to wait for them to
load each time the script runs.

For comparison, example.lisp runs in around 0.05s But running it by first
loading quicklisp and all the dependencies, with a command like the following,
takes about 1s.

```lisp
$ sbcl --eval "(load \"$HOME/.sbclrc\")" \
--eval '(ql:quickload (list :alexandria :split-sequence))' \
--script example.lisp
```

You must have [Quicklisp](https://www.quicklisp.org/) installed to build this.
Once you do, you can run `make all` and `sudo make install`

This is not an officially supported Google product.
