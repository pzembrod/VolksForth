
\ *** Block No. 120, Hexblock 78

\ BIOS - Calls                                         09sep86we

Code bconstat  ( dev -- fl )
   SP )+ D0 move   D0 A7 -) move   1 # A7 -) move   $0D trap
   4 A7 addq   D0 SP -) move   Next end-code
Code bcostat   ( dev -- fl )
   SP )+ D0 move   D0 A7 -) move   8 # A7 -) move   $0D trap
   4 A7 addq   D0 SP -) move   Next end-code

Code bconin   ( dev -- char )
   SP )+ D0 move   D0 A7 -) move   2 # A7 -) move   $0D trap
   4 A7 addq   .w D0 D1 move   .l 8 # D0 lsr   .b D1 D0 move
   .w D0 SP -) move   Next end-code
Code bconout  ( char dev -- )
   SP )+ D0 move   SP )+ A7 -) move   D0 A7 -) move
   3 # A7 -) move    $0D trap   6 A7 addq   Next end-code

\ *** Block No. 121, Hexblock 79

\ STkey? getkey                                        cas201301

$08 Constant #bs         $0D Constant #cr
$0A Constant #lf         $1B Constant #esc

: con!     ( 8b -- )     2 bconout ;
: curon              #esc con!  Ascii e con! ;
: curoff             #esc con!  Ascii f con! ;
: wrap               #esc con!  Ascii v con! ;
: cur<               #esc con!  Ascii D con!   -1 out +!  ;
: cur>               #esc con!  Ascii C con!    1 out +!  ;

: STkey?   ( -- fl )     2 bconstat ;
: getkey   ( -- char )   STkey? IF  2 bconin  ELSE  0  THEN ;
: STkey    ( -- char )   curon
   BEGIN  pause STkey?  UNTIL curoff getkey ;

\ *** Block No. 122, Hexblock 7a

\ (ins (del                                            cas201301

| Variable maxchars

| : (del   ( addr pos1 -- addr pos2 )    2dup cur<
     at? >r >r   2dup +  over span @ - negate under   type space
       r> r> at
     >r + dup 1- r> cmove   -1 span +!   1-    ;

| : (ins   ( addr pos1 -- addr pos2 )    2dup
     +   over span @ - negate >r   dup   dup 1+ r@ cmove>
     bl over c!   r> 1+   at? >r >r   type   r> r> at
     1 span +! ;




\ *** Block No. 123, Hexblock 7b

\ decode                                               cas201301

: STdecode   ( addr pos1 key -- addr pos2 )
  $4D00 case?  IF dup  span @ <  IF  cur>  1+  THEN  exit THEN
  $4B00 case?  IF dup            IF  cur<  1-  THEN  exit THEN
  $5200 case?  IF dup  span @ -  IF  (ins      THEN  exit THEN
  $FF and   dup 0= IF  drop exit  THEN
    #bs case?  IF  dup    IF  (del  THEN  exit THEN
    $7F case?  IF  span @   2dup <  and
               IF  cur>    1+ (del  THEN  exit THEN
    #cr case?  IF span @  maxchars !
                  dup  at?  rot span @ -  - at  exit THEN
  >r  2dup + r@ swap c!  r> emit
  dup span @ = IF  1 span +!  THEN  1+ ;



\ *** Block No. 124, Hexblock 7c

\ expect keyboard                                      25mar86we

: STexpect   ( addr len -- )       maxchars !
   span off  0
      BEGIN   span @  maxchars @  u< WHILE   key decode   REPEAT
   2drop space ;


Input:  keyboard    [ here input ! ]
    STkey STkey? STdecode STexpect ;







\ *** Block No. 125, Hexblock 7d

\ emit cr del page at at? type                         cas201301

| Variable out    0 out !         | &80 Constant c/row

: STemit   ( 8b -- )    5 bconout   1 out +!   pause ;
: STcr                  #cr con!   #lf con!
                        out @  c/row /  1+  c/row *  out ! ;
: STdel                 #bs con!  space  #bs con!   -2 out +! ;
: STpage                #esc con!  Ascii E con!   out off ;
: STat  ( row col -- )  #esc con!  Ascii Y con!
                        over $20 + con!   dup $20 + con!
                        swap  c/row * + out ! ;
: STat? ( -- row col )  out @  c/row /mod swap ;

\ \\
\ : STtype ( addr len --) 0 ?DO count emit LOOP drop ;

\ *** Block No. 126, Hexblock 7e

\ Output                                               16oct86we

Code STtype   ( addr len -- )
   SP )+ D3 move   SP )+ D6 move   D3 tst  0<>
   IF   D3 out R#) add   1 D3 subq
     D3 DO   D6 reg) A0 lea  0 D1 moveq  .b A0 ) D1 move
FP A7 -) lmove .w  D1 A7 -) move  5 # A7 -) move  3 # A7 -) move
        $0D trap   6 A7 addq    1 D6 addq   A7 )+ FP lmove  LOOP
   THEN   ;c:  pause ;

