#lang br/quicklang
(require "parser.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (tokenize port)))
  (define module-datum `(module assembunny-mod "expander.rkt"
                          ,parse-tree))
  (datum->syntax #f module-datum)) 
(provide read-syntax)

(require parser-tools/lex)
(require brag/support)
(define (tokenize port)
  (define (next-token)
    (define lxr
      (lexer
       [(eof) eof]
       ["cpy" (token 'COPY)]
       ["inc" (token 'INC)]
       ["dec" (token 'DEC)]
       ["jnz" (token 'JNZ)]
       ["init" (token 'INIT)]
       ["a" (token 'REGISTER 0)]
       ["b" (token 'REGISTER 1)]
       ["c" (token 'REGISTER 2)]
       ["d" (token 'REGISTER 3)]
       [(concatenation (repetition 0 1 "-") (repetition 1 +inf.0 numeric))
        (token 'NUMBER (string->number lexeme))]
       [any-char (next-token)]))
    (lxr port))
  next-token)