(define-module (muddle repl)
  #:use-module (ice-9 rdelim)
  #:use-module (muddle players)
  #:export (mudl))

(define (mudl port)
  (define user #f)
  (while #t 
    (display "Username: " port)
    (let ((name (string-filter char-alphabetic? (read-line port))))
      (if (player? name)
	  (begin
	    (display "That name already exists. Is it you? " port)
	    (if (string-ci=? (string-filter char-alphabetic? (read-line port)) "yes")
		(begin
		  (display "Password: " port)
		  (if (password=? name (string-delete char-whitespace? (read-line port)))
		      (begin 
			(set! user name)
			(break))
		      (begin
			(display "Incorrect password." port)
			(newline port)
			(continue))))
		(continue)))
	  (begin
	    (display "Password: " port)
	    (make-player name (make-password (string-delete char-whitespace? (read-line port))))
	    (set! user name)
	    (break)))))
  (format port "Welcome ~A!" user)
  (newline port))
