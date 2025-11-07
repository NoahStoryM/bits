#lang scribble/manual

@(require (for-label typed/racket/base bits)
          "utils.rkt")

@title{Bits}
@defmodule[bits #:packages ("bits")]
@author[@author+email["Noah Ma" "noahstorym@gmail.com"]]

@section{Overview}

This library provides utilities for treating Racket @tech/refer{byte string} as
a @deftech{bit matrix} with a width of 8, allowing for direct, two-dimensional
access or modification of individual bits.

@section{Bit Type}

@deftype[Bit]{
A type representing a single bit, defined as @racket[(∪ Zero One)].
}

@defproc[(bit? [v Any]) Boolean]{
Returns @racket[#t] if @racket[v] is @racket[0] or @racket[1], @racket[#f] otherwise.

@bits-examples[
(:print-type bit?)
]
}

@defproc[(one? [v Any]) Boolean]{
Returns @racket[#t] if @racket[v] is @racket[1], @racket[#f] otherwise.

@bits-examples[
(:print-type one?)
]
}

@section{Bit Matrix Operations}

@defproc[(bits-ref [bs Bytes] [i Integer] [j Integer]) Bit]{
Gets the bit at row @racket[i] and column @racket[j] from @racket[bs].

@bits-examples[
(define bs #"\x55")
(bits-ref bs 0 0)
(bits-ref bs 0 1)
]
}

@defproc[(bits-set! [bs Bytes] [i Integer] [j Integer] [bit Bit]) Void]{
Sets the bit at row @racket[i] and column @racket[j] in @racket[bs] to @racket[bit].

@bits-examples[
(define bs (bytes 0))
(bits-set! bs 0 7 1)
bs
(bits-set! bs 0 7 0)
bs
]
}

@section{Type Conversions}

@defproc[(bit->boolean [bit Bit]) Boolean]{
Convert a bit to a boolean.
}

@defproc[(boolean->bit [bool Boolean]) Bit]{
Convert a boolean to a bit.
}
