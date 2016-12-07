#lang racket
(require parser-tools/lex)

(struct regular-sequence (value) #:transparent)
(struct hypernet-sequence (value) #:transparent)

(define (has-abba? s)
  (let ([limit (- (string-length s) 3)])
    (define (helper0 i)
      (if (= i limit)
          #f
          (if (and (not (equal? (string-ref s i) (string-ref s (+ i 1))))
                   (equal? (string-ref s i) (string-ref s (+ i 3)))
                   (equal? (string-ref s (+ i 1)) (string-ref s (+ i 2))))
              #t
              (helper0 (add1 i)))))
    (helper0 0)))

(define (valid-ip? ips)
  (define (helper0 xs acc)
    (if (empty? xs)
        acc
        (let ([x (car xs)])
          (if (regular-sequence? x)
              (helper0 (cdr xs) (or acc (has-abba? (regular-sequence-value x))))
              (if (has-abba? (hypernet-sequence-value x))
                  #f
                  (helper0 (cdr xs) acc))))))
  (helper0 ips #f))

(define ip-lexer
  (lexer
   [(concatenation #\[ (repetition 1 +inf.0 alphabetic) #\])
    (cons (hypernet-sequence (substring lexeme 1 (sub1 (string-length lexeme)))) (ip-lexer input-port))]
   [(repetition 1 +inf.0 alphabetic)
    (cons (regular-sequence lexeme) (ip-lexer input-port))]
   [#\newline '()] 
   [(eof) '()]))

(module+ test
  (require rackunit)
  (check-true (has-abba? "abba"))
  (check-false (has-abba? "qwer"))
  (check-false (has-abba? "aaaa"))
  (check-true (valid-ip? (ip-lexer (open-input-string "abba[mnop]qrst"))))
  (check-false (valid-ip? (ip-lexer (open-input-string "abcd[bddb]xyyx"))))
  (check-false (valid-ip? (ip-lexer (open-input-string "aaaa[qwer]tyui"))))
  (check-true (valid-ip? (ip-lexer (open-input-string "ioxxoj[asdfgh]zxcvbn"))))
  (check-false (valid-ip? (ip-lexer (open-input-string "zxcvbn[asdfgh]ioxxoj[abba]")))))

(module+ main
  (define (read-loop acc)
    (let ([line (read-line)])
      (if (eof-object? line)
          (fprintf (current-output-port) "There are ~a valid ips.\n" acc)
          (let ([ip (ip-lexer (open-input-string line))])
            (if (valid-ip? ip)
                (begin
                  (fprintf (current-output-port) "ok: ~a\n" line)
                  (read-loop (add1 acc)))
                (begin
                  (fprintf (current-output-port) "INVALID: ~a\n" line)
                  (read-loop acc)))))))
  (read-loop 0))