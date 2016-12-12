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
  (define (helper0 bot-acc com-acc)
    (let ([token (next-token port)])
      (cond [(eof-object? token) (append (reverse bot-acc) (reverse com-acc))]
            [(equal? (car token) 'give) (helper0 bot-acc (cons token com-acc))]
            [else (helper0 (cons token bot-acc) com-acc)])))
  (helper0 '() '()))

(define (next-token port)
  (define lxr
    (lexer
     [(eof) eof]
     ["value" `(give ,(number-tokenizer port) ,(bot-tokenizer port))]
     ["bot" `(bot-rule ,(number-tokenizer port) ,(bot-tokenizer port) ,(bot-tokenizer port))]
     ["compare" `(compare ,(number-tokenizer port) ,(number-tokenizer port))]
     [any-char (next-token port)]))
  (lxr port))

(define (bot-tokenizer port)
  (define lxr
    (lexer
     ["bot" (number-tokenizer port)]
     ["output" (+ 1000 (number-tokenizer port))]
     [any-char (bot-tokenizer port)]))
  (lxr port))

(define (number-tokenizer port)
  (define lxr
    (lexer 
     [(repetition 1 +inf.0 numeric) (string->number lexeme)]
     [any-char (number-tokenizer port)]))
  (lxr port))

;; EXPANDER
(require data/queue)

(define-macro (bb-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [bb-module-begin #%module-begin]))

(provide balance-bots-instructions compare give bot-rule)
(provide #%app #%datum #%top-interaction)

(define-macro (balance-bots-instructions INSTRUCTIONS ...)
  #'(begin
      (void (fold-funcs (list INSTRUCTIONS ...)))))

(require racket/function)

(define-macro (compare A B)
  #'((curry do-compare) A B))

(define-macro (give V B)
  #'((curry do-give) V B))

(define-macro (bot-rule B L H)
  #'((curry do-bot-rule) B L H))

(define (fold-funcs instructions)
  (let ([final-env (for/fold ([env (environment (make-hash)
                                                (make-hash)
                                                (list 0 0)
                                                (make-queue))])
                             ([instruction (in-list instructions)])
                     (apply instruction (list env)))])
    (fprintf (current-output-port) "~a\n" (bfs final-env))))

;; LOGIC


(struct environment (bot-slots bot-rules comparison queue) #:transparent)

(define (add-to-slots slots value)
  (cdr (sort (cons value slots) <)))

(define (do-compare a b env)
  (environment (environment-bot-slots env)
               (environment-bot-rules env)
               (sort (list a b) <)
               (environment-queue env)))

(define (do-give v b env)
  (let* ([bot-slots (environment-bot-slots env)]
         [slots (hash-ref bot-slots b (list 0 0))]
         [new-slots (add-to-slots slots v)])
    (begin
      (hash-set! bot-slots b new-slots)
      (when (and (< b 1000) (> (first new-slots) 0) (> (second new-slots) 0))
        (enqueue! (environment-queue env) b))
      (environment bot-slots
                   (environment-bot-rules env)
                   (environment-comparison env)
                   (environment-queue env)))))

(define (do-bot-rule b l h env)
  (let ([all-bot-rules (environment-bot-rules env)])
    (hash-set! all-bot-rules  b (list l h))
    (environment (environment-bot-slots env)
                 all-bot-rules
                 (environment-comparison env)
                 (environment-queue env))))

(define (bfs env)
  (if (empty? (environment-queue env))
      +inf.0
      (let* ([hd (dequeue! (environment-queue env))]
             [all-slots (environment-bot-slots env)]
             [hd-slots (hash-ref all-slots hd)])
        (if (equal? hd-slots (environment-comparison env))
            hd
            (let* ([all-rules (environment-bot-rules env)]
                   [hd-rules (hash-ref all-rules hd)]
                   [lo-node (first hd-rules)]
                   [hi-node (second hd-rules)]
                   [lo-val (first hd-slots)]
                   [hi-val (second hd-slots)])
              (bfs (do-give hi-val hi-node (do-give lo-val
                                                    lo-node
                                                    (environment (environment-bot-slots env)
                                                                 (environment-bot-rules env)
                                                                 (environment-comparison env)
                                                                 (environment-queue env))))))))))
  