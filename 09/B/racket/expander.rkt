#lang br/quicklang

(define-macro (datalink-module-begin PARSE-TREE)
  #'(#%module-begin
     'PARSE-TREE))
(provide (rename-out [datalink-module-begin #%module-begin]))

(define-macro (datalink-instr DL-INSTR ...)
  #'(fold-funcs (list DL-INSTR ...)))
(provide datalink-instr)

(define (fold-funcs instrs)
  (displayln (apply + instrs)))

(define (shift s)
  (string-length s))
(provide shift)

(define (expand rep n)
  (* rep n))
(provide expand)