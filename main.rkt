#lang typed/racket/base

(provide Bit bit? one?

         bit->boolean
         boolean->bit

         bits-ref
         bits-set!)


(define-type Bit (∪ Zero One))
(define-predicate bit? Bit)
(define-predicate one? One)


(: bit->boolean (case→ (→ Zero False) (→ One True) (→ Bit Boolean)))
(: boolean->bit (case→ (→ False Zero) (→ True One) (→ Boolean Bit)))
(define (bit->boolean bit) (one? bit))
(define (boolean->bit bool) (if bool 1 0))


(: bits-ref (→ Bytes Integer Integer Bit))
(define (bits-ref byte* i j)
  (unless (<= 0 j 7) (raise-range-error 'bits-ref "bytes" "col " j byte* 0 7 #f))
  (define l (sub1 (bytes-length byte*)))
  (unless (<= 0 i l) (raise-range-error 'birs-ref "bytes" "row " i byte* 0 l #f))
  (define byte (bytes-ref byte* i))
  (define bool (bitwise-bit-set? byte j))
  (define bit  (boolean->bit bool))
  bit)

(: bits-set! (→ Bytes Integer Integer Bit Void))
(define (bits-set! byte* i j bit)
  (when (immutable? byte*)
    (raise-argument-error 'bits-set! "mutable-bytes?" byte*))
  (unless (<= 0 j 7) (raise-range-error 'bits-set! "bytes" "col " j byte* 0 7 #f))
  (define l (sub1 (bytes-length byte*)))
  (unless (<= 0 i l) (raise-range-error 'birs-set! "bytes" "row " i byte* 0 l #f))
  (define old-byte (bytes-ref byte* i))
  (define mask (arithmetic-shift 1 j))
  (define new-byte
    (if (one? bit)
        (bitwise-ior old-byte mask)
        (bitwise-and old-byte (bitwise-not mask))))
  (bytes-set! byte* i new-byte))
