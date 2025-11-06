#lang at-exp racket/base

(require (for-syntax racket/base
                     syntax/parse)
         scribble/example
         scribble/manual)
(provide (all-defined-out))

(define (make-bits-eval) (make-base-eval #:lang 'typed/racket/base '(require bits)))
(define-syntax-rule (bits-examples body ...) (examples #:eval (make-bits-eval) body ...))

(define-syntax (define-tech stx)
  (syntax-parse stx
    [(_ tech/name module-path)
     (syntax/loc stx
       (define (tech/name
                #:key          [key        #f]
                #:normalize?   [normalize? #t]
                #:tag-prefixes [prefixes   #f]
                #:indirect?    [indirect?  #f]
                .
                alt)
         (apply tech
                #:key          key
                #:normalize?   normalize?
                #:doc          module-path
                #:tag-prefixes prefixes
                #:indirect?    indirect?
                alt)))]))

(define-tech tech/guide '(lib "scribblings/guide/guide.scrbl"))
(define-tech tech/refer '(lib "scribblings/reference/reference.scrbl"))


(define-syntax-rule (deftypeconstr args ...)
  @defform[#:kind "type constructor" args ...])

(define-syntax-rule (deftypeconstr* args ...)
  @defform*[#:kind "type constructor" args ...])

(define-syntax-rule (deftypeconstr*/subs args ...)
  @defform*/subs[#:kind "type constructor" args ...])

(define-syntax-rule (deftype args ...)
  @defidform[#:kind "type" args ...])

(define-syntax-rule (deftypeform args ...)
  @defform[#:kind "type" args ...])

(define-syntax-rule (deftypeform* args ...)
  @defform*[#:kind "type" args ...])

(define-syntax-rule (deftypeform/none args ...)
  @defform/none[#:kind "type" args ...])

(define-syntax-rule (deftypeconstr/none args ...)
  @defform/none[#:kind "type constructor" args ...])
