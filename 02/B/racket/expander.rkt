#lang br/quicklang

(define-macro (advent-02-a-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [advent-02-a-begin #%module-begin]))

(define-macro (pp-program OP-OR-PUSH-ARG ...)
  #'(begin
      (void (fold-funcs (list OP-OR-PUSH-ARG ...)))))
(provide pp-program)

(define-macro-cases op
  [(op "U") #'up]
  [(op "D") #'down]
  [(op "L") #'left]
  [(op "R") #'right])
(provide op)

(define-macro (push N)
  #'push-button)
(provide push)

(struct position (x y) #:transparent)

(require "keypad.rkt")

(define (position->key pos)
  (let ([index  (+ (* KEYPAD-WIDTH (position-x pos)) (position-y pos))])
    (vector-ref KEYPAD index)))

(define (out-of-bounds? pos)
  (let ([x (position-x pos)]
        [y (position-y pos)])
    (or (< x 0)
        (>= x KEYPAD-HEIGHT)
        (< y 0)
        (>= y KEYPAD-WIDTH)
        (equal? (position->key pos) ""))))

;; Function to turn the list of keypushes into a keycode.
;; Be sure to drop the last number in the list which is the
;; result of "pushing" the key for the \n at the end of the
;; #lang declaration in the source file.
(require racket/match)
(define (list->keycode ks)
  (foldl string-append "" ks))

(define (up pos)
  (let* ([x (position-x pos)]
         [y (position-y pos)]
         [new-pos (position (sub1 x) y)])
    (if (out-of-bounds? new-pos)
        pos
        new-pos)))

(define (down pos)
  (let* ([x (position-x pos)]
         [y (position-y pos)]
         [new-pos (position (add1 x) y)])
    (if (out-of-bounds? new-pos)
        pos
        new-pos)))

(define (left pos)
  (let* ([x (position-x pos)]
         [y (position-y pos)]
         [new-pos (position x (sub1 y))])
    (if (out-of-bounds? new-pos)
        pos
        new-pos)))

(define (right pos)
  (let* ([x (position-x pos)]
         [y (position-y pos)]
         [new-pos (position x (add1 y))])
    (if (out-of-bounds? new-pos)
        pos
        new-pos)))

(define (push-button pos keycode moved?)
  (if moved?
      (cons (position->key pos) keycode)
      keycode))

(define (fold-funcs pp-funcs)
  (let-values ([(pos1 keycode1 moved1?) (for/fold ([pos (position 2 0)]
                                           [keycode '()]
                                           [moved? #f])
                                          ([pp-func (in-list pp-funcs)])
                                  (if (equal? pp-func push-button)
                                      (values pos (push-button pos keycode moved?) #f)
                                      (values (apply pp-func (list pos)) keycode #t)))])
    (let ([final-keycode (push-button pos1 keycode1 moved1?)])
      (displayln (list->keycode final-keycode)))))

(module+ test
  (require rackunit)
  (check-equal? (position->key (position 0 0)) "")
  (check-equal? (position->key (position 0 1)) "")
  (check-equal? (position->key (position 0 2)) "1")
  (check-equal? (position->key (position 1 0)) "")
  (check-equal? (position->key (position 1 1)) "2")
  (check-equal? (position->key (position 1 2)) "3")
  (check-equal? (position->key (position 2 0)) "5")
  (check-equal? (position->key (position 2 1)) "6")
  (check-equal? (position->key (position 2 2)) "7")
  
  (check-true (out-of-bounds? (position -1 1)))
  (check-true (out-of-bounds? (position 1 -1)))
  (check-true (out-of-bounds? (position 0 5)))
  (check-true (out-of-bounds? (position 5 1)))
  (check-true (out-of-bounds? (position 0 0)))
  (check-true (out-of-bounds? (position 4 1)))
  (check-false (out-of-bounds? (position 0 2)))
  (check-false (out-of-bounds? (position 2 2)))
  (check-false (out-of-bounds? (position 3 3)))
  (check-false (out-of-bounds? (position 4 2)))
  
  (check-equal? (position->key (up (position 0 2))) "1")
  (check-equal? (position->key (right (position 0 2))) "1")
  (check-equal? (position->key (left (position 0 2))) "1")
  (check-equal? (position->key (down (position 0 2))) "3")
  (check-equal? (position->key (left (position 3 1))) "A")
  (check-equal? (position->key (down (position 3 1))) "A")
  (check-equal? (position->key (up (position 3 1))) "6")
  (check-equal? (position->key (right (position 3 1))) "B")
  )