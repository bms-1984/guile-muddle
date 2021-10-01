(define-module (muddle players)
  #:use-module (srfi srfi-1)
  #:export (make-player
	    make-password
	    players
	    player?
	    age
	    gender
	    password=?))

(define playerlist-file "./playerlist.scm")

(define playerlist (if (access? playerlist-file (logior R_OK W_OK))
		       (call-with-input-file playerlist-file read)
		       (begin (call-with-output-file playerlist-file (lambda (port)
								       (write '() port)))
			      '())))

(define (players) playerlist)

(define (write-playerlist)
  (if (access? playerlist-file W_OK)
      (call-with-output-file playerlist-file (lambda (port)
						  (write playerlist port)))))

(define (make-player name password)
  (set! playerlist (append playerlist (list (list name password))))
  (write-playerlist))

(define (player? name) (find (lambda (x) (string=? (car x) name)) playerlist))

(define (make-password pass)
  (crypt pass (salt)))

(define (password=? name pass)
  (when (player? name) 
    (if (string=? (crypt pass (second (player? name))) (second (player? name)))
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
