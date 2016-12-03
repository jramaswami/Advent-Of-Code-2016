;; Advent of Code 2016
;; Day 3, Part A

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
  (check-true (valid-triangle? (list 10 12 5))))

(module+ main
  (displayln (count-valid-triangles (read-input))))