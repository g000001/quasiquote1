;;;; readtable.lisp

(cl:in-package :quasiquote1.internal)
(in-readtable :common-lisp)

(defreadtable :quasiquote
  (:merge :standard)
  (:macro-char  #\,
                (lambda (stream char)
                  (declare (ignore char))
                  (let ((next (peek-char t stream t nil t)))
                    (if (char= #\@ next)
                        (progn
                          (read-char stream t nil t)
                          (list (quote unquote-splicing)
                                (read stream t nil t) ))
                        (list (quote unquote)
                              (read stream t nil t) )))))
  (:macro-char #\`
               (lambda (stream char)
                 (declare (ignore char))
                 (list (quote quasiquote)
                       (read stream t nil t) )))
  (:case :upcase))

;;; eof
