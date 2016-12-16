#lang racket

(define (flip-bits n)
    (let ([mask (- (arithmetic-shift 1 (integer-length n)) 1)])
      (bitwise-xor n mask)))

(define (reverse-bits n)
  (define (helper0 m x)
    (if (= m 0)
        x
        (let ([x0 (arithmetic-shift x 1)]
              [m0 (bitwise-and m 1)])
          (helper0 (arithmetic-shift m -1) (bitwise-ior x0 m0)))))
  (helper0 n 0))

(define (reverse-not n)
  (define (helper0 m x)
    (if (= m 0)
        x
        (let ([x0 (arithmetic-shift x 1)]
              [m0 (bitwise-and m 1)])
          (if (= m0 0)
              (helper0 (arithmetic-shift m -1) (bitwise-ior x0 1))
              (helper0 (arithmetic-shift m -1) (bitwise-ior x0 0))))))
  (helper0 n 0))

(define (dragon-curve xs)
  (append xs '(0) (reverse-not xs)))

(define (checksum xs)
  (define (helper0 xs0)
    (if (empty? xs0)
        '()
    (let ([a (first xs0)]
          [b (second xs0)])
      (if (equal? a b)
          (cons 1 (helper0 (drop xs0 2)))
          (cons 0 (helper0 (drop xs0 2)))))))
  (let ([cs (helper0 xs)])
    (if (odd? (length cs))
        cs
        (checksum cs))))

(define (fill-disk data len)
  (if (<= len (length data))
      (take data len)
      (fill-disk (dragon-curve data) len)))

;(module+ test1
;  (require rackunit)
;
;  (check-equal? (dragon-curve '(1)) '(1 0 0))
;  (check-equal? (dragon-curve '(0)) '(0 0 1))
;  (check-equal? (dragon-curve (bitstring->bitlist "11111"))
;                (bitstring->bitlist "11111000000"))
;  (check-equal? (dragon-curve (bitstring->bitlist "111100001010"))
;                (bitstring->bitlist "1111000010100101011110000"))
;
;  (check-equal? (checksum (bitstring->bitlist "110010110100"))
;                (bitstring->bitlist "100"))
;
;  (check-equal? (fill-disk (bitstring->bitlist "10000") 20)
;                (bitstring->bitlist "10000011110010000111"))
;
;  (check-equal? (checksum (fill-disk (bitstring->bitlist "10000") 20))
;                (bitstring->bitlist "01100")))
;
;(module+ main1
;  (define init (string-trim (read-line)))
;  (define len (read))
;  (displayln
;   (bitlist->bitstring
;    (checksum (fill-disk (bitstring->bitlist init) len)))))
