\ From: John Hayes S1I
\ Subject: core.fr
\ Date: Mon, 27 Nov 95 13:10

\ (C) 1995 JOHNS HOPKINS UNIVERSITY / APPLIED PHYSICS LABORATORY
\ MAY BE DISTRIBUTED FREELY AS LONG AS THIS COPYRIGHT NOTICE REMAINS.
\ VERSION 1.2
\ THIS PROGRAM TESTS THE CORE WORDS OF AN ANS FORTH SYSTEM.
\ THE PROGRAM ASSUMES A TWO'S COMPLEMENT IMPLEMENTATION WHERE
\ THE RANGE OF SIGNED NUMBERS IS -2^(N-1) ... 2^(N-1)-1 AND
\ THE RANGE OF UNSIGNED NUMBERS IS 0 ... 2^(N)-1.
\ I HAVEN'T FIGURED OUT HOW TO TEST KEY, QUIT, ABORT, OR ABORT"...
\ I ALSO HAVEN'T THOUGHT OF A WAY TO TEST ENVIRONMENT?...

CR
TESTING CORE WORDS
HEX

\ ------------------------------------------------------------------------
TESTING INPUT: ACCEPT

CREATE ABUF 50 CHARS ALLOT

: ACCEPT-TEST
   CR ." PLEASE TYPE UP TO 80 CHARACTERS:" CR
   ABUF 50 ACCEPT
   CR ." RECEIVED: " [CHAR] " EMIT
   ABUF SWAP TYPE [CHAR] " EMIT CR
;

T{ ACCEPT-TEST -> }T

CR .( End of Core input word set tests) CR