Output: display    [ here output ! ]
   STemit STcr STtype STdel STpage STat STat? ;

| Code term    .l save_ssp R#) A7 -) move   .w $20 # A7 -) move
               1 trap  6 A7 addq   A7 -) clr  1 trap   end-code
| : (bye        curoff term ;

\ *** Block No. 127, Hexblock 7f

\ b/blk drive >drive drvinit                           10sep86we

$400 Constant b/blk
| Variable (drv    0 (drv !
Create (blk/drv
  4 allot      $15F (blk/drv !      $15F (blk/drv 2+ !

: blk/drv   ( -- n )                (blk/drv (drv @ 2* + @ ;

: drive   ( drv# -- )               $1000 * offset ! ;
: >drive  ( block drv# -- block' )  $1000 * + offset @ - ;
: drv?    ( block -- drv# )         offset @ + $1000 / ;

: drvinit noop ;
: drv0               0 drive ;    : drv1               1 drive ;


\ *** Block No. 128, Hexblock 80

\ readsector writesector                               cas201301

Code rwabs   ( r/wf adr rec# -- flag )
   .l FP A7 -) move
   .w SP )+ D0 move   SP )+ D6 move   D6 reg) A0 lea
      SP )+ D1 move   2 D1 addq
           (drv R#) A7 -) move      \ Drivenumber
                 D0 A7 -) move      \ rec#
                2 # A7 -) move      \ number sectors
              .l A0 A7 -) move      \ Address
              .w D1 A7 -) move      \ r/w flag
                4 # A7 -) move      \ function number
    $0D trap    $0E # A7 adda   .l A7 )+ FP move
                   .w D0 SP -) move \ error flag
    Next end-code


\ *** Block No. 129, Hexblock 81

\ diskchange?                                          09nov86we

| Code mediach?  ( -- flag )
   .w (drv R#) A7 -) move   9 # A7 -) move   $0D trap  4 A7 addq
   D0 SP -) move    Next end-code

| Code getblocks    ( -- n )
   .w (drv R#) A7 -) move   7 # A7 -) move   $0D trap  4 A7 addq
   D0 A0 move   .w $0E # A0 adda   A0 ) D0 move   D0 SP -) move
   Next end-code







\ *** Block No. 130, Hexblock 82

\ STr/w                                                10sep86we

: STr/w   ( adr blk file r/wf -- flag )
   swap abort" no file"
   1 xor -rot   $1000 /mod   dup (drv !
   1 u> IF   . ." beyond capacity"  nip  exit   THEN
   mediach? IF  getblocks  (blk/drv (drv @ 2* + !  THEN
   dup  blk/drv >  IF    drop 2drop true
                   ELSE  9 + 2*  rwabs  THEN ;

' STr/w Is r/w
