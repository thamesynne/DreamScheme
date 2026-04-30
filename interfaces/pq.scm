;;;;;;;;;;;;;;;;;;;
;;; Dll Modules ;;;
;;;;;;;;;;;;;;;;;;;

(define *pq-path* "/usr/lib/libpq.so")
(define *pq* (dlopen *pq-path*))
(if (zero? *pq*) (error "Could not open PQ library"))

;;;;;;;;;;;;;;;;;
;;; Constants ;;;
;;;;;;;;;;;;;;;;;

(define CONNECTION_OK 0)
(define CONNECTION_BAD 1)
(define CONNECTION_STARTED 2)
(define CONNECTION_MADE 3)
(define CONNECTION_AWAITING_RESPONSE 4)
(define CONNECTION_AUTH_OK 5)
(define CONNECTION_SETENV 6)
(define CONNECTION_SSL_STARTUP 7)
(define CONNECTION_NEEDED 8)

(define PQTRANS_IDLE 0)
(define PQTRANS_ACTIVE 1)
(define PQTRANS_INTRANS 2)
(define PQTRANS_INERROR 3)
(define PQTRANS_UNKNOWN 4)

(define PGRES_EMPTY_QUERY 0)
(define PGRES_COMMAND_OK 1)
(define PGRES_TUPLES_OK 2)
(define PGRES_COPY_OUT 3)
(define PGRES_COPY_IN 4)
(define PGRES_BAD_RESPONSE 5)
(define PGRES_NONFATAL_ERROR 6)
(define PGRES_FATAL_ERROR 7)

