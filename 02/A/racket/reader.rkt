#lang br/quicklang
(require "parser.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (tokenize port)))
  (define module-datum `(module advent-02-a "expander.rkt"
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)

(require brag/support)
(require parser-tools/lex)
(define (tokenize port)
  (define (next-token)
    (define our-lexer
      (lexer
       [(eof) eof]
       [(char-set "UDRL") lexeme]
       [(char-set "\n") (token 'NEWLINE-TOKEN lexeme)]
       [any-char (next-token)]))
    (our-lexer port))
  next-token)