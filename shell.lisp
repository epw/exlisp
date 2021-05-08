;; Copyright 2020 Google LLC
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

;; This implements tools to make it easier to write shell scripts in Lisp
;;
;; At the simplest, the #$ reader macro transforms the rest of the line
;; (or until $# is encountered) into a call to #'uiop:run-program
;; that returns multiple values: stdout, stderr, and the return code.

;; (maybe add #& for asynchronous calls?)



(defpackage :shell
  (:use :cl :split-sequence)
  (:export :*script-filename*
	   :cd
	   :echo
	   :sharp-dollar
	   :shell-line))

(in-package :shell)

(defvar *script-filename* NIL)

(defun shell-line (line)
  (uiop:run-program line
		    :output '(:string :stripped t)
		    :error-output '(:string :stripped t)
		    :ignore-error-status t))

(defun sharp-dollar-el (el)
  (typecase el
    (symbol el)
    (t (format nil "~a" el))))

(defun sharp-dollar (stream subchar arg)
  (declare (ignore subchar arg))
  (let (buf vars)
    (flet ((append-character (c)
	     (typecase c
	       (character
		(typecase (first buf)
		  (string (setf (first buf) (format nil "~a~a" (first buf) c)))
		  (t (push (format nil "~a" c) buf))))
	       (t
		(push c vars)
		(push "~a" buf)))))
      (loop
	 (let ((c (peek-char nil stream nil)))
	   (case c
	     ((nil #\Newline)
	      (return))
	     (#\$
	      (read-char stream nil)
	      (setf c (peek-char nil stream nil))
	      (if (eq c #\#)
		  (progn
		    (read-char stream nil)
		    (return))
		  (append-character (read stream nil))))
	     (t
	      (append-character (read-char stream nil)))))))
    (alexandria:with-unique-names (full-command args)
      `(let* ((,full-command (format nil (concatenate 'string ,@(reverse buf)) ,@vars))
	      (,args (split-sequence #\Space ,full-command)))
	 (alexandria:switch ((first ,args) :test #'string=)
	   ("cd" (sb-posix:chdir (second ,args)))
	   (t
	    (shell-line ,full-command)))))))

(set-dispatch-macro-character #\# #\$ #'sharp-dollar)

(defun cd (pathname)
  (sb-posix:chdir pathname))

(defun echo (s)
  (format t "~a~%" s))
