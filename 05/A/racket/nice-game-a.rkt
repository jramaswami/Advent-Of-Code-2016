#lang racket

(require openssl/md5)

(define (find-password input)
  (define (helper0 n acc)
    (if (= (length acc) 8)
           (apply string-append (reverse acc))
           (let ([p (md5 (open-input-string
                          (string-append input (number->string n))))])
             (if (string-prefix? p "00000")
                 (helper0 (add1 n) (cons (substring p 5 6) acc))
                 (helper0 (add1 n) acc)))))
  (helper0 0 '()))