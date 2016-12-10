#lang br

(module+ reader
  (provide read-syntax)
  (define (read-syntax path port)
    (define balance-bot-datums (parse port))
    (strip-bindings
     #`(module balance-bots-mod balance-bots/a
         #,@balance-bot-datums))))

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
     ["bot" (let ([bot-number (number-tokenizer port)])
              `(give ,(string->symbol (format "bot~a" bot-number)) ,bot-number ,(bot-tokenizer port) ,(bot-tokenizer port)))]
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

(provide #%module-begin)
(provide #%datum)
(provide #%app)
(provide #%top-interaction)

(require racket/function)

(define-macro (compare A B)
  #'((curry do-compare) A B))

(define-macro (value V B)
  #'((curry do-value) V B))

(define-macro (give ID B L H)
  #`(define (ID env)
      (let* ([bot-slots (environment-bot-slots env)]
             [giving-slots (hash-ref bot-slots B)]
             [lo (first giving-slots)]
             [hi (second giving-slots)]
             [comparison (environment-comparison env)]
             [prev-comparing-bot (environment-comparing-bot env)]
             [new-comparing-bot (if (equal? comparison giving-slots)
                                    B
                                    prev-comparing-bot)]
             [new-bot-slots (hash-set! bot-slots B (list 0 0))]
             [new-env (environment new-bot-slots comparison new-comparing-bot)])
        (do-value hi H (do-value lo L (new-env))))))

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
         [slots (hash-ref bot-slots b (list 0 0))]
         [new-slots (add-to-slot slots v)])
    (begin
      (hash-set! bot-slots b new-slots)
      (if (foldl (λ (x y) (and x y)) #t (map (λ (x) (> x 0)) slots))
          ((eval (string->symbol (format "bot~a" b))) (environment bot-slots comparison comparing-bot))
          (environment bot-slots comparison comparing-bot)))))