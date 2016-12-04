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

(define (key->position key)
  (let ([limit (* KEYPAD-HEIGHT KEYPAD-WIDTH)])
    (define (helper0 x)
      (cond [(= x limit) #f]
            [(equal? (vector-ref KEYPAD x) key) x]
            [else (helper0 (add1 x))]))
    (let ([index  (helper0 0)])
      (position (quotient index KEYPAD-WIDTH) (remainder index KEYPAD-WIDTH)))))

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
  (let-values ([(pos1 keycode1 moved1?) (for/fold ([pos (key->position START-KEY)]
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
  (check-equal? "1" (position->key (position 0 0)))
  (check-equal? "2" (position->key (position 0 1)))
  (check-equal? "3" (position->key (position 0 2)))
  (check-equal? "4" (position->key (position 1 0)))
  (check-equal? "5" (position->key (position 1 1)))
  (check-equal? "6" (position->key (position 1 2)))
  (check-equal? "7" (position->key (position 2 0)))
  (check-equal? "8" (position->key (position 2 1)))
  (check-equal? "9" (position->key (position 2 2)))
  
  (check-equal? "2" (position->key (up (position 1 1))))
  (check-equal? "8" (position->key (down (position 1 1))))
  (check-equal? "6" (position->key (right (position 1 1))))
  (check-equal? "4" (position->key (left (position 1 1))))
  
  (check-equal? "1" (position->key (up (position 0 0))))
  (check-equal? "1" (position->key (left (position 0 0))))
  (check-equal? "9" (position->key (down (position 2 2))))
  (check-equal? "9" (position->key (right (position 2 2))))

  (for ([i (range 1 10)])
    (check-equal? (position->key (key->position (number->string i))) (number->string i)))
  )