#lang br/quicklang

(define-macro (screen-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [screen-module-begin #%module-begin]))

(define-macro (screen-program INSTR ...)
  #'(begin
      (void (fold-funcs (list INSTR ...)))))
(provide screen-program)

(define (fold-funcs screen-instr)
  (let ([final-screen (for/fold ([M #f])
                                ([instr (in-list screen-instr)])
                        (apply instr (list M)))])
    (displayln (screen->string final-screen))
    (fprintf (current-output-port) "There are ~a pixels on.\n" (count-pixels-on? final-screen))))

(require racket/function)
(define-macro (screen-decl #f W H)
  #'((curry make-screen) W H))
(provide screen-decl)

(define-macro (rect #f R C)
  #'((curry do-rect) R C))
(provide rect)

(define-macro (rotate-row #f R D)
  #'((curry do-row-rot) R D))
(provide rotate-row)

(define-macro (rotate-col #f C D)
  #'((curry do-col-rot) C D))
(provide rotate-col)

(define (screen->string screen)
  (for/fold ([s ""])
            ([row screen])
    (let ([row-string (for/fold ([t ""])
                                ([col row])
                        (if (= col 1)
                            (string-append t "#")
                            (string-append t ".")))])
      (string-append s row-string "\n"))))

(define (make-screen width height [ignore #f])
  (let ([rows (make-vector height)])
    (for ([r (range height)])
      (vector-set! rows r (make-vector width 0)))
    rows))

(define (pixel-on r c M)
  (let ([row (vector-ref M r)])
    (vector-set! row c 1)))

(define (pixel-off r c M)
  (let ([row (vector-ref M r)])
    (vector-set! row c 0)))

(define (pixel-value? r c M)
  (let ([row (vector-ref M r)])
    (vector-ref row c)))

(define (count-pixels-on? M)
  (for/fold ([total 0])
            ([row M])
    (let ([subtotal (for/fold ([st 0])
                              ([col row])
                      (if (= col 1)
                          (add1 st)
                          st))])
      (+ total subtotal))))

(define (do-rect w h M)
  (for* ([r (range h)]
         [c (range w)])
    (pixel-on r c M))
  M)

(define (do-col-rot c d M)
  (let* ([h (vector-length M)]
         [t (make-vector h -1)])
    (for ([r (range h)])
      (vector-set! t r (pixel-value? r c M)))
    (for ([r (range h)])
      (let ([r1 (modulo (+ r d) h)])
        (if (= 0 (vector-ref t r))
            (pixel-off r1 c M)
            (pixel-on r1 c M)))))
  M)

(define (do-row-rot r d M)
  (let* ([w (vector-length (vector-ref M 0))]
         [t (make-vector w -1)])
    (for ([c (range w)])
      (vector-set! t c (pixel-value? r c M)))
    (for ([c (range w)])
      (let ([c1 (modulo (+ c d) w)])
        (if (= 0 (vector-ref t c))
            (pixel-off r c1 M)
            (pixel-on r c1 M)))))
  M)

(module+ test
  (require rackunit)
  (check-equal? (screen->string (do-rect 3 2 (make-screen 7 3))) "###....\n###....\n.......\n")
  (check-equal? (screen->string (do-col-rot 1 1
                                            (do-rect 3 2
                                                     (make-screen 7 3))))
                "#.#....\n###....\n.#.....\n")
  (check-equal? (screen->string (do-row-rot 0 4
                                            (do-col-rot 1 1
                                                        (do-rect 3 2
                                                                 (make-screen 7 3)))))
                "....#.#\n###....\n.#.....\n")
  (check-equal? (screen->string (do-row-rot 0 5
                                            (do-col-rot 1 1
                                                        (do-rect 3 2
                                                                 (make-screen 7 3)))))
                "#....#.\n###....\n.#.....\n")
  (check-equal? (count-pixels-on? (do-rect 3 2 (make-screen 7 3))) 6)
  (check-equal? (count-pixels-on? (do-col-rot 1 1
                                              (do-rect 3 2
                                                       (make-screen 7 3))))
                6)
  (check-equal? (count-pixels-on? (do-row-rot 0 4
                                              (do-col-rot 1 1
                                                          (do-rect 3 2
                                                                   (make-screen 7 3)))))
                6)
  (check-equal? (count-pixels-on? (do-row-rot 0 5
                                              (do-col-rot 1 1
                                                          (do-rect 3 2
                                                                   (make-screen 7 3)))))
                6)
  (check-equal? (count-pixels-on? (do-rect 2 3
                                           (do-row-rot 0 4
                                                       (do-col-rot 1 1
                                                                   (do-rect 3 2
                                                                            (make-screen 7 3))))))
                9)
  )