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

(define (align-discs ds)
  (define (helper0 t ds0)
    ;    (fprintf (current-output-port) "t=~a " t)
    (if (empty? ds0)
        t
        (let* ([d (car ds0)]
               [id (disc-id d)]
               [start (disc-start d)]
               [pos (disc-positions d)])
          ;           (fprintf (current-output-port) "(modulo (+ ~a ~a) ~a) = ~a\n"
          ;                    id start pos (modulo (+ id start) pos))
          (if (= (modulo t pos) (modulo (+ id start) pos))
              (helper0 t (cdr ds0))
              (helper0 (add1 t) ds)))))
  (helper0 0 ds))

(module+ test
  (require rackunit)
  (define d1 (disc 1 5 4))
  (define d2 (disc 2 2 1)))

(module+ main
  (define inp (input-lexer (current-input-port)))
  (displayln inp)
  (displayln (align-discs inp)))