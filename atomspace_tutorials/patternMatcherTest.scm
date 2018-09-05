;patternMatcher test
(use-modules (ice-9 textual-ports))
(use-modules (opencog))
(use-modules (opencog query))
(use-modules (opencog exec))

(display "begun")

; Three types - Command with Expected output(R), Expected Output (M), Command with no output expected (N) 
; 

(define (test-func)
	(call-with-input-file "matcherTests.txt"
		(lambda (port)
			(define num-rules 0)
			(define num-statments 0)
			(define num-expected 0)
			(define num-errors 0)
			(define command)
			(define response)
			(define expected)
			(define rule-atom '())
            
            (display "called!")  

			(while #t
				(let ((line (get-line port)) (type "") (res '()))
					(if (eof-object? line) (break))
					(set! line (string-trim line))
				
					(display (format #f "-> ~a\n"line))

					(set! type (string-ref line 0))
					(set! line (string-trim (substring line 1)))

					(cond
					((equal? type #\R)
						(begin
						; Delete previous rule
						(if (not (null? line))
							(set! command line))
						 
						(set! response (eval-string line)) 
						(set! num-rules (+ num-rules 1))
						))

					((equal? type #\M)  ; expected response
						(begin
						(set! num-expected (+ num-expected 1))
                        (set! expected (eval-string line)) ;???

						(if (not (equal? expected response))
						  (begin
						   (set! num-errors (+ num-errors 1))
						   (display 
						    (format 
					              #f "ERROR: Result failed to expected\n EXPECTED: ~a\n FOUND: ~a\n"
						      response line))
						  )
						)
						))

					((equal? type #\N)  ; just execute!
						(begin
						(set! num-statments (+ num-statments 1))
						(eval-string line)
						(display "done it")
						))

					(#t (begin
						(display "Error in test file format \n")
						(break)
						))

					)
				)
			)

		(display (format #f "\n\nRULES CHECKED: ~a\n" num-rules))
		(display (format #f "UNCHECKED STATMENTS: ~a\n" num-statments))
		(display (format #f "ERRORS: ~a\n" (/ num-errors (if (zero? num-expected) 1 num-expected))))
		)

	)
)


(test-func)