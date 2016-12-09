#lang br/quicklang

(require "parser.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (tokenize port)))
  (define module-datum `(module datalink "expander.rkt"
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)

(require parser-tools/lex)
(require parser-tools/lex-sre)
(require brag/support)
(define (tokenize port)
  (define (next-token)
    (define lxr
      (lexer
       [(eof) eof]
       [(+ upper-case) (token 'SHIFT-TOKEN lexeme)]
       ["(" (token 'EXPANSION-TOKEN)]
       [(+ numeric) (token 'NUMBER-TOKEN (string->number lexeme))] 
       [any-char (next-token)]))
    (lxr port))
  next-token)

