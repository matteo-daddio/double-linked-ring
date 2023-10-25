
#lang info

(define collection 'multi)
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("data/double-linked-ring-doc.scrbl" () ("Data Structures"))))
(define pkg-desc "Double Linked Ring")
(define version "1.0")
(define pkg-authors '(matteo-daddio))
(define license '(MIT))