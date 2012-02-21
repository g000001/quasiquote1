;;;; quasiquote1.lisp

(cl:in-package :quasiquote1.internal)

(def-suite quasiquote1)

(in-suite quasiquote1)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun qq-expand-list (x depth)
    (if (consp x)
        (case (car x)
          ((quasiquote)
           (list (quote list)
                 (list 'cons (list (quote quote) (car x))
                       (qq-expand (cdr x) (+ depth 1)))))
          ((unquote unquote-splicing)
           (cond ((> depth 0)
                  (list (quote list)
                        (list (quote cons)
                              (list (quote quote)
                                    (car x))
                              (qq-expand (cdr x) (- depth 1)))))
                 ((eq (quote unquote) (car x))
                  (list* (quote list)
                         (cdr x)))
                 (:else
                  (list* (quote append)
                         (cdr x)))))
          (otherwise
           (list (quote list)
                 (list (quote append)
                       (qq-expand-list (car x) depth)
                       (qq-expand (cdr x) depth)))))
        (list (quote quote)
              (list x) )))

  (defun qq-expand (x depth)
    (if (consp x)
        (case (car x)
          ((quasiquote)
           (list (quote cons)
                 (list (quote quote)
                       (car x) )
                 (qq-expand (cdr x) (+ depth 1)) ))
          ((unquote unquote-splicing)
           (cond ((> depth 0)
                  (list (quote cons)
                        (list (quote quote)
                              (car x) )
                        (qq-expand (cdr x) (- depth 1)) ))
                 ((and (eq (quote unquote) (car x))
                       (not (null (cdr x)))
                       (null (cddr x)) )
                  (cadr x) )
                 (:else
                  (error "Illegal") )))
          (otherwise
           (list (quote append)
                 (qq-expand-list (car x) depth)
                 (qq-expand (cdr x) depth) )))
        (list (quote quote) x) )))

(defmacro quasiquote (&whole form expr)
  (if (eq (quote quasiquote) (car form))
      (qq-expand expr 0)
      form ))

;;; eof
