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

(define-module (muddle repl)
  #:use-module (ice-9 rdelim)
  #:use-module (muddle players)
  #:use-module (muddle server)
  #:export (mudl))

(define (mudl port)
  (define user #f)
  (while #t 
    (display "Username: " port)
    (let ((name (string-filter char-alphabetic? (read-line port))))
      (if (player? name) 
	  (begin ; player exists
	    (display "That name already exists. Is it you? " port)
	    (if (string-ci=? (string-filter char-alphabetic? (read-line port)) "yes")
		(begin ; user claims to be player
		  (display "Password: " port)
		  (if (password=? name (string-delete char-whitespace? (read-line port)))
		      (begin ; user is player
			(set! user name)
			(break))
		      (begin ; user is not player
			(display "Incorrect password." port)
			(newline port)
			(continue))))
		(continue)))
	  (begin ; creating a new player
	    (display "Password: " port)
	    (make-player name (make-password (string-delete char-whitespace? (read-line port))))
	    (set! user name)
	    (break)))))
  (format port "Welcome ~A!" user)
  (newline port)
  (user-loop user port)
  (close port))

(define (user-loop user port)
  (while #t
    (format port "~A > " user)
    (let ((line (string-delete (char-set #\return #\newline #\linefeed) (read-line port))))
      (cond ((string-contains-ci line "quit") (break))))))
