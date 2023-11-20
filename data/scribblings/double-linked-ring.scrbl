
#lang scribble/manual

@(require scribble/eval
          (for-label racket
                     data/double-linked-ring))

@; eval for examples
@(define base-eval (make-base-eval))
@interaction-eval[#:eval base-eval (require data/double-linked-ring)]


@title{Double Linked Ring}
@author{@(author+email "Matteo d'Addio" "matteo.daddio@live.it")}
@defmodule[data/double-linked-ring]

A double linked ring data structure.
A ring has no beginning or end, it only has
a current element.


@; predicate
@defproc[(ring? [buff any/c]) boolean?]{
 Determines if @racket[buff] is a ring buffer.
}

@; constructor
@defproc[(ring [a-list '() list?]) ring?]{
 Create a ring from a list. If the list isn't specified
 an empty ring is created. The current element of the ring
 is set to the first element of the list. 
}

@defproc[(ring->list [a-ring ring?]) list?]{
 Creates a list of the element in the ring starting from
 the current one.
}

@examples[
 #:eval base-eval
 (define the-ring (ring '(a b c d)))
 (ring->list the-ring)
 ]

@defproc[(ring-size [a-ring ring?]) exact-nonnegative-integer?]{
 Returns the number of elements of the ring.
}

@defproc[(ring-current [a-ring ring?]) any/c]{
 Returns the current element of the ring. If the ring is
 empty an exception is raised.
}

@examples[
 #:eval base-eval
 (define the-ring (ring))
 (ring-size the-ring)
 (ring-current the-ring)

 
 (define the-ring (ring '(a b c d)))
 (ring-size the-ring)
 (ring-current the-ring)
 ]

@defproc[(ring-next! [a-ring ring?]) any/c]{
 Returns the next element of the ring and sets the current
 element to this element. If the ring is empty an exception
 is raised.
}

@defproc[(ring-prev! [a-ring ring?]) any/c]{
 Returns the previous element of the ring and sets the current
 element to this element. If the ring is empty an exception
 is raised.
}

@examples[
 #:eval base-eval
 (define the-ring (ring '(a b c d)))
 (ring-current the-ring)
 (ring-next! the-ring)
 (ring-current the-ring)
 (ring->list the-ring)
 (ring-prev! the-ring)
 (ring-prev! the-ring)
 (ring-current the-ring)
 (ring->list the-ring)
 ]

@defproc[(ring-remove-current! [a-ring ring?]) void?]{
 Removes the current element of the ring and sets the current
 element to the next element. If the ring is empty an exception
 is raised.
}

@defproc[(ring-set-current! [a-ring ring?] [elem any/c]) void?]{
 Sets the current element to @racket[elem] with @racket[set!].
 If the ring is empty an exception is raised.
}

@examples[
 #:eval base-eval
 (define the-ring (ring '(a b c d)))
 (ring-set-current! the-ring 'A)
 (ring->list the-ring)
 (ring-remove-current! the-ring)
 (ring->list the-ring)
 ]

@defproc[(ring-add-next! [a-ring ring?] [elem any/c]) void?]{
 Adds a new @racket[elem] after the current one and sets the new
 @racket[elem] as current.
}

@defproc[(ring-add-prev! [a-ring ring?] [elem any/c]) void?]{
 Adds a new @racket[elem] before the current one and sets the new
 @racket[elem] as current.
}

@examples[
 #:eval base-eval
 (define the-ring (ring '(a b c d)))
 (ring-add-prev! the-ring 1)
 (ring-add-prev! the-ring 2)
 (ring-add-prev! the-ring 3)
 (ring->list the-ring)
 (set! the-ring (ring '(a b c d)))
 (ring-add-next! the-ring 1)
 (ring-add-next! the-ring 2)
 (ring-add-next! the-ring 3)
 (ring->list the-ring)
 ]

The procedure @racket[ring->list] can be quite confusing.
I use it mainly fo debugging purposes.
