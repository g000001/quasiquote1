;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :quasiquote1
  (:use)
  (:export :quasiquote
           :unquote
           :unquote-splicing))

(defpackage :quasiquote1.internal
  (:use :quasiquote1 :cl :named-readtables :fiveam))
