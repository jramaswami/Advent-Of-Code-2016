#lang racket

(require openssl/md5)

(define (find-password input)
  (let ([v (make-vector 8 "")])
    (define (helper0 n acc)
      (if (= acc 8)
          (for/fold ([pwd ""])
                    ([c v])
            (string-append pwd c))
          (let ([p (md5 (open-input-string
                         (string-append input (number->string n))))])
            (if (string-prefix? p "00000")
                (let ([i (string->number (substring p 5 6) 16)])
                  (if (and (< i 8) (equal? (vector-ref v i) ""))
                      (begin
                        (vector-set! v i (substring p 6 7))
                        (fprintf (current-output-port) "~a\n" v)
                        (helper0 (add1 n) (add1 acc)))
                      (helper0 (add1 n) acc)))
                (helper0 (add1 n) acc)))))
    (helper0 0 0)))