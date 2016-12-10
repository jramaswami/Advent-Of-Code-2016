#lang br

(module+ reader
  (provide read-syntax)
  (define (read-syntax path port)
    (define balance-bot-datums (parse port))
    (strip-bindings
     #`(module balance-bots-mod balance-bots/a
         (balance-bots-instructions
          #,@balance-bot-datums)))))

;; TOKENIZER
(require parser-tools/lex)
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
     ["value" `(value ,(number-tokenizer port) ,(bot-tokenizer port))]
     ["bot" `(give ,(number-tokenizer port) ,(bot-tokenizer port) ,(bot-tokenizer port))]
     ["compare" `(compare ,(number-tokenizer port) ,(number-tokenizer port))]
     [any-char (next-token port)]))
  (lxr port))

(define (bot-tokenizer port)
  (define lxr
    (lexer
     ["bot" (number-tokenizer port)]
     ["output" (* -1 (number-tokenizer port))]
     [any-char (bot-tokenizer port)]))
  (lxr port))

(define (number-tokenizer port)
  (define lxr
    (lexer 
     [(repetition 1 +inf.0 numeric) (string->number lexeme)]
     [any-char (number-tokenizer port)]))
  (lxr port))

;; EXPANDER
(define-macro (balance-bots-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [balance-bots-module-begin #%module-begin]))

(provide #%datum)
(provide #%app)
(provide #%top-interaction)

(define-macro (balance-bots-instructions INSTRUCTIONS ...)
  #'(fold-funcs (list INSTRUCTIONS ...)))
(provide balance-bots-instructions)

(define (fold-funcs instructions)
  (let ([final-env (for/fold ([env (environment (make-hash) (list 0 0) +inf.0)])
                    ([i instructions])
                     (apply i (list env)))])
    (fprintf (current-output-port) "The bot that compared ~a was bot ~a.\n"
             (environment-comparison final-env)
             (environment-comparing-bot final-env))))

(require racket/function)
(define-macro (compare A B)
  #'((curry do-compare) A B))

(define-macro (value V B)
  #'((curry do-value) V B))

(define-macro (give B L H)
  #'((curry do-give) B L H))
(provide compare value give)

;; PROGRAM LOGIC
(struct environment (bot-slots comparison comparing-bot) #:transparent)

(define (add-to-slot slot value)
  (cdr (sort (cons value slot) <)))

(define (do-compare a b env)
  (environment (environment-bot-slots env)
               (sort (list a b) <)
               (environment-comparing-bot env)))

(define (do-value v b env)
  (let* ([bot-slots (environment-bot-slots env)]
         [comparison (environment-comparison env)]
         [comparing-bot (environment-comparing-bot env)]
         [slot (hash-ref bot-slots b (list 0 0))])
    (begin
      (hash-set! bot-slots b (add-to-slot slot v))
      (environment bot-slots comparison comparing-bot))))

(define (do-give b l h env)
  (let* ([bot-slots (environment-bot-slots env)]
         [compare (environment-comparison env)]
         [comparing-bot (environment-comparing-bot env)]
         [giving-slot (hash-ref bot-slots b)]
         [lo-slot (hash-ref bot-slots l (list 0 0))]
         [hi-slot (hash-ref bot-slots h (list 0 0))]
         [lo-value (first giving-slot)]
         [hi-value (second giving-slot)]
         [new-comparing-bot (if (equal? compare giving-slot)
                                b
                                comparing-bot)])
    (begin
      (fprintf (current-output-port) "$ ~a :: ~a ~a\n" compare b giving-slot)
      (hash-set! bot-slots l (add-to-slot lo-slot lo-value))
      (hash-set! bot-slots h (add-to-slot hi-slot hi-value))
      (environment bot-slots
                   compare
                   new-comparing-bot))))