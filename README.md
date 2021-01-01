This makes it easy to use SBCL for shell scripts with a #! line.

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

See `example.lisp` for an example using exlisp once it is installed.

## Convenience Tools

The :shell package makes it easier to execute actual shell commands
from within the script.

The main support is the `#$` reader macro. It passes anything between
it and `$#` to
[`(uiop:run-program)`](https://common-lisp.net/project/asdf/uiop.html#UIOP_002fRUN_002dPROGRAM). `uiop:run-program`
returns three values (stdout, stderr, and return code), so these are
available for the script.

For convenience, `#$` also terminates if it reaches the end of a
line, so commands which need to be run with no other interaction can
be written alone between other Lisp, like:

```lisp
(format t "Hello, world~%")

 #$ rm /tmp/foo

(if (probe-file "/tmp/foo")
  (format t "I guess it didn't get deleted.~%"))
```

Finally, it defines a few small functions, so far just `(cd)` and
`(echo)`, meant to make those commands available in Lisp instead of
having to escape to shell.

### Future Work

This is the main area to improve on usabiliy for exlisp.

It would be nice to:

-  Support running programs in the background, perhaps with a `#&`
   macro
-  Support string interpolation inside `#$`
-  Define an easy way to pass text to stdin for a command called by
   `#$`
-  Allow an option to `#$` (and related macros, if any) that directly
   connects stdin/stdout to the calling terminal, for invoking
   interactive programs

# Footnote

This is not an officially supported Google product.
