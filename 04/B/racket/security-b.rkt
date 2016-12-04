#lang racket
(require parser-tools/lex)

(define room-lexer
  (lexer
   [(repetition 1 +inf.0
                (concatenation (repetition 1 +inf.0 alphabetic) #\-))
    (cons lexeme (room-lexer input-port))]
   [(repetition 1 +inf.0 numeric)
    (cons lexeme (room-lexer input-port))]
   [(concatenation #\[ (repetition 1 +inf.0 alphabetic) #\])
    (cons lexeme '())]))

(define (read-room)
  (let ([r (read-line)])
    (if (eof-object? r)
        #f
        (room-lexer (open-input-string  r)))))

(define (read-input)
  (define (read-loop rm acc)
    (if rm
        (read-loop (read-room) (cons rm acc))
        acc))
  (read-loop (read-room) '()))

(define (checksum room-id)
  (apply string
         (map car
              (take
               (groups (string->list (string-replace room-id "-" "")))
               5))))

(define (groups ss)
  (define (helper0 xs acc)
    (cond [(empty? xs)
           (sort acc (lambda (u v) (cond [(> (cdr u) (cdr v)) #t]
                                         [(= (cdr u) (cdr v)) (char<? (car u) (car v))]
                                         [else #f])))]
          [(assoc (car xs) acc) (helper0 (cdr xs) acc)]
          [else (let* ([x (car xs)]
                       [ys (filter (lambda (y) (equal? x y)) xs)])
                  (helper0 (cdr xs) (cons (cons x (length ys)) acc)))]))
  (helper0 ss '()))

(define (valid-room room)
  (let* ([room-name (first room)]
         [room-id (second room)]
         [x (last room)]
         [room-checksum (substring x 1 (sub1 (string-length x)))])
    (if (equal? (checksum room-name) room-checksum)
        #t
        #f)))

(define (decrypt room)
  (let ([room-name (first room)]
        [room-id (string->number (second room))])
    (define (decode-char c)
      (if (equal? c #\-)
          #\space
          (let ([k (+ (char->integer c) (modulo room-id 26))])
            (if (< k 123)
                (integer->char k)
                (integer->char (- k 26))))))
    (cons (list->string (map decode-char (string->list room-name))) room-id)))

(module+ main
  (displayln (cdar(filter (lambda (x) (equal? (car x) "northpole object storage "))
                     (map decrypt (filter valid-room (read-input)))))))