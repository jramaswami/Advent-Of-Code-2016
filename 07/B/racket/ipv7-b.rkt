#lang racket
(require parser-tools/lex)

(struct supernet-sequence (value) #:transparent)
(struct hypernet-sequence (value) #:transparent)

(define (get-abas-and-babs s)
  (let ([limit (- (string-length s) 2)])
    (define (helper0 i acc)
      (if (= i limit)
          acc
          (if (and (not (equal? (string-ref s i) (string-ref s (+ i 1))))
                   (equal? (string-ref s i) (string-ref s (+ i 2))))
              (helper0 (add1 i) (set-add acc (substring s i (+ i 3))))
              (helper0 (add1 i) acc))))
    (helper0 0 (set))))

(define (aba->bab s)
  (list->string (list (string-ref s 1) (string-ref s 0) (string-ref s 1))))

(define (supports-ssl? ips)
  (define (helper0 xs supernet-abas hypernet-babs)
    (if (empty? xs)
        (not (set-empty? (set-intersect (list->set (set-map supernet-abas aba->bab)) hypernet-babs)))
        (let ([x (car xs)])
          (if (supernet-sequence? x)
              (helper0 (cdr xs)
                       (set-union supernet-abas (get-abas-and-babs (supernet-sequence-value x)))
                       hypernet-babs)
              (helper0 (cdr xs)
                       supernet-abas
                       (set-union hypernet-babs (get-abas-and-babs (hypernet-sequence-value x))))))))
(helper0 ips (set) (set)))

(define ip-lexer
  (lexer
   [(concatenation #\[ (repetition 1 +inf.0 alphabetic) #\])
    (cons (hypernet-sequence (substring lexeme 1 (sub1 (string-length lexeme)))) (ip-lexer input-port))]
   [(repetition 1 +inf.0 alphabetic)
    (cons (supernet-sequence lexeme) (ip-lexer input-port))]
   [#\newline '()] 
   [(eof) '()]))

(module+ test
  (require rackunit)
  (check-equal? (get-abas-and-babs "aba") (set "aba"))
  (check-equal? (get-abas-and-babs "zazbz") (set "zbz" "zaz"))
  (check-true (supports-ssl? (ip-lexer (open-input-string "aba[bab]xyz"))))
  (check-false (supports-ssl? (ip-lexer (open-input-string "xyx[xyx]xyx"))))
  (check-true (supports-ssl? (ip-lexer (open-input-string "aaa[kek]eke"))))
  (check-true (supports-ssl? (ip-lexer (open-input-string "zazbz[bzb]cdb"))))
  )

(module+ main
  (define (read-loop acc)
    (let ([line (read-line)])
      (if (eof-object? line)
          (fprintf (current-output-port) "There are ~a that support ssl.\n" acc)
          (let ([ip (ip-lexer (open-input-string line))])
            (if (supports-ssl? ip)
                (begin
                  (fprintf (current-output-port) "ssl OK: ~a\n" line)
                  (read-loop (add1 acc)))
                (begin
                  (fprintf (current-output-port) "no ssl: ~a\n" line)
                  (read-loop acc)))))))
  (read-loop 0))