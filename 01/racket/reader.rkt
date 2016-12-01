#lang br/quicklang
(require "parser.rkt")
(require brag/support)

(define (read-syntax path port)
  (define parse-tree (parse path (tokenize port)))
  (define module-datum `(module advent-01 "expander.rkt"
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)

(require parser-tools/lex)
(define (tokenize port)
  (define (next-token)
    (define our-lexer
      (lexer
       [(eof) eof]
       [(char-set "RL") lexeme]
       [(repetition 1 +inf.0 numeric) (token 'NUMERIC-TOKEN lexeme)]
       [any-char (next-token)]))
    (our-lexer port))
  next-token)
                       