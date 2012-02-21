;;;; quasiquote1.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)

(defsystem :quasiquote1
  :serial t
  :depends-on (:fiveam
               :named-readtables)
  :components ((:file "package")
               (:file "quasiquote1")
               (:file "readtable")))

(defmethod perform ((o test-op) (c (eql (find-system :quasiquote1))))
  (load-system :quasiquote1)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :quasiquote1.internal :quasiquote1))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
