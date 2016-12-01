#lang br/quicklang
(define-macro (advent-01-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [advent-01-begin #%module-begin]))

(struct position (x y) #:transparent)
(struct direction (x y) #:transparent)
(struct environment (position direction) #:transparent)

(define (direction->cardinal d)
  (cond [(equal? d (direction 0 1)) "N"]
        [(equal? d (direction 1 0)) "E"]
        [(equal? d (direction 0 -1)) "S"]
        [(equal? d (direction -1 0)) "W"]))

(define (make-turn env arg)
  (let ([current-position (environment-position env)]
        [current-direction (environment-direction env)])
    ;; Turning means swaping the one from x->y when facing E or W
    ;; and from y->x when facing N or S.
    (let ([new-direction
           (if (= 0 (direction-y current-direction))
               ;; Facing E or W (the sign changes when turning right)
               (if (equal? arg "R")
                   (direction 0 (* -1 (direction-x current-direction)))
                   (direction 0 (direction-x current-direction)))
               ;; Facing N or S (the sign changes when turning left)
               (if (equal? arg "L")
                   (direction (* -1 (direction-y current-direction)) 0)
                   (direction (direction-y current-direction) 0)))])
      (environment current-position new-direction))))

(define (make-move env arg)
  (let* ([current-position (environment-position env)]
         [current-direction (environment-direction env)]
         [new-position  (position (+ (position-x current-position) (* (string->number arg) (direction-x current-direction)))
                                 (+ (position-y current-position) (* (string->number arg) (direction-y current-direction))))])
    (environment new-position current-direction)))

(define-macro (ebh-program TURN-OR-MOVE-ARG ...)
  #'(void (fold-funcs (list TURN-OR-MOVE-ARG ...))))
(provide ebh-program)

(require racket/function)
(define-macro (move ARG)
  #'((curryr make-move) ARG))
(provide move)

(define-macro (turn ARG)
  #'((curryr make-turn) ARG))
(provide turn)

(define (fold-funcs ebh-funcs)
  (define final-env (for/fold ([env (environment (position 0 0) (direction 0 1))])
                              ([ebh-func (in-list ebh-funcs)])
                      (apply ebh-func (list env))))
  (let ([x (position-x (environment-position final-env))]
        [y (position-y (environment-position final-env))])
    (fprintf (current-output-port) "Current position (~a, ~a) which is ~a blocks away from (0,0)\n" x y (+ (abs x) (abs y)))))

(module+ test
  (require rackunit)
  ;; Turn Right
  (check-equal? (environment-direction (make-turn (environment (position 0 0) (direction 0 1)) "R")) (direction 1 0))
  (check-equal? (environment-direction (make-turn (environment (position 0 0) (direction 1 0)) "R")) (direction 0 -1))
  (check-equal? (environment-direction (make-turn (environment (position 0 0) (direction 0 -1)) "R")) (direction -1 0))
  (check-equal? (environment-direction (make-turn (environment (position 0 0) (direction -1 0)) "R")) (direction 0 1))
  ;; Turn Left
  (check-equal? (environment-direction (make-turn (environment (position 0 0) (direction 0 1)) "L")) (direction -1 0))
  (check-equal? (environment-direction (make-turn (environment (position 0 0) (direction -1 0)) "L")) (direction 0 -1))
  (check-equal? (environment-direction (make-turn (environment (position 0 0) (direction 0 -1)) "L")) (direction 1 0))
  (check-equal? (environment-direction (make-turn (environment (position 0 0) (direction 1 0)) "L")) (direction 0 1))
  ;; Moving
  (check-equal? (environment-position (make-move (environment (position 0 0) (direction 0 1)) "2")) (position 0 2))
  (check-equal? (environment-position (make-move (environment (position 0 0) (direction -1 0)) "2")) (position -2 0))
  (check-equal? (environment-position (make-move (environment (position 0 0) (direction 0 -1)) "2")) (position 0 -2))
  (check-equal? (environment-position (make-move (environment (position 0 0) (direction 1 0)) "2")) (position 2 0))
  
  )