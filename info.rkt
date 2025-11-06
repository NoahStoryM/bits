#lang info

(define license 'MIT)
(define collection "bits")
(define version "0.0")

(define pkg-desc "Treat a byte vector as a bit matrix with a width of 8")

(define deps
  '("base"
    "typed-racket-lib"))
(define build-deps
  '("at-exp-lib"
    "scribble-lib"
    "rackunit-typed"
    "racket-doc"
    "typed-racket-doc"))

(define scribblings '(("scribblings/bits.scrbl")))

(define clean '("compiled" "private/compiled"))
(define test-omit-paths '(#px"^((?!/tests/).)*$"))
