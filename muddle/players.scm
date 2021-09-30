(define-module (muddle players)
  #:use-module (srfi srfi-1)
  #:export (create-player
	    player?
	    age
	    gender))

(define playerlist '())

(define* (create-player name #:key (age 18) (gender 'non-binary))
  (set! playerlist (append playerlist (list (list name age gender)))))

(define (player? name) (find (lambda (x) (string=? (car x) name)) playerlist))

(define (age name) (second (player? name)))

(define (gender name) (third (player? name)))
