;;; Testing code for checking integrity of the notebook

; The tests to be checked need to be listed in tests.txt in the following format (For the time being)
; 1. Every line must start with D, R, M or N corresponding to a definition, a rule, a matching input and a non-matching input
; 2. After the above symbol a space (or any number of spaces) is required before writing rules or inputs
; 3. Every rule must have the label "lbl" for internal use
; 4. Every rule must have ^keep function for testing the same rule with mulitple inputs

; The way the test is done is as follows:
; - Every rule is first isolated when being tested (Previous rules are deleted from the atomspace to avoid interference)
; - One exception for the above is for definitions. Topic, goal and concept definitions
;   persist throughout the test
; - Then a rule is checked for syntax correctness
; - Then every matching and non-matching inputs are tested against the rule
; - Definitions are only tested for syntax correctness
; - The final error statistics is then displayed.
; - In the future more features will be added such as use of functions
;   and detailed analysis of the output

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
			(define num-defs 0)
			(define num-rules 0)
			(define num-checks 0)
			(define num-errors 0)
			(define rule "")
			(define rule-atom '())

			(while #t
				(let ((line (get-line port)) (type "") (res '()))
					(if (eof-object? line) (break))
					(set! line (string-trim line))
					(if (string-null? line) (continue))
					(display (format #f "-> ~a\n"line))

					(set! type (string-ref line 0))
					(set! line (string-trim (substring line 1)))
					
					(cond

					((equal? type #\#)
					 (continue)
					)
					
					((equal? type #\D)
					(begin
					(set! num-defs (+ num-defs 1))
					(set! num-checks (+ num-checks 1))

					(catch #t 
						(lambda ()	
						(ghost-parse line)
						)
						(lambda (key . args)
						(set! num-errors (+ num-errors 1)) 
						(display
						(format 
					              #f "\nERROR: Syntax Error\n DEFINITION: ~a\n\n"
						      line))

						)
						)
					)
					)
					((equal? type #\R)
						(begin
						; Delete previous rule
						(set! rule-atom (ghost-get-rule "lbl"))
						(if (not (null? rule-atom))
							(cog-delete-recursive rule-atom))

						(set! num-rules (+ num-rules 1))
						(set! num-checks (+ num-checks 1))
						(set! rule line)

					
						(catch #t 
						(lambda ()	
						(ghost-parse line)
						)
						(lambda (key . args)
						(set! num-errors (+ num-errors 1)) 
						(display
						(format 
					              #f "\nERROR: Syntax Error\n RULE: ~a\n\n"
						      rule))

						)
						) 
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
					              #f "\nERROR: Input failed to match rule\n RULE: ~a\n INPUT: ~a\n\n"
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
					              #f "\nERROR: Input matched rule\n RULE: ~a\n INPUT: ~a\n\n"
						      rule line))
						   )
						)

						))
					(#t (begin
						(display "\nError in test file format \n\n")
						(break)
						))

					)
				)
			)

		(display (format #f "\n\nDEFINITIONS CHECKED (for syntax error): ~a\n" num-defs))
		(display (format #f "RULES CHECKED (for syntax error): ~a\n" num-rules))
		(display (format #f "INPUTS CHECKED (for correct matching): ~a\n" (- num-checks (+ num-defs num-rules))))
		(display (format #f "TOTAL CHECKS: ~a\n" num-checks))
		(display (format #f "ERRORS: ~a/~a\n" num-errors num-checks))
		)

	)
)

(include "test-functions.scm")
(test-func)
