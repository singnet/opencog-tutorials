;patternMatcher test
(use-modules (ice-9 textual-ports))
(use-modules (opencog))
(use-modules (opencog query))
(use-modules (opencog exec))

; Three types - Command with Expected output(R), Expected Output (M), Command with no output expected (N) 
; In matcherTests.txt (the file to be tested) avoid having comment lines mixed in with the command itself 
; for example the type as in the arrwoed versions will be problematic
; (define colornode
;	(GetLink		;Declare varibales [optional]      <---
;		(VariableNode "$color") ; The pattern that the variable must satisfy <---
;		(InheritanceLink
;			(VariableNode "$color")
;			(ConceptNode "Color")
;		)
;	)
;)

;(empty lines and lines containing just comments are fine / will be ignored) 


(define (test-func)
	(call-with-input-file "PLNBackward.txt"
		(lambda (port)
			(define num-rules 0)
			(define num-statments 0)
			(define num-expected 0)
			(define num-errors 0)
			(define prev-type #\m)
			(define prev-line "")
			(define command)
			(define response)
			(define expected)
			(define rule-atom '())

			(while #t
				(let ((line (get-line port)) (type "") (res '()))
					(if (eof-object? line) (break))
					(set! line (string-trim line))
				    
				    (display (format #f "-> ~a\n"line))
                     
                    ; for empty lines in the file
				    (if (string-null? line)
				    	(continue))

                    (set! type (string-ref line 0))
                    

                    ; for empty lines in the file
				    (if (equal? type #\;)
				    	(continue))

				    (if (char-lower-case? prev-type)
				    	(begin
                    	    (set! prev-type type)
                    	    (set! line (string-trim (substring line 1)))
   							(set! prev-line line)
    						(display "prev-type was empty, is now set.\n")	
    						(continue)
				    	)
				    )

                    (cond
						((equal? type #\R)
							(begin
						     (set! line (string-trim (substring line 1)))		
							;execute prev-line
					        	(cond
							    	((equal? prev-type #\R)
								    	(begin
										
										; Delete previous rule
										  (if (not (null? prev-line))
										   	(set! command prev-line)
										  )
										 
									    	(set! response (eval-string prev-line)) 
								    		(set! num-rules (+ num-rules 1))
									    )
								    )

								    ((equal? prev-type #\M)  ; expected response
								    	(begin
								    		
									        (set! num-expected (+ num-expected 1))
							                (set! expected (eval-string prev-line)) ;???

									       (if (not (equal? expected response))
									         (begin
									           (set! num-errors (+ num-errors 1))
									           (display 
									           (format 
								                #f "ERROR: Result failed to expected\n EXPECTED: ~a\n FOUND: ~a\n"
									            response prev-line))
									         ) 
									       )
									    )
								    )

									((equal? prev-type #\N)  ; just execute!
										(begin
									    	(set! num-statments (+ num-statments 1))
									    	(eval-string prev-line)
										)
									)
								

									(#t (begin
										  (display "Error in test file format \n")
										  (break)
										)
									)
								) 
							
							 (set! prev-line line)
							 (set! prev-type type)

							)
						)

						((equal? type #\M)  ; expected response
							(begin
								(set! line (string-trim (substring line 1)))
							;execute prev-line
					        	(cond
							    	((equal? prev-type #\R)
								    	(begin
										
										; Delete previous rule
										  (if (not (null? prev-line))
										   	(set! command prev-line)
										  )
										 
									    	(set! response (eval-string prev-line)) 
								    		(set! num-rules (+ num-rules 1))
									    )
								    )

								    ((equal? prev-type #\M)  ; expected response
								    	(begin
									        (set! num-expected (+ num-expected 1))
							                (set! expected (eval-string prev-line)) ;???

									       (if (not (equal? expected response))
									         (begin
									           (set! num-errors (+ num-errors 1))
									           (display 
									           (format 
								                #f "ERROR: Result failed to expected\n EXPECTED: ~a\n FOUND: ~a\n"
									            response prev-line))
									         ) 
									       )
									    )
								    )

									((equal? prev-type #\N)  ; just execute!
										(begin
									    	(set! num-statments (+ num-statments 1))
									    	(eval-string prev-line)
										)
									)
								

									(#t (begin
										  (display "Error in test file format \n")
										  (break)
										)
									)
								) 
							
							 (set! prev-line line)
							 (set! prev-type type)

							)
						)

						((equal? type #\N)  ; just execute!
							(begin
								(set! line (string-trim (substring line 1)))
							;execute prev-line
					        	(cond
							    	((equal? prev-type #\R)
								    	(begin
										
										; Delete previous rule
										  (if (not (null? prev-line))
										   	(set! command prev-line)
										  )
										 
									    	(set! response (eval-string prev-line)) 
								    		(set! num-rules (+ num-rules 1))
									    )
								    )

								    ((equal? prev-type #\M)  ; expected response
								    	(begin
									        (set! num-expected (+ num-expected 1))
							                (set! expected (eval-string prev-line)) ;???

									       (if (not (equal? expected response))
									         (begin
									           (set! num-errors (+ num-errors 1))
									           (display 
									           (format 
								                #f "ERROR: Result failed to expected\n EXPECTED: ~a\n FOUND: ~a\n"
									            response prev-line))
									         ) 
									       )
									    )
								    )

									((equal? prev-type #\N)  ; just execute!
										(begin
									    	(set! num-statments (+ num-statments 1))
									    	(display "executed without expecting")
									    	(eval-string prev-line)
										)
									)
								

									(#t (begin
										  (display "Error in test file format \n")
										  (break)
										)
									)
								) 
							
							 (set! prev-line line)
							 (set! prev-type type)

							)
						)
						

						(#t (begin
							  (set! prev-line (string-join (list prev-line line)))
							  (display "attached to earlier command \n")
							  (display prev-type)
							)
						)
	                )  
                     
			 	)    
            )
		(display (format #f "\n\nRULES CHECKED: ~a\n" num-rules))
		(display (format #f "UNCHECKED STATMENTS: ~a\n" num-statments))
		(display (format #f "ERRORS: ~a\n" (/ num-errors (if (zero? num-expected) 1 num-expected))))
	)
))



(test-func)