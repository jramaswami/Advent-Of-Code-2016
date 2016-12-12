#lang br/quicklang

(define-macro (bf-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [bf-module-begin #%module-begin]))

(provide assembunny-program copy-val copy-reg inc dec jnz-reg jnz-val init)

(require racket/function)
(define-macro (assembunny-program INSTRUCTIONS ...)
  #'(begin
      (void (run-program (list->vector (list INSTRUCTIONS ...))))))

(define-macro (copy-val #f VAL REG)
  #'((curry do-copy-val) VAL REG))

(define-macro (copy-reg #f REG0 REG1)
  #'((curry do-copy-reg) REG0 REG1))

(define-macro (inc #f REG)
  #'((curry do-inc) REG))

(define-macro (dec #f REG)
  #'((curry do-dec) REG))

(define-macro (jnz-reg #f REG OFFSET)
  #'((curry do-jnz-reg) REG OFFSET))

(define-macro (jnz-val #f VAL OFFSET)
  #'((curry do-jnz-val) VAL OFFSET))

(define-macro (init #f A B C D)
  #'((curry do-init) A B C D))

;; LOGIC
(define (do-inc reg registers)
  (begin
    (vector-set! registers reg (add1 (vector-ref registers reg)))
    1))

(define (do-dec reg registers)
  (begin
    (vector-set! registers reg (sub1 (vector-ref registers reg)))
    1))

(define (do-copy-reg reg0 reg1 registers)
  (begin
    (vector-set! registers reg1 (vector-ref registers reg0))
    1))

(define (do-copy-val val reg registers)
  (begin
    (vector-set! registers reg val)
    1))

(define (do-jnz-reg reg off registers)
  (if (not (= (vector-ref registers reg) 0))
      off
      1))

(define (do-jnz-val val off registers)
  (if (not (= val 0))
      off
      1))

(define (do-init a b c d registers)
  (vector-set! registers 0 a)
  (vector-set! registers 1 b)
  (vector-set! registers 2 c)
  (vector-set! registers 3 d)
  (vector-set! registers 4 1)
  1)

(define (run-program instruction-set)
  (define instruction-count (vector-length instruction-set))
  ; Define 4 registers plus an extra to hold the first line of the instructions
  ; in order to handle the optional possibility of an init statement.
  (define registers (make-vector 5 0))
  (define (apply-instruction ptr)
    (if (or (< ptr (vector-ref registers 4)) (>= ptr instruction-count))
        (let ([register-names '#(#\a #\b #\c #\d)])
          (for ([i (range 4)])
            (fprintf (current-output-port)
                     "Register ~a: ~a\n"
                     (vector-ref register-names i)
                     (vector-ref registers i))))
        (let ([instruction (vector-ref instruction-set ptr)])
          (apply-instruction (+ ptr (apply instruction (list registers)))))))
  (apply-instruction 0))