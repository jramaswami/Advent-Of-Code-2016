;; Advent of Code 2016
;; Day 3, Part B

#lang racket

(define (read-triangle)
  (let ([a (read)])
    (if (eof-object? a)
        #f
        (let ([b (read)]
              [c (read)])
          (list a b c)))))

(define (valid-triangle? ts)
  (let ([ts0 (sort ts <)])
    (if (> (+ (first ts0) (second ts0)) (third ts0))
        #t
        #f)))

(define (count-valid-triangles ts)
  (foldl + 0 (map (lambda (t) (if (valid-triangle? t) 1 0)) ts)))

(define (read-input)
  (define (read-loop t acc)
    (if t
        (read-loop (read-triangle) (cons t acc))
        acc))
  (read-loop (read-triangle) '()))

(module+ test
  (require rackunit)
  (check-false (valid-triangle? (list 5 10 25)))
  (check-false (valid-triangle? (list 25 10 5)))
  (check-true (valid-triangle? (list 5 10 12)))
  (check-true (valid-triangle? (list 10 12 5)))
  (define T '((5 5 2) (10 10 2) (25 12 3) (10 12 3) (25 5 2) (5 10 2)))
  (define T0 '((3 2 2) (12 5 10) (10 25 5) (2 2 3) (5 10 12) (5 10 25)))
  (check-equal? (row-wise->column-wise T) T0))

(define (row-wise->column-wise ts)
  (define (helper0 xs acc)
    (if (empty? xs)
        acc
        (let* ([as (first xs)]
               [bs (second xs)]
               [cs (third xs)]
               [t1 (list (first as) (first bs) (first cs))]
               [t2 (list (second as) (second bs) (second cs))]
               [t3 (list (third as) (third bs) (third cs))])
          (helper0 (drop xs 3) (cons t3 (cons t2 (cons t1 acc)))))))
  (helper0 ts '()))

(module+ main
  (displayln (count-valid-triangles (row-wise->column-wise (read-input)))))