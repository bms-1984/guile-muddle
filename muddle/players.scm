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

(define-module (muddle players)
  #:use-module (srfi srfi-1)
  #:export (make-player
	    make-password
	    players
	    playerfile-path
	    player?
	    age
	    gender
	    password=?))

(define playerfile "./Playerfile")

(define playerlist (if (access? playerfile (logior R_OK W_OK))
		       (call-with-input-file playerfile read)
		       (begin (call-with-output-file playerfile (lambda (port)
								       (write '() port)))
			      '())))

(define (playerfile-path) (canonicalize-path playerfile))
(define (players) playerlist)

(define (write-playerfile)
  (if (access? playerfile W_OK)
      (call-with-output-file playerfile (lambda (port)
						  (write playerlist port)))))

(define (make-player name password)
  (set! playerlist (append playerlist `(,`(,name ,password))))
  (write-playerfile))

(define (player? name) (find (lambda (x) (string=? (car x) name)) playerlist))

(define (make-password pass)
  (crypt pass (salt)))

(define (password=? name pass)
  (when (player? name)  
    (string=? (crypt pass (second (player? name))) (second (player? name)))))

(define* (salt #:optional ending)
  (let* ((charset "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
	 (string-ending (string (string-ref charset (random (string-length charset))))))
    (if ending
	(if (= (string-length ending) 16)
	    (string-append "$6$" ending)
	    (salt (string-append ending string-ending)))
	(salt string-ending))))
