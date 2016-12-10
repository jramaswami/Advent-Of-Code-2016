#lang br/quicklang

(require parser-tools/lex)
(require parser-tools/lex-sre)
(require brag/support)

(define (read-syntax path port)
  (define datalink-datums (parse port))
  (strip-bindings
   #`(module datalink-mod "expander.rkt"
       (datalink-instr
       #,@datalink-datums))))
(provide read-syntax)

(define (parse port)
  (define (helper0 acc)
    (let ([token (next-token port)])
      (if (eof-object? token)
          (reverse acc)
          (helper0 (cons token acc)))))
  (helper0 '()))

(define (next-token port)
  (define lxr
    (lexer
     [(eof) eof]
     [(+ upper-case) `(shift ,lexeme)]
     ["(" (let* ([len (number-lexer port)]
                 [rep (number-lexer port)]
                 [str (begin
                        ;; Skip the closing ")" of the expansion instruction.
                        (file-position port (add1 (file-position port)))
                        ;; Grab the string to be expanded.
                        (parse (open-input-string (expandee-lexer port len ""))))])
            (fprintf (current-output-port) "@ ~a" str)
            `(expand ,rep ,str))]
     [any-char (next-token port)]))
  (lxr port))

(define (number-lexer port)
  (define lxr
    (lexer
     [(+ numeric) (string->number lexeme)]
     [any-char (number-lexer port)]))
  (lxr port))

(define (expandee-lexer port len acc)
  (if (equal? len 0)
      acc
      (let ([lxr
             (lexer
              [(~ whitespace) (expandee-lexer port (sub1 len) (string-append acc lexeme))]
              [(+ whitespace) (expandee-lexer port len acc)])])
        (lxr port))))