#lang br

(require "parser.rkt")
(define (read-syntax path port)
  (define parse-tree (parse path (tokenize port)))
  (define module-datum `(module screen-mod "expander.rkt"
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
       ["rect" (token 'RECT)]
       ["rotate row y=" (token 'ROTATE-ROW)]
       ["rotate column x=" (token 'ROTATE-COL)]
       ["screen" (token 'SCREEN-DECL)]
       [(+ numeric) (token 'NUMBER (string->number lexeme))]
       [any-char (next-token)]))
    (lxr port))
    next-token)