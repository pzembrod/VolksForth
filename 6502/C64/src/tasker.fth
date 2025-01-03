\ *** Block No. 57, Hexblock 39

\ Multitasker               BP 13.9.84 )

Onlyforth

\needs multitask  include multitask.fth  save

\ *** Block No. 59, Hexblock 3b

\ pass  activate           ks 8 may 84 )

: pass  ( n0 .. nr-1 Tadr r -- )
 BEGIN  [ rot ( Trick ! ) ]
  swap  $2C over c! \ awake Task
  r> -rot           \ IP r addr
  8 + >r            \ s0 of Task
  r@ 2+ @  swap     \ IP r0 r
  2+ 2*             \ bytes on Taskstack
                    \ incl. r0 & IP
  r@ @ over -       \ new SP
  dup r> 2- !       \ into ssave
  swap bounds  ?DO  I !  2 +LOOP  ;
restrict

: activate ( Tadr --)
 0 [ -rot ( Trick ! ) ]  REPEAT ;
-2 allot  restrict

: sleep  ( Tadr --)
 $4C swap c! ;       \ JMP-Opcode

: wake  ( Tadr --)
 $2C swap c! ;       \ BIT-Opcode


\ *** Block No. 60, Hexblock 3c

\ building a Task           BP 13.9.84 )

| : taskerror  ( string -)
 standardi/o  singletask
 ." Task error : " count type
 multitask stop ;

: Task ( rlen  slen -- )
 allot              \ Stack
 here $FF and $FE =
 IF 1 allot THEN     \ 6502-align
 up@ here $100 cmove \ init user area
 here  $4C c,       \ JMP opcode
                    \     to sleep Task
 up@ 1+ @ ,
 dup  up@ 1+ !      \ link Task
 3 allot            \ allot JSR wake
 dup  6 -  dup , ,  \ ssave and s0
 2dup +  ,          \ here + rlen = r0
 under  + here - 2+ allot
 ['] taskerror  over
 [ ' errorhandler >body c@ ] Literal + !
 Constant ;



\ *** Block No. 61, Hexblock 3d

\ more Tasks           ks/bp  26apr85re)

: rendezvous  ( semaphoradr -)
 dup unlock pause lock ;

| : statesmart
 state @ IF [compile] Literal THEN ;

: 's  ( Tadr - adr.of.taskuservar)
 ' >body c@ + statesmart ; immediate

\ Syntax:   2  Demotask 's base  !
\ makes Demotask working binary

: tasks  ( -)
 ." MAIN " cr up@ dup 1+ @
 BEGIN  2dup - WHILE
  dup [ ' r0 >body c@ ] Literal + @
  6 + name> >name .name
  dup c@ $4C = IF ." sleeping" THEN cr
 1+ @ REPEAT  2drop ;





