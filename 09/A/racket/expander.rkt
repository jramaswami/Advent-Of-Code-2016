#lang br/quicklang

(define-macro (datalink-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [datalink-module-begin #%module-begin]))

(define-macro (datalink-expansion INSTR ...)
  #'(begin
      (void (fold-funcs (list INSTR ...)))))
(provide datalink-expansion)

(define (fold-funcs dl-exp-instr)
  (let ([expanded (for/fold ([S ""])
                            ([instr (in-list dl-exp-instr)])
                    (apply instr (list S)))])
    ;; (displayln expanded)
    (fprintf (current-output-port)
             "The length of the expanded file is ~a\n"
             (string-length expanded))))

(require racket/function)

(define-macro (shift STR)
  #'((curry do-shift) STR))
(provide shift)

(define-macro (expand REP STR)
  #'((curry do-expansion) REP STR))
(provide expand)

(define (do-shift s t)
  (string-append t s))

(define (do-expansion rep str t)
  (string-append t
                 (string-append* (make-list rep str))))