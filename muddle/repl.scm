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

(define (mudl)
  (set-current-output-port (current-input-port))
  (define user #f)
  (while #t
    (display "Username: ")
    (let ((name (read-line*)))
      (if (player? name)
	  (begin ; player exists
	    (display "That name already exists. Is it you? ")
	    (if (string-ci=? (read-line*) "yes")
		(begin ; user claims to be player
		  (display "Password: ")
		  (if (password=? name (read-line*))
		      (begin ; user is player
			(set! user name)
			(break))
		      (begin ; user is not player
			(display "Incorrect password.")
			(newline)
			(continue))))
		(continue)))
	  (begin ; creating a new player
	    (display "Password: ")
	    (make-player name (make-password (read-line*)))
	    (set! user name)
	    (break)))))
  (format #t "Welcome ~A!" user)
  (newline)
  (user-loop user)
  (close (current-input-port)))

(define (read-line*)
  (string-delete (char-set #\return #\newline #\linefeed) (read-line)))

(define (user-loop user)
  (while #t
    (format #t "~A > " user)
    (let ((line (read-line*)))
      (cond ((string-contains-ci line "quit") (break))))))
