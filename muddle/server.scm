(define-module (muddle server)
  #:use-module (muddle repl)
  #:use-module (ice-9 threads)
  #:export (run-server))

(define* (run-server #:key (port 4000))
  (let ((s (socket PF_INET SOCK_STREAM 0)))
    (setsockopt s SOL_SOCKET SO_REUSEADDR 1)
    (bind s AF_INET INADDR_ANY port)
    (listen s 5)
    
    (format #t "Listening on port ~S." port)
    (newline)
    
    (while #t
      (let* ((client-connection (accept s))
	     (client-details (cdr client-connection))
	     (client (car client-connection))
	     )
	(format #t "Accepted connection: ~S" client-details)
	(newline)
	(format #t "Client address: ~S" (gethostbyaddr
						(sockaddr:addr client-details)))
	(newline)
	(mudl client)
	(close client)))))
