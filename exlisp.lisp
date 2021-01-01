#! /usr/bin/sbcl --script
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;    https://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.
;;

;; Load .sbclrc which is suppressed for --script
;; mainly to include Quicklisp
(eval-when (:load-toplevel :compile-toplevel :execute)
  (let ((sbclrc (merge-pathnames ".sbclrc"
				 (user-homedir-pathname))))
    (when (probe-file sbclrc)
      (load sbclrc))))

;; Load modules that should be available to all scripts
(eval-when (:load-toplevel :compile-toplevel :execute)
  (ql:quickload '(:alexandria
		  ;; ADD MORE LIBRARIES HERE IF YOU WANT
		  :eric
		  :shell
		  :split-sequence)))

(use-package '(:shell
	       :split-sequence))

(defun help ()
  (format t "This was generated by ~a and is meant to be used in shebang lines for lisp programs that should have useful libraries included.~%"
	  (first *posix-argv*)))

(defun toplevel-init ()
  (let ((sb-ext:*posix-argv* (append (list (first sb-ext:*posix-argv*)
					   "--script")
				     (rest sb-ext:*posix-argv*))))
    (sb-impl::toplevel-init)))

(save-lisp-and-die "exlisp" :executable t :toplevel 'toplevel-init)
