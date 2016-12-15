#lang racket

(require parser-tools/lex)

(struct disc (id positions start) #:transparent)

(define (lexed-list->disc lst)
  (disc (first lst) (second lst) (last lst)))

(define disc-lexer
  (lexer
   [(repetition 1 +inf.0 numeric)
    (cons (string->number lexeme) (disc-lexer input-port))]
   [#\newline '()]
   [any-char (disc-lexer input-port)]
   [(eof) '()]))

(define input-lexer
  (lexer
   [(eof) '()]
   [any-char (cons (lexed-list->disc (disc-lexer input-port)) (input-lexer input-port))]))

(define (position-disc drop-t d)
  (modulo (+ (disc-start d) drop-t (disc-id d)) (disc-positions d)))

(define (align-discs ds)
  (define (helper0 t)
    (if (= 0 (foldl + 0 (map (λ (d) (position-disc t d)) ds)))
        t
        (helper0 (add1 t))))
  (helper0 0))

(module+ main
  (define inp (input-lexer (current-input-port)))
  (displayln (align-discs inp)))