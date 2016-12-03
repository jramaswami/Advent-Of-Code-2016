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

(define (position->number pos)
  (add1 (+ (* 3 (position-x pos)) (position-y pos))))

;; Function to turn the list of keypushes into a keycode.
;; Be sure to drop the last number in the list which is the
;; result of "pushing" the key for the \n at the end of the
;; #lang declaration in the source file.
(require racket/match)
(define (list->keycode ks)
  (define (helper0 ks0 m acc)
    (match ks0
      [(cons hd '()) acc]
      [(cons hd tl) (helper0 tl (* 10 m) (+ (* m hd) acc))]))
  (helper0 ks 1 0))

(define (up pos)
  (let ([x (position-x pos)]
        [y (position-y pos)])
    (if (> x 0)
        (position (sub1 x) y)
        pos)))

(define (down pos)
  (let ([x (position-x pos)]
        [y (position-y pos)])
    (if (< x 2)
        (position (add1 x) y)
        pos)))

(define (left pos)
  (let ([x (position-x pos)]
        [y (position-y pos)])
    (if (> y 0)
        (position x (sub1 y))
        pos)))

(define (right pos)
  (let ([x (position-x pos)]
        [y (position-y pos)])
    (if (< y 2)
        (position x (add1 y))
        pos)))

(define (push-button pos keycode)
  (cons (position->number pos) keycode))

(define (fold-funcs pp-funcs)
  (let-values ([(pos1 keycode1) (for/fold ([pos (position 1 1)]
                                           [keycode '()])
                                          ([pp-func (in-list pp-funcs)])
                                  (if (equal? pp-func push-button)
                                      (values pos (push-button pos keycode))
                                      (values (apply pp-func (list pos)) keycode)))])
    (let ([final-keycode (push-button pos1 keycode1)])
      (displayln (list->keycode final-keycode)))))

(module+ test
  (require rackunit)
  (check-equal? 1 (position->number (position 0 0)))
  (check-equal? 2 (position->number (position 0 1)))
  (check-equal? 3 (position->number (position 0 2)))
  (check-equal? 4 (position->number (position 1 0)))
  (check-equal? 5 (position->number (position 1 1)))
  (check-equal? 6 (position->number (position 1 2)))
  (check-equal? 7 (position->number (position 2 0)))
  (check-equal? 8 (position->number (position 2 1)))
  (check-equal? 9 (position->number (position 2 2)))
  
  (check-equal? 2 (position->number (up (position 1 1))))
  (check-equal? 8 (position->number (down (position 1 1))))
  (check-equal? 6 (position->number (right (position 1 1))))
  (check-equal? 4 (position->number (left (position 1 1))))
  
  (check-equal? 1 (position->number (up (position 0 0))))
  (check-equal? 1 (position->number (left (position 0 0))))
  (check-equal? 9 (position->number (down (position 2 2))))
  (check-equal? 9 (position->number (right (position 2 2))))
  )