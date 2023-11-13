
#lang racket/base

(require "double-linked-ring.rkt")
(require rackunit)
(require rackunit/text-ui)
  
 
(define ring-tests
  (test-suite
   "ring tests"
    
   #:before (lambda () (display "----- ring tests started -----")(newline))
   #:after  (lambda () (display "----- end of tests -----")(newline))
    
   (test-case
    "testing the constructor"
    (define the-ring (ring))
    (check-equal? (ring-size the-ring) 0)
    (check-exn exn:fail? (lambda () (ring-current the-ring))) ;ring empty exception)
    (check-equal? (ring->list the-ring) '())
     
    (set! the-ring (ring '()))
    (check-true (ring? the-ring))
    (check-equal? (ring-size the-ring) 0)
    (check-exn exn:fail? (lambda () (ring-current the-ring))) ;ring empty exception)
    (check-equal? (ring->list the-ring) '())
     
    (set! the-ring (ring '(a)))
    (check-true (ring? the-ring))
    (check-equal? (ring-size the-ring) 1)
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring->list the-ring) '(a))
      
    (set! the-ring (ring '(a b)))
    (check-true (ring? the-ring))
    (check-equal? (ring-size the-ring) 2)
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring->list the-ring) '(a b))
      
    (set! the-ring (ring '(a b c)))
    (check-true (ring? the-ring))
    (check-equal? (ring-size the-ring) 3)
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring->list the-ring) '(a b c))
      
    (set! the-ring (ring '(a b c d)))
    (check-true (ring? the-ring))
    (check-equal? (ring-size the-ring) 4)
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring->list the-ring) '(a b c d))
  
    (display " -- ok constructor tests --")
    (newline))
  
   (test-case
    "testing ring?"
    (check-false (ring? 'not-a-ring))
    (check-true (ring? (ring)))
    (check-true (ring? (ring '())))
    (check-true (ring? (ring '(a))))
    (check-true (ring? (ring '(a b))))
      
    (display " -- ok ring? tests --")
    (newline))
     
   (test-case
    "testing next!"
    (define the-ring (ring))
    (check-exn exn:fail? (lambda () (ring-current the-ring))) ;ring empty exception
    (check-exn exn:fail? (lambda () (ring-next! the-ring))) ;ring empty exception
    (check-equal? (ring-size the-ring) 0)
   
    (set! the-ring (ring '(a b c d)))
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring->list the-ring) '(a b c d))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-next! the-ring) 'b)
    (check-equal? (ring-current the-ring) 'b)
    (check-equal? (ring->list the-ring) '(b c d a))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-next! the-ring) 'c)
    (check-equal? (ring-current the-ring) 'c)
    (check-equal? (ring->list the-ring) '(c d a b))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-next! the-ring) 'd)
    (check-equal? (ring-current the-ring) 'd)
    (check-equal? (ring->list the-ring) '(d a b c))
   
    (check-equal? (ring-next! the-ring) 'a)
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring->list the-ring) '(a b c d))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-next! the-ring) 'b)
    (check-equal? (ring-current the-ring) 'b)
    (check-equal? (ring->list the-ring) '(b c d a))
    (check-equal? (ring-size the-ring) 4)
    (display " -- ok next! tests --")
    (newline))

   (test-case
    "testing prev!"
    (define the-ring (ring))
    (check-exn exn:fail? (lambda () (ring-current the-ring))) ;ring empty exception
    (check-exn exn:fail? (lambda () (ring-prev! the-ring))) ;ring empty exception
    (check-equal? (ring-size the-ring) 0)
   
    (set! the-ring (ring '(a b c d)))
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring->list the-ring) '(a b c d))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-prev! the-ring) 'd)
    (check-equal? (ring-current the-ring) 'd)
    (check-equal? (ring->list the-ring) '(d a b c))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-prev! the-ring) 'c)
    (check-equal? (ring-current the-ring) 'c)
    (check-equal? (ring->list the-ring) '(c d a b))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-prev! the-ring) 'b)
    (check-equal? (ring-current the-ring) 'b)
    (check-equal? (ring->list the-ring) '(b c d a))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-prev! the-ring) 'a)
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring->list the-ring) '(a b c d))
    (check-equal? (ring-size the-ring) 4)
   
    (check-equal? (ring-prev! the-ring) 'd)
    (check-equal? (ring-current the-ring) 'd)
    (check-equal? (ring->list the-ring) '(d a b c))
    (check-equal? (ring-size the-ring) 4)
    (display " -- ok prev! tests --")
    (newline))

   (test-case
    "testing set-current!"
    (define the-ring (ring))
    (check-exn exn:fail? (lambda () (ring-set-current! the-ring))) ;ring empty exception
    (check-exn exn:fail? (lambda () (ring-current the-ring)))      ;ring empty exception
    (check-equal? (ring-size the-ring) 0)
   
    (set! the-ring (ring '(a b c d)))
    (ring-set-current! the-ring 'A)
    (check-equal? (ring-current the-ring) 'A)
    (check-equal? (ring->list the-ring) '(A b c d))
    (check-equal? (ring-size the-ring) 4)
   
    (ring-next! the-ring)
    (ring-set-current! the-ring 'B)
    (check-equal? (ring-current the-ring) 'B)
    (check-equal? (ring->list the-ring) '(B c d A))
    (check-equal? (ring-size the-ring) 4)
   
    (ring-next! the-ring)
    (ring-set-current! the-ring 'C)
    (check-equal? (ring-current the-ring) 'C)
    (check-equal? (ring->list the-ring) '(C d A B))
    (check-equal? (ring-size the-ring) 4)
   
    (ring-next! the-ring)
    (ring-set-current! the-ring 'D)
    (check-equal? (ring-current the-ring) 'D)
    (check-equal? (ring->list the-ring) '(D A B C))
    (check-equal? (ring-size the-ring) 4)
    (display " -- ok set-current! tests --")
    (newline))
  
   (test-case
    "testing remove-current!"
    (define the-ring (ring))
    (check-exn exn:fail? (lambda () (ring-remove-current! the-ring))) ;ring empty exception
    (check-exn exn:fail? (lambda () (ring-current the-ring))) ;ring empty exception
    (check-equal? (ring-size the-ring) 0)
   
    (set! the-ring (ring '(a b c)))
    (ring-remove-current! the-ring)
    (check-equal? (ring->list the-ring) '(b c))
    (check-equal? (ring-current the-ring) 'b)
    (check-equal? (ring-size the-ring) 2)

    (ring-remove-current! the-ring)
    (check-equal? (ring->list the-ring) '(c))
    (check-equal? (ring-current the-ring) 'c)
    (check-equal? (ring-size the-ring) 1)
   
    (ring-remove-current! the-ring)
    (check-equal? (ring->list the-ring) '())
    (check-exn exn:fail? (lambda () (ring-current the-ring))) ;ring empty exception
    (check-equal? (ring-size the-ring) 0)
   
    (check-exn exn:fail? (lambda () (ring-remove-current! the-ring))) ;ring empty exception
    (check-equal? (ring-size the-ring) 0)
    (display " -- ok remove-current! tests --")
    (newline))

   (test-case
    "testing add-next!"
    (define the-ring (ring))
    (ring-add-next! the-ring 'a)
    (check-equal? (ring->list the-ring) '(a))
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring-size the-ring) 1)
   
    (ring-add-next! the-ring 'b)
    (check-equal? (ring->list the-ring) '(b a))
    (check-equal? (ring-current the-ring) 'b)
    (check-equal? (ring-size the-ring) 2)
   
    (ring-add-next! the-ring 'c)
    (check-equal? (ring->list the-ring) '(c a b))
    (check-equal? (ring-current the-ring) 'c)
    (check-equal? (ring-size the-ring) 3)
   
    (ring-add-next! the-ring 'd)
    (check-equal? (ring->list the-ring) '(d a b c))
    (check-equal? (ring-current the-ring) 'd)
    (check-equal? (ring-size the-ring) 4)
    (display " -- ok add-next! tests --")
    (newline))
  
   (test-case
    "testing add-prev!"
    (define the-ring (ring))
    (ring-add-prev! the-ring 'a)
    (check-equal? (ring->list the-ring) '(a))
    (check-equal? (ring-current the-ring) 'a)
    (check-equal? (ring-size the-ring) 1)
   
    (ring-add-prev! the-ring 'b)
    (check-equal? (ring->list the-ring) '(b a))
    (check-equal? (ring-current the-ring) 'b)
    (check-equal? (ring-size the-ring) 2)
   
    (ring-add-prev! the-ring 'c)
    (check-equal? (ring->list the-ring) '(c b a))
    (check-equal? (ring-current the-ring) 'c)
    (check-equal? (ring-size the-ring) 3)
   
    (ring-add-prev! the-ring 'd)
    (check-equal? (ring->list the-ring) '(d c b a))
    (check-equal? (ring-current the-ring) 'd)
    (check-equal? (ring-size the-ring) 4)
    (display " -- ok add-prev! tests --")
    (newline))))
  
(run-tests ring-tests 'verbose)
