\ Extracted from tc-main.fth

\ *** Block No. 34, Hexblock 22

\ Ttools for decompiling     ks29jun85we

| : ?:  dup          4 u.r ." :"  ;
| : @?  dup  T @  H  6 u.r  ;
| : c?  dup  T c@ H  3  .r  ;

: s  ( adr - adr+)
 ?: space  c?  3 spaces
 dup 1+ over T c@ H ttype dup
 T c@ H + 1+ ;

: n  ( adr - adr+2)
 ?: @? 2 spaces dup
 T @ H [ Ttools ] >name .name H 2+ ;

: d  ( adr n - adr+n)
 2dup swap ?: swap 0
   DO c? 1+ LOOP 2 spaces -rot ttype ;


\ *** Block No. 35, Hexblock 23

\ Tools for decompiling      bp29jun85we

: l  ( adr - adr+2)
 ?: 5 spaces @? 2+  ;

: c  ( adr - adr+1)   1 d ;

: b  ( adr - adr+1)
 ?: @? dup T @ H over + 5 u.r 2+ ;

: dump   ( adr n -)
 bounds ?DO cr I 8 d drop stop?
   IF LEAVE THEN 8 +LOOP ;

: view
 T ' H  [ Ttools ] >name
 ?dup IF 4 - T @ H edit THEN ;
