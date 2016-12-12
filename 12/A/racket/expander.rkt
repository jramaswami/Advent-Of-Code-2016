#lang br/quicklang

(define-macro (bf-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [bf-module-begin #%module-begin]))

(provide assembunny-program copy-val copy-reg inc dec jnz)

(require racket/function)
(define-macro (assembunny-program INSTRUCTIONS ...)
  #'(begin
      (displayln (list INSTRUCTIONS ...))
      (run-program (list->vector (list INSTRUCTIONS ...)))))

(define-macro (copy-val #f VAL REG)
  #'((curry do-copy-val) VAL REG))

(define-macro (copy-reg #f REG0 REG1)
  #'((curry do-copy-reg) REG0 REG1))

(define-macro (inc #f REG)
  #'((curry do-inc) REG))

(define-macro (dec #f REG)
  #'((curry do-dec) REG))

(define-macro (jnz #f REG OFFSET)
  #'((curry do-jnz) REG OFFSET))


;; LOGIC
(define registers (make-vector 4 0))

(define (do-inc reg)
  (begin
    (vector-set! registers reg (add1 (vector-ref registers reg)))
    1))

(define (do-dec reg)
  (begin
    (vector-set! registers reg (sub1 (vector-ref registers reg)))
    1))

(define (do-copy-reg reg0 reg1)
  (begin
    (vector-set! registers reg1 (vector-ref registers reg0))
    1))

(define (do-copy-val val reg)
  (begin
    (vector-set! registers reg val)
    1))

(define (do-jnz reg off)
  (if (= (vector-ref registers reg) 0)
      off
      1))

(define (run-program instruction-vector)
  (define instruction-count (vector-length instruction-vector))
  (displayln instruction-vector)
  (define (apply-instruction ptr)
    (if (or (< ptr 0) (>= ptr instruction-count))
        registers
        (let ([instruction (vector-ref instruction-vector ptr)])
          (apply-instruction (+ ptr (apply instruction '()))))))
  (apply-instruction 0))