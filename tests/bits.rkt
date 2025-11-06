#lang typed/racket

(require "../main.rkt" typed/rackunit)


(test-case "bytes->natural"
  (check-eq? (bytes->natural #"") 0)
  (check-eq? (bytes->natural #"\x01") 1)
  (check-eq? (bytes->natural #"\x01\xab") (+ (* #x01 #x100) #xab)))

(test-case "natural->bytes"
  (check-equal? (natural->bytes 0) #"")
  (check-equal? (natural->bytes 1) #"\x01")
  (check-equal? (natural->bytes #x01ab) #"\x01\xab"))

(test-case "Round-trip"
  (check-equal? (natural->bytes (bytes->natural #"\xca\xfe\xba\xbe"))
                #"\xca\xfe\xba\xbe")
  (check-eq? (bytes->natural (natural->bytes 1234567890))
             1234567890))

(test-case "bit predicates"
  (check-pred bit? 0)
  (check-pred bit? 1)
  (check-pred one? 1)
  (check-false (bit? 2))
  (check-false (one? 0)))

(test-case "bit <-> boolean conversion"
  (check-eq? (bit->boolean 1) #t)
  (check-eq? (bit->boolean 0) #f)
  (check-eq? (boolean->bit #t) 1)
  (check-eq? (boolean->bit #f) 0))

(let ([test-bytes #"\xaa\xaa"])
  (test-case "Error conditions"
    (check-exn exn:fail:contract? (λ () (bits-ref test-bytes 0 8)))
    (check-exn exn:fail:contract? (λ () (bits-ref test-bytes 2 0)))
    (check-exn exn:fail:contract? (λ () (bits-set! test-bytes 0 8 1)))
    (check-exn exn:fail:contract? (λ () (bits-set! test-bytes 2 0 1)))
    (check-exn exn:fail:contract? (λ () (bits-set! #"\x00" 0 0 1))))

  (test-case "bits-ref"
    (check-equal? (bits-ref test-bytes 0 0) 0)
    (check-equal? (bits-ref test-bytes 0 1) 1)
    (check-equal? (bits-ref test-bytes 1 6) 0)
    (check-equal? (bits-ref test-bytes 1 7) 1)))

(test-case "bits-set!"
  (define bs (make-bytes 2 0))
  (bits-set! bs 0 3 1)
  (check-equal? bs #"\x08\x00")
  (bits-set! bs 1 7 1)
  (check-equal? bs #"\x08\x80")
  (bits-set! bs 0 3 0)
  (check-equal? bs #"\x00\x80"))

(test-case "bits-set! and bits-ref roundtrip"
  (define bs (make-bytes 1 0))
  (check-equal? (bits-ref bs 0 5) 0)
  (bits-set! bs 0 5 1)
  (check-equal? (bits-ref bs 0 5) 1)
  (bits-set! bs 0 5 0)
  (check-equal? (bits-ref bs 0 5) 0))
