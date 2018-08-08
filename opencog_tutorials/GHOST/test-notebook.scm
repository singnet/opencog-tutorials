;;; Testing code for checking integrity of the notebook

; The tests to be checked need to be listed in tests.txt in the following format
; 1. Every line must start with R, M or N corresponding to a rule, a matching input and a not-matching input
; 2. After the above symbol a space (or any number of space) is required before writing rules or inputs
; 3. Every rule must have the label "lbl" for internal use
; 4. Every rule must have ^keep function for testing the same rule with mulitple inputs

(use-modules (ice-9 textual-ports))

(use-modules (opencog)
             (opencog nlp)
             (opencog nlp relex2logic)
             (opencog openpsi)
             (opencog ghost)
             (opencog ghost procedures))


(define (test-func)
	(call-with-input-file "tests.txt"
		(lambda (port)
			(define num-rules 0)
			(define num-checks 0)
			(define num-errors 0)
			(define rule "")
			(define rule-atom '())

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
						(set! rule-atom (ghost-get-rule "lbl"))
						(if (not (null? rule-atom))
							(cog-delete-recursive rule-atom))
						
						(ghost-parse line) 
						(set! num-rules (+ num-rules 1))
						(set! rule line)
						))
					((equal? type #\M)
						(begin
						(set! num-checks (+ num-checks 1))
						(set! res (test-ghost line))

						(if (null? res)
						  (begin
						   (set! num-errors (+ num-errors 1))
						   (display 
						    (format 
					              #f "ERROR: Input failed to match rule\n RULE: ~a\n INPUT: ~a\n"
						      rule line))
						  )
						)
						))
					((equal? type #\N)
						(begin
						(set! num-checks (+ num-checks 1))
						(set! res (test-ghost line))

						(if (not (null? res))
						  (begin
						   (set! num-errors (+ num-errors 1))
						   (display 
						    (format 
					              #f "ERROR: Input matched rule\n RULE: ~a\n INPUT: ~a\n"
						      rule line))
						   )
						)

						))
					(#t (begin
						(display "Error in test file format \n")
						(break)
						))

					)
				)
			)

		(display (format #f "\n\nRULES CHECKED: ~a\n" num-rules))
		(display (format #f "TOTAL CHECKS: ~a\n" num-checks))
		(display (format #f "ERRORS: ~a\n" (/ num-errors (if (zero? num-checks) 1 num-checks))))
		)

	)
)


(test-func)
