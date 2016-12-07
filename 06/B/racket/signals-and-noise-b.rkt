#lang racket

(define (read-input)
  (define (helper0 acc)
    (let ([line (read-line)])
      (if (eof-object? line)
	  (list->vector acc)
	  (helper0 (cons (list->vector (string->list (string-trim line))) acc)))))
  (helper0 '()))

(define (get-value r c M)
  (let ([row (vector-ref M r)])
    (vector-ref row c)))

(define (least-common memo)
  (let-values
      ([(min-val min-cnt)
	(for/fold
	    ([v #f]
	     [c +inf.0])
	    ([k (hash-keys memo)])
	  (let ([c1 (hash-ref memo k)])
	    (if (< c1 c)
		(values k c1)
		(values v c))))])
    min-val))
	
(define (repair-transmission T)
  (let ([row-limit (vector-length T)]
	[col-start (sub1 (vector-length (vector-ref T 0)))])
    (define (helper0 row col memo acc)
      (cond [(= col -1) (list->string acc)]
	    [(= row row-limit) (helper0 0 (sub1 col) (make-hash) (cons (least-common memo) acc))]
	    [else (let ([x (get-value row col T)])
		    (begin
		      (hash-set! memo x (add1 (hash-ref memo x (lambda () 0))))
		      (helper0 (add1 row) col memo acc)))]))
    (helper0 0 col-start (make-hash) '())))

(module+ main
  (displayln (repair-transmission (read-input))))
