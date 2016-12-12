#lang br

(module+ reader
  (provide read-syntax)
  (define (read-syntax path port)
    (define parse-tree (parse port))
    (define module-datums `(module balance-bots-mod balance-bots/a
                             (balance-bots-instructions
                              ,@parse-tree)))
    (datum->syntax #f module-datums)))

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
     ["value" `(give ,(number-tokenizer port) ,(bot-tokenizer port))]
     ["bot" `(bot-instruction ,(number-tokenizer port) ,(bot-tokenizer port) ,(bot-tokenizer port))]
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
(define-macro (bb-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [bb-module-begin #%module-begin]))

(provide balance-bots-instructions compare give bot-instruction)
(provide #%app #%datum #%top-interaction)

(define-macro (balance-bots-instructions INSTRUCTIONS ...)
  #'(begin
      (void (fold-funcs (list INSTRUCTIONS ...)))))

(require racket/function)

(define-macro (compare A B)
  #'((curry do-compare) A B))

(define-macro (give V B)
  #'((curry do-give) V B))

(define-macro (bot-instruction B L H)
  #'((curry do-bot-instruction) B L H))

(define (fold-funcs instructions)
  (let ([final-env (for/fold ([env (environment (make-hash)
                                                (make-hash)
                                                (list 0 0)
                                                +inf.0)])
                             ([instruction (in-list instructions)])
                     (apply instruction (list env)))])
    (fprintf (current-output-port)
             "The bot that compared ~a was ~a.\n"
             (environment-comparison final-env)
             (environment-comparison-bot final-env))))

;; LOGIC
(struct environment (bot-slots bot-instructions comparison comparison-bot) #:transparent)

(define (add-to-slots slots value)
  (cdr (sort (cons value slots) <)))

(define (do-compare a b env)
  (environment (environment-bot-slots env)
               (environment-bot-instructions env)
               (sort (list a b) <)
               (environment-comparison-bot env)))

(define (do-give v b env)
  (let* ([bot-slots (environment-bot-slots env)]
         [slots (hash-ref bot-slots b (list 0 0))]
         [new-slots (add-to-slots slots v)]
         [comparison (environment-comparison env)])
    (begin
      (hash-set! bot-slots b new-slots)
      (let ([new-env (environment bot-slots
                                  (environment-bot-instructions env)
                                  (environment-comparison env)
                                  (if (equal? comparison new-slots)
                                      b
                                      (environment-comparison-bot env)))])
        (fprintf (current-output-port) "@ ~a compares ~a ~a\n" b new-slots comparison)
        (if (and (> b 0) (foldl (λ (x y) (and x y)) #t (map (λ (x) (> x 0)) new-slots)))
            (let* ([bot-instructions (hash-ref (environment-bot-instructions env) b)]
                   [lo-bot (first bot-instructions)]
                   [hi-bot (second bot-instructions)])
              (fprintf (current-output-port) "% ~a gives ~a to ~a and ~a to ~a\n" b
                       (first new-slots) lo-bot (second new-slots) hi-bot)
              (do-give (second new-slots) hi-bot (do-give (first new-slots) lo-bot new-env)))
            new-env)))))

(define (do-bot-instruction b l h env)
  (let ([all-bot-instructions (environment-bot-instructions env)])
    (hash-set! all-bot-instructions  b (list l h))
    (environment (environment-bot-slots env)
                 all-bot-instructions
                 (environment-comparison env)
                 (environment-comparison-bot env))))