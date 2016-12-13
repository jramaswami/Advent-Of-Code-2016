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
  (define (helper0 bot-acc com-acc res-acc)
    (let ([token (next-token port)])
      (cond [(eof-object? token) (append (reverse bot-acc) (reverse com-acc) (list res-acc))]
            [(equal? (car token) 'give) (helper0 bot-acc (cons token com-acc) res-acc)]
            [(equal? (car token) 'show-compare) (let ([lo-chip (second token)]
                                                      [hi-chip (third token)])
                                                  (helper0 bot-acc
                                                           (cons `(compare ,lo-chip ,hi-chip) com-acc)
                                                           token))]
            [else (helper0 (cons token bot-acc) com-acc res-acc)])))
  (helper0 '() '() #f))

(define (next-token port)
  (define lxr
    (lexer
     [(eof) eof]
     ["value" `(give ,(number-tokenizer port) ,(bot-tokenizer port))]
     ["bot" `(bot-rule ,(number-tokenizer port) ,(bot-tokenizer port) ,(bot-tokenizer port))]
     ["show-compare" `(show-compare ,(number-tokenizer port) ,(number-tokenizer port))]
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

(provide balance-bots-instructions compare give bot-rule show-compare)
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

(define-macro (show-compare A B)
  #'((curry do-show-compare) A B))

(define (fold-funcs instructions)
  (void (for/fold ([env (environment (make-hash)      ;; slots
                                     (make-hash)      ;; rules
                                     (list -1 -1)     ;; comparison
                                     (make-queue))])  ;; bfs queue
                  ([instruction (in-list instructions)])
          (apply instruction (list env)))))

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

(define (do-show-compare a b env)
  (let ([all-bot-slots (environment-bot-slots (bfs env))])
    (define (find-bot bots)
      (if (equal? (hash-ref all-bot-slots (car bots)) (list a b))
          (fprintf (current-output-port)
                   "Bot ~a compared ~a and ~a."
                   (car bots) a b)
          (find-bot (cdr bots))))
    (find-bot (hash-keys all-bot-slots))))

(define (bfs env)
  (if (empty? (environment-queue env))
      env
      (let* ([hd (dequeue! (environment-queue env))]
             [all-slots (environment-bot-slots env)]
             [hd-slots (hash-ref all-slots hd)])
        (if (equal? hd-slots (environment-comparison env))
            env
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
