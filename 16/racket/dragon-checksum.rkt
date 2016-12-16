#lang racket

(require data/bit-vector)

(define (reverse-not xs)
  (define (helper0 xs0 acc)
    (cond [(empty? xs0) acc]
          [(= (car xs0) 1) (helper0 (cdr xs0) (cons 0 acc))]
          [else (helper0 (cdr xs0) (cons 1 acc))]))
  (helper0 xs '()))

(define (dragon-curve v)
  (let* ([l (bit-vector-length v)]
         [l0 (add1 (* 2 l))]
         [v0 (make-bit-vector l0)])
    (for ([i (range l)])
      (let ([t (bit-vector-ref v i)])
        (bit-vector-set! v0 i t)
        (bit-vector-set! v0 (- l0 1 i) (not t))))
    v0))

(define (checksum v)
  (let ([l (bit-vector-length v)])
    (if (odd? l)
        v
        (let* ([l0 (/ l 2)]
               [v0 (make-bit-vector l0)])
          (for ([i (range l0)])
            (let* ([j (* 2 i)]
                   [k (add1 j)])
              (if (equal? (bit-vector-ref v j) (bit-vector-ref v k))
                  (bit-vector-set! v0 i #t)
                  (bit-vector-set! v0 i #f))))
          (checksum v0)))))

(define (fill-disk data len)
  (cond [(= len (bit-vector-length data)) data]
        [(< len (bit-vector-length data))
         (let ([v0 (make-bit-vector len)])
           (for ([i (range len)])
             (bit-vector-set! v0 i (bit-vector-ref data i)))
           v0)]
        [else (fill-disk (dragon-curve data) len)]))

(module+ test
  (require rackunit)
  
  (check-equal? (dragon-curve (string->bit-vector "1"))
                (string->bit-vector "100"))
  (check-equal? (dragon-curve (string->bit-vector "0"))
                (string->bit-vector "001"))
  (check-equal? (dragon-curve (string->bit-vector "11111"))
                (string->bit-vector "11111000000"))
  (check-equal? (dragon-curve (string->bit-vector "111100001010"))
                (string->bit-vector "1111000010100101011110000"))
  
  (check-equal? (checksum (string->bit-vector "110010110100"))
                (string->bit-vector "100"))
  
  (check-equal? (fill-disk (string->bit-vector "10000") 20)
                (string->bit-vector "10000011110010000111"))
  
  (check-equal? (checksum (fill-disk (string->bit-vector "10000") 20))
                (string->bit-vector "01100"))
  )

(module+ main
  (define init (string-trim (read-line)))
  (define len (read))
  (displayln
   (bit-vector->string
    (checksum (fill-disk (string->bit-vector init) len)))))
