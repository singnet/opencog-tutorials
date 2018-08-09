(define-public (findkiller)
  ; ... the process of finding the killer ...
  ; The answer should be a list of nodes wrapped in a ListLink
  (List (Word "Bob") (Word "and") (Word "Alice")))

(define-public (smile)
               (display "I am smiling")
               (List (Word "")))

(define-public (random-stv)
               (if (= (random 2) 1)
                   (stv 1 1)
                   (stv 0 1)
                )
)

(define-public (is-happy argWord)
               (define thresh (string->number (cog-name argWord)))
               (if (>= (/ (random 10) 10) thresh)
                   (stv 1 1)
                   (stv 0 1)
                )
)
