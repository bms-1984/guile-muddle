;; Copyright 2021 Ben M. Sutter

;; This file is part of Muddle.

;; Muddle is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; Muddle is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Muddle.  If not, see <https://www.gnu.org/licenses/>.

(define-module (muddle server)
  #:use-module (muddle repl)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 threads)
  #:export (run-server
	    clients
	    client?))

(define clientlist '())

(define (clients) clientlist)

(define (client? port) (find (lambda (x) (equal? (car x) port)) clientlist))

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
	     (client (car client-connection)))
	(format #t "Accepted connection: ~S" client-details)
	(newline)
	(format #t "Client address: ~S" (gethostbyaddr
					 (sockaddr:addr client-details)))
	(newline)
	(set! clientlist (append clientlist `(,client-connection)))
	(begin-thread (with-input-from-port client mudl))))))
