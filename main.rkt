#lang typed/racket/base

(provide bytes->natural
         natural->bytes

         Bit bit? one?
         bit->boolean
         boolean->bit

         bits-ref
         bits-set!)


(: bytes->natural (→ Bytes Natural))
(define (bytes->natural byte*)
  (define start (sub1 (bytes-length byte*)))
  (for/sum : Natural
           ([byte (in-bytes byte*)]
            [i : Integer (in-range start -1 -1)])
    (arithmetic-shift byte (* i #o10))))

(: natural->bytes (→ Natural Bytes))
(define (natural->bytes n)
  (cond
    [(zero? n) #""]
    [else
     (define len (arithmetic-shift (+ (integer-length n) 7) -3))
     (define byte* (make-bytes len 0))
     (for/fold ([n : Natural n])
               ([i : Integer (in-range (sub1 len) -1 -1)])
       (define byte (bitwise-and n #xff))
       (bytes-set! byte* i byte)
       (arithmetic-shift n #o-10))
     byte*]))


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