(define PG_DIAG_SEVERITY #\S)
(define PG_DIAG_SQLSTATE #\C)
(define PG_DIAG_MESSAGE_PRIMARY #\M)
(define PG_DIAG_MESSAGE_DETAIL #\D)
(define PG_DIAG_MESSAGE_HINT #\H)
(define PG_DIAG_STATEMENT_POSITION #\P)
(define PG_DIAG_INTERNAL_POSITION #\p)
(define PG_DIAG_INTERNAL_QUERY #\q)
(define PG_DIAG_CONTEXT #\W)
(define PG_DIAG_SOURCE_FILE #\F)
(define PG_DIAG_SOURCE_LINE #\L)
(define PG_DIAG_SOURCE_FUNCTION #\R)

;;;;;;;;;;;;;;;;;
;;; Functions ;;;
;;;;;;;;;;;;;;;;;

(define pq-connectdb
  (let ((f (dlsym *pq* "PQconnectdb")))
    (lambda (conninfo)
      (dlcall f conninfo))))

(define pq-finish
  (let ((f (dlsym *pq* "PQfinish")))
    (lambda (conn)
      (dlcall f conn))))

(define pq-reset
  (let ((f (dlsym *pq* "PQreset")))
    (lambda (conn)
      (dlcall f conn))))

(define pq-db
  (let ((f (dlsym *pq* "PQdb")))
    (lambda (conn)
      (make-immutable-string (dlcall f conn)))))

(define pq-user
  (let ((f (dlsym *pq* "PQuser")))
    (lambda (conn)
      (make-immutable-string (dlcall f conn)))))

(define pq-pass
  (let ((f (dlsym *pq* "PQpass")))
    (lambda (conn)
      (make-immutable-string (dlcall f conn)))))

(define pq-host
  (let ((f (dlsym *pq* "PQhost")))
    (lambda (conn)
      (make-immutable-string (dlcall f conn)))))

(define pq-port
  (let ((f (dlsym *pq* "PQport")))
    (lambda (conn)
      (make-immutable-string (dlcall f conn)))))

(define pq-tty
  (let ((f (dlsym *pq* "PQtty")))
    (lambda (conn)
      (make-immutable-string (dlcall f conn)))))

(define pq-options
  (let ((f (dlsym *pq* "PQoptions")))
    (lambda (conn)
      (make-immutable-string (dlcall f conn)))))

(define pq-status
  (let ((f (dlsym *pq* "PQstatus")))
    (lambda (conn)
      (dlcall f conn)))) ;CONNECTION_...

(define pq-transaction-status
  (let ((f (dlsym *pq* "PQtransactionStatus")))
    (lambda (conn)
      (dlcall f conn)))) ;PQTRANS_...

(define pq-parameter-status
  (let ((f (dlsym *pq* "PQparameterStatus")))
    (lambda (conn paramname)
      (make-immutable-string (dlcall f paramname conn)))))

(define pq-protocol-version
  (let ((f (dlsym *pq* "PQprotocolVersion")))
    (lambda (conn)
      (dlcall f conn))))

(define pq-server-version
  (let ((f (dlsym *pq* "PQserverVersion")))
    (lambda (conn)
      (dlcall f conn))))

(define pq-error-message
  (let ((f (dlsym *pq* "PQerrorMessage")))
    (lambda (conn)
      (make-immutable-string (dlcall f conn)))))

(define pq-backend-pid
  (let ((f (dlsym *pq* "PQbackendPID")))
    (lambda (conn)
      (dlcall f conn))))

(define pq-exec
  (let ((f (dlsym *pq* "PQexec")))
    (lambda (conn command)
      (dlcall f command conn))))

(define pq-result-status
  (let ((f (dlsym *pq* "PQresultStatus")))
    (lambda (res)
      (dlcall f res)))) ;PGRES_...

(define pq-res-status
  (let ((f (dlsym *pq* "PQresStatus")))
    (lambda (status)
      (make-immutable-string (dlcall f status)))))

(define pq-result-error-message
  (let ((f (dlsym *pq* "PQresultErrorMessage")))
    (lambda (res)
      (make-immutable-string (dlcall f res)))))

(define pq-result-error-field
  (let ((f (dlsym *pq* "PQresultErrorField")))
    (lambda (res fieldcode) ;PG_DIAG_...
      (make-immutable-string (dlcall f (char->integer fieldcode) res)))))

(define pq-clear
  (let ((f (dlsym *pq* "PQclear")))
    (lambda (res)
      (dlcall f res))))

(define pq-ntuples
  (let ((f (dlsym *pq* "PQntuples")))
    (lambda (res)
      (dlcall f res))))

(define pq-nfields
  (let ((f (dlsym *pq* "PQnfields")))
    (lambda (res)
      (dlcall f res))))

(define pq-fname
  (let ((f (dlsym *pq* "PQfname")))
    (lambda (res column-number)
      (make-immutable-string (dlcall f column-number res)))))

(define pq-fnumber
  (let ((f (dlsym *pq* "PQfnumber")))
    (lambda (res column-name)
      (dlcall f column-name res))))

(define pq-ftable
  (let ((f (dlsym *pq* "PQftable")))
    (lambda (res column-number)
      (dlcall f column-number res))))

(define pq-ftablecol
  (let ((f (dlsym *pq* "PQftablecol")))
    (lambda (res column-number)
      (dlcall f column-number res))))

(define pq-fformat
  (let ((f (dlsym *pq* "PQfformat")))
    (lambda (res column-number)
      (dlcall f column-number res))))

(define pq-ftype
  (let ((f (dlsym *pq* "PQftype")))
    (lambda (res column-number)
      (dlcall f column-number res))))

(define pq-fmod
  (let ((f (dlsym *pq* "PQfmod")))
    (lambda (res column-number)
      (dlcall f column-number res))))

(define pq-fsize
  (let ((f (dlsym *pq* "PQfsize")))
    (lambda (res column-number)
      (dlcall f column-number res))))

(define pq-getvalue
  (let ((f (dlsym *pq* "PQgetvalue")))
    (lambda (res row-number column-number)
      (make-immutable-string (dlcall f column-number row-number res)))))

(define pq-getisnull
  (let ((f (dlsym *pq* "PQgetisnull")))
    (lambda (res row-number column-number)
      (positive? (dlcall f column-number row-number res)))))

(define pq-getlength
  (let ((f (dlsym *pq* "PQgetlength")))
    (lambda (res row-number column-number)
      (dlcall f column-number row-number res))))

(define pq-cmd-tuples
  (let ((f (dlsym *pq* "PQcmdTuples")))
    (lambda (res)
      (make-immutable-string (dlcall f res)))))

(define pq-oid-value
  (let ((f (dlsym *pq* "PQoidValue")))
    (lambda (res)
      (dlcall f res))))
