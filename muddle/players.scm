(define-module (muddle players)
  #:use-module (srfi srfi-1)
  #:export (make-player
	    player?
	    age
	    gender
	    password=?))

(define playerlist (if (access? "./playerlist.scm" (logior R_OK W_OK))
		       (call-with-input-file "./playerlist.scm" read)
		       (begin (call-with-output-file "./playerlist.scm" (lambda (port)
								       (write '() port)))
			      '())))

(define (write-playerlist)
  (if (access? "./playerlist.scm" W_OK)
      (call-with-output-file "./playerlist.scm" (lambda (port)
						  (write playerlist port)))))

(define* (make-player name password #:key (age 18) (gender 'non-binary))
  (set! playerlist (append playerlist (list (list name password age gender))))
  (write-playerlist))

(define (player? name) (find (lambda (x) (string=? (car x) name)) playerlist))

(define (age name) (third (player? name)))

(define (gender name) (fourth (player? name)))

(define (password=? name)
  (when (player? name) 
    (if (string=? (crypt (getpass "Password:") (second (player? name))) (second (player? name)))
	#t
	#f)))

(define* (salt #:optional ending)
  (let* ((charset "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
	 (string-ending (string (string-ref charset (random (string-length charset))))))
    (if ending
	(if (= (string-length ending) 16)
	    (string-append "$6$" ending)
	    (salt (string-append ending string-ending)))
	(salt string-ending))))
