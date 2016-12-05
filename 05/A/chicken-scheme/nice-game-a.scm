(use message-digest md5 srfi-13)

(define (find-password input)
  (define (helper0 n acc)
    (if (= (length acc) 8)
	(apply string-append (reverse acc))
	(let ((p (message-digest-string
		  (md5-primitive)
		  (string-append input (number->string n)))))
	  (if (string-prefix? "00000" p)
	      (helper0 (+ n 1) (cons (substring p 5 6) acc))
	      (helper0 (+ n 1) acc)))))
  (helper0 0 '()))

(define (main)
  (let* ((input (string-trim (read-line)))
	 (pwd (find-password input)))
    (fprintf (current-output-port) "~S~N" pwd)))

(main)
