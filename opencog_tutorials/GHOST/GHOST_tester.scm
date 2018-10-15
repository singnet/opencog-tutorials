;;; Testing code for checking integrity of the notebook ;;;

; The tests to be checked need to be listed in tests.txt in the following format.
; 1. Every line must start with  R corresponding to an expression with expected output,
;                                M corresponding to an expected output for the expression defined in an immediate previous line with R,
;                                N corresponding to an expression with no expected output.
; 2. After the above symbol, a space (or any number of space) is required before writing rules or expression.
; 3. Expression with multiple lines is allowed
; 4. Comment lines are allowed
; 5. Lines with comments along side an expression are not allowed.
;    for example:
;                 (define animal "dog") ; variable definition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-modules (ice-9 textual-ports))
(use-modules (texinfo string-utils))
(use-modules (srfi srfi-64))

(define (test-func)
	(call-with-input-file "tests.txt"
		(lambda (port)
			(define failed_exp "Execution failed expressions ID:")
			(define passed_Texp "Test passed expressions ID:")
			(define failed_Texp "Test failed expressions ID:")
			(define expression_no 0)
      (define num-R 0)
      (define num-fR 0)
      (define num-N 0)
      (define num-fN 0)
      (define num-skpln 0)
			(define rule "")
			(define rule-atom '())
      (define expected "")
      (define temp-line "")

			(while #t
				(let ((line (get-line port)) (type "") (res '()))
					(if (eof-object? line) (break))
					(set! line (string-trim line))

          ; escape empty lines in the file
          (if (string-null? line)
            (continue)
          )

          (set! type (string-ref line 0))
          ; escape comment lines in the file
          (if (equal? type #\;)
            (continue)
          )

					(set! line (string-trim (substring line 1)))

          ; take care of multiple line command or expected value as a single entity
          ;(if (not-equal? type #\M or #\N or #\R) (begin (set! line (string-join (list line temp-line))) (continue)) (set! line temp-line) )

          (set! temp-line (get-line port))
          (if (not (eof-object? temp-line))
            (begin
              (set! temp-line (string-trim temp-line))
              ; for escaping empty lines by considering as comment line
              (if (string-null? temp-line)
                (set! temp-line (string #\;))
              )
              (if (and (not (equal? (string-ref temp-line 0) #\R)) (not (equal? (string-ref temp-line 0) #\M)) (not (equal? (string-ref temp-line 0) #\N)))
                (begin
                  (while (and (not (equal? (string-ref temp-line 0) #\R)) (not (equal? (string-ref temp-line 0) #\M)) (not (equal? (string-ref temp-line 0) #\N)))
                    ; escape comment lines in the file
                    (if (not (equal? (string-ref temp-line 0) #\;))
                      (set! line (string-join (list line temp-line)))
                    )

                    (set! temp-line (get-line port))
                    (if (eof-object? temp-line) (break))
                    (set! temp-line (string-trim temp-line))
                    ; for escaping empty lines by considering as comment line
                    (if (string-null? temp-line)
                      (set! temp-line (string #\;))
                    )
                  )
                  (if (not (eof-object? temp-line)) (unread-string (string-append temp-line (string #\lf)) port)) ;return the reading point one line back.
                )
                (if (not (eof-object? temp-line)) (unread-string (string-append temp-line (string #\lf)) port));return the reading point one line back.
              )
            )
          )

					(set! expression_no (+ expression_no 1))
          (display (format #f "-> ~a\n" (string-join (list (object->string expression_no) (string type) line))))
					(cond
					((equal? type #\R)
						(begin
						(set! num-R (+ num-R 1))

            ;;; CHECK FOR EXPECTED OUTPUT
            ; check if the next line begins with M and if it does compare the output of the line with R
            ; to this line and if it doesn't begin with M raise error and return the get-line position back again.

            (catch #t
              (lambda ()
                (set! expected (string-trim (get-line port)))
              )
              (lambda (key . args)
                (display "\nERROR: Error in test file format \n       Skipped current line...\n")
                (set! expected "non")
              )
            )

            (if (equal? (string-ref expected 0) #\M)
                (begin
                  (set! temp-line (get-line port))
                  ; for escaping empty lines by considering as comment line
                  (if (string-null? temp-line)
                    (set! temp-line (string #\;))
                  )
                  (if (not (eof-object? temp-line))
                    (begin
                      (set! temp-line (string-trim temp-line))
                      (if (and (not (equal? (string-ref temp-line 0) #\R)) (not (equal? (string-ref temp-line 0) #\M)) (not (equal? (string-ref temp-line 0) #\N)))
                        (begin
                          (while (and (not (equal? (string-ref temp-line 0) #\R)) (not (equal? (string-ref temp-line 0) #\M)) (not (equal? (string-ref temp-line 0) #\N)))
                            ; escape comment lines in the file
                            (if (not (equal? (string-ref temp-line 0) #\;))
                              (set! expected (string-join (list expected temp-line)))
                            )
                            (set! temp-line (get-line port))
                            (if (eof-object? temp-line) (break))
                            (set! temp-line (string-trim temp-line))
                            ; for escaping empty lines by considering as comment line
                            (if (string-null? temp-line)
                              (set! temp-line (string #\;))
                            )
                          )
                          (if (not (eof-object? temp-line)) (unread-string (string-append temp-line (string #\lf)) port)) ;return the reading point one line back.
                        )
                        (if (not (eof-object? temp-line)) (unread-string (string-append temp-line (string #\lf)) port));return the reading point one line back.
                      )
                    )
                  )

                  (catch #t
                    (lambda ()
                      (set! expected (string-trim (substring expected 1)))
                      (test-equal (eval-string expected) (eval-string line)) ; "expected" is evaluated to obtain the actually expected list.
                      (display (eval-string expected))
                      (display "\n")
                      (display (center-string (string-upcase (object->string (test-result-kind ))) 24 #\< #\>))
											(if (equal? (string-upcase (object->string (test-result-kind ))) "PASS")
												(set! passed_Texp (string-join (list passed_Texp (object->string expression_no))))
												(set! failed_Texp (string-join (list failed_Texp (object->string expression_no))))
											)
                      (display "\n\n")
                    )
                    (lambda (key . args)
                      (display "\nERROR: possibly syntax error.\n")
                      (set! num-fR (+ num-fR 1))
											(set! failed_exp (string-join (list failed_exp ", " (object->string expression_no))))
                    )
                  )

                )
                (begin
                  (display "\nERROR: Missing Expected Statement\n")
                  (set! num-fR (+ num-fR 1))
									(set! failed_exp (string-join (list failed_exp ", " (object->string expression_no))))
                  (unread-string (string-append expected (string #\lf)) port) ;return the reading point one line back.
                )
            )
						)
          )

          ((equal? type #\M)
          (begin
						(display "\nERROR: Missing preceding Command with Expected output (R) statement \n       Skipped current line...\n")
						(set! num-skpln (+ num-skpln 1))
						)
          )

					((equal? type #\N) ; execute expressions like (define king "Minilik") which has no expected output.
						(begin
						(set! num-N (+ num-N 1))

            ;;;just execute the line and display it's execution response;;;
            (catch #t
              (lambda () (display (eval-string line)))
              (lambda (key . args)
                (display "\nERROR: possibly syntax error.\n")
                (set! num-fN (+ num-fN 1))
								(set! failed_exp (string-join (list failed_exp (object->string expression_no))))
              )
            )
            (display "\n\n")
						)
          )

					(#t (begin
						(display "\nERROR: Error in test file format \n       Skipped current line...\n")
            (set! num-skpln (+ num-skpln 1))
						)
          )

					)
				)
			)

    (display (format #f "\n\n# of total executions: ~a\n" (+ num-R num-N)))
    (display (format #f "# of failed executions: ~a\n" (+ num-fR num-fN)))
		(display (format #f "~a\n" failed_exp))
    (display (format #f "# of Skipped lines: ~a\n" num-skpln))
    (display (format #f "# of tested executions: ~a\n" (- num-R num-fR)))
		(display (format #f "~a\n" passed_Texp))
		(display (format #f "~a\n" failed_Texp))
		)
	)
)

(test-begin "on tests.txt")
(display "\n")
(test-func)
(test-end "on tests.txt")
