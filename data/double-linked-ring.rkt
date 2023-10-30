
#lang racket/base

(require racket/contract)

(provide (contract-out
          [ring (->* ()((listof any/c)) ring?)]
          [ring? (-> any/c boolean?)]
         
          [ring-size (-> ring? exact-nonnegative-integer?)]
          [ring-current (-> ring? any/c)]
         
          [ring-next! (-> ring? any/c)]
          [ring-prev! (-> ring? any/c)]
         
          [ring-remove-current! (-> ring? void?)]
          [ring-set-current! (-> ring? any/c void?)]
         
          [ring-add-next! (-> ring? any/c void?)]
          [ring-add-prev! (-> ring? any/c void?)]

          [ring->list (-> ring? (listof any/c))]))


(struct node (data [next #:auto]
                   [prev #:auto])
  #:mutable #:auto-value '())

(struct ring-struct (current-node size) #:mutable)


;;; Helper function
(define (connect prev-node new-node next-node)
  (set-node-next! prev-node new-node)
  (set-node-prev! next-node new-node)
    
  (set-node-next! new-node next-node)
  (set-node-prev! new-node prev-node))


;;; Helper function
(define (remove the-node)
  (set-node-next! (node-prev the-node) (node-next the-node))
  (set-node-prev! (node-next the-node) (node-prev the-node)))


(define (ring-size the-ring)
  (ring-struct-size the-ring))

  
(define (ring-current the-ring)
  (define current-node (ring-struct-current-node the-ring))
  (if (equal? current-node #f)
      (error 'ring-current "the ring is empty")
      (node-data current-node)))


(define (ring-next! the-ring)
  (define current-node (ring-struct-current-node the-ring))
  (define prev-node (node-prev current-node))
  (cond [(equal? current-node #f)
         (error 'ring-next! "the ring is empty")]
        [else
         (set-ring-struct-current-node! the-ring prev-node)
         (node-data prev-node)]))


(define (ring-prev! the-ring)
  (define current-node (ring-struct-current-node the-ring))
  (define next-node (node-next current-node))
  (cond [(equal? current-node #f)
         (error 'ring-prev! "the ring is empty")]
        [else
         (set-ring-struct-current-node! the-ring next-node)
         (node-data next-node)]))


(define (ring-remove-current! the-ring)
  (define current-node (ring-struct-current-node the-ring))
  (define size (ring-struct-size the-ring))
  (cond
    [(equal? size 0)
     (error 'ring-remove-current! "the ring is empty")]
      
    [(equal? size 1)
     (set-ring-struct-current-node! the-ring #f)
     (set-ring-struct-size! the-ring 0)]
      
    [(> size 1)
     (remove current-node)
     (set-ring-struct-current-node! the-ring (node-prev current-node))
     (set-ring-struct-size! the-ring (- size 1))]))


(define (ring-set-current! the-ring new-data)
  (define current-node (ring-struct-current-node the-ring))
  (cond [(equal? current-node #f)
         (error 'ring-set-current! "the ring is empty")]
        [else
         (set-node-data! current-node new-data)]))
  
  
(define (ring-add-next! the-ring new-data)
  (define current-node (ring-struct-current-node the-ring))
  (define size (ring-struct-size the-ring))
  (define new-node (node new-data))
  
  (cond
    [(equal? size 0)
     (connect new-node new-node new-node)
     (set-ring-struct-current-node! the-ring new-node)
     (set-ring-struct-size! the-ring 1)]
      
    [(equal? size 1)
     (connect current-node new-node current-node)
     (set-ring-struct-current-node! the-ring new-node)
     (set-ring-struct-size! the-ring 2)]
      
    [(> size 1)
     (connect (node-prev current-node) new-node current-node)
     (set-ring-struct-current-node! the-ring new-node)
     (set-ring-struct-size! the-ring (+ size 1))]))


(define (ring-add-prev! the-ring new-data)
  (define current-node (ring-struct-current-node the-ring))
  (define size (ring-struct-size the-ring))
  (define new-node (node new-data))
  (cond
    [(equal? size 0)
     (connect new-node new-node new-node)
     (set-ring-struct-current-node! the-ring new-node)
     (set-ring-struct-size! the-ring 1)]
      
    [(equal? size 1)
     (connect current-node new-node current-node)
     (set-ring-struct-current-node! the-ring new-node)
     (set-ring-struct-size! the-ring 2)]
      
    [(> size 1)
     (connect current-node new-node (node-next current-node))
     (set-ring-struct-current-node! the-ring new-node)
     (set-ring-struct-size! the-ring (+ size 1))]))


(define (ring->list the-ring)
  (define curr-node (ring-struct-current-node the-ring))
  (for/list ([i (in-range (ring-size the-ring))])
    (begin0
      (node-data curr-node)
      (set! curr-node (node-prev curr-node)))))


(define (ring [init-list '()])
  (define the-ring (ring-struct #f 0))
  (for-each (lambda (elem) (ring-add-next! the-ring elem)) init-list)
  (when (> (ring-size the-ring) 0)
    (ring-next! the-ring))
  the-ring) ;return the new ring


(define (ring? the-ring) (ring-struct? the-ring))
