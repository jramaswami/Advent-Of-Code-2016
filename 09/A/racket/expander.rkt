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
                            ([instr (in-list (reverse dl-exp-instr))])
                    (apply instr (list S)))])
    (displayln expanded)
    (fprintf (current-output-port)
             "\nThe length of the expanded file is ~a\n"
             (string-length expanded))))

(require racket/function)

(define-macro (shift STR)
  #'((curry do-shift) STR))
(provide shift)

(define-macro (expand #f LEN REP)
  #'((curry do-expansion) LEN REP))
(provide expand)

(define (do-shift s t)
  (string-append s t))

(define (do-expansion len rep t)
  (let ([hd (substring t 0 len)]
        [tl (substring t len)])
    (string-append
     (string-append* (make-list rep hd))
     tl)))

(module+ test
  (require rackunit)
  (check-equal? (do-expansion 1 5 "a") "aaaaa")
  (check-equal? (do-expansion 2 5 "abc") "abababababc")
  (check-equal? (do-shift "x" "abc") "xabc")
  )