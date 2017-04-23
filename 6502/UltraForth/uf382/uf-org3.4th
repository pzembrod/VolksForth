\ Block No. 0
\\ Directory ultraFORTH 3of4   26oct87re

.                   &0
..                  &0
rom-ram-sys         &2
Transient-Assembler &4
Assembler-6502      &5
2words             &14
unlink             &15
scr<>cbm           &16
(search            &17
Editor             &19
.blk               &46
Tracer/Tools       &47
Multi-Tasker       &57
EpsonRX80          &63
VC1526             &75
CP-80              &78







\ Block No. 1
\\ Inhalt ultraFORTH 3of4      26oct87re

rom ram sys          2 - 3
Transient Assembler  4
Assembler-6502       5 - 12
                    13       frei
2words              14
unlink              15
scr<>cbm            16
(search             17
Editor              19
.blk                46
Tracer Tools        47
Multi-Tasker        57
Printer: EpsonRX80  63
Printer: VC1526     75
Printer: CP-80      78

Shadows             85 folgende






\ Block No. 2
\ rom ram sys              clv/re20aug87
\              Shadow mit Ctrl+W--->

\ wird gebraucht, wenn
\ Spruenge ins ROM gehen.

Assembler also definitions
(16 \ Umschalten des Bereichs 8000-FFFF
: rom here 9 + $8000 u> abort" not here"
       $ff3e sta ;
: ram  $ff3f sta ;
: sys rom jsr ram ;
\  wer unter diesem abort" not here"
\  leidet: s.naechster Screen --> C)


(64 \ Umschalten des Bereichs A000-BFFF
: rom here 9 + $A000 u> abort" not here"
      $37 # lda 1 sta ;
: ram $36 # lda 1 sta ;
C)




\ Block No. 3
\ sysMacro Long             clv20aug87re

(64  .( Nicht fuer C64 !) \\ C)

\ Mit Makro: fuer Fortgeschrittene

here $8000 $20 - u> ?exit \ geht nicht!

' 0 | Alias ???

Label long   ROM
Label long1  ??? jsr  RAM  rts end-code

| : sysMacro ( adr -- )
 $100 u/mod  pha  # lda  long1 2+ sta
 # lda  long1 1+ sta  pla  long jsr ;

: sys ( adr -- ) \ fuer Jsr ins ROM
 here 9 + $8000 u>
 IF  sysMacro  ELSE  sys  THEN ;





\ Block No. 4
\ transient Assembler         clv10oct87

\ Basis: Forth Dimensions VOL III No. 5)

\ internal loading         04may85BP/re)

here   $800 hallot  heap dp !

         1  +load

dp !

Onlyforth












\ Block No. 5
\ Forth-6502 Assembler        clv10oct87

\ Basis: Forth Dimensions VOL III No. 5)

Onlyforth  Assembler also definitions

1 7  +thru
 -3  +load \ Makros: rom ram sys

Onlyforth















\ Block No. 6
\ Forth-83 6502-Assembler      20oct87re

: end-code   context 2- @  context ! ;

Create index
$0909 , $1505 , $0115 , $8011 ,
$8009 , $1D0D , $8019 , $8080 ,
$0080 , $1404 , $8014 , $8080 ,
$8080 , $1C0C , $801C , $2C80 ,

| Variable mode

: Mode:  ( n -)   Create c,
  Does>  ( -)     c@ mode ! ;

0   Mode: .A        1    Mode: #
2 | Mode: mem       3    Mode: ,X
4   Mode: ,Y        5    Mode: X)
6   Mode: )Y       $F    Mode: )






\ Block No. 7
\ upmode  cpu                  20oct87re

| : upmode ( addr0 f0 - addr1 f1)
 IF mode @  8 or mode !   THEN
 1 mode @  $F and ?dup IF
 0 DO  dup +  LOOP THEN
 over 1+ @ and 0= ;

: cpu  ( 8b -)   Create  c,
  Does>  ( -)    c@ c, mem ;

 00 cpu brk $18 cpu clc $D8 cpu cld
$58 cpu cli $B8 cpu clv $CA cpu dex
$88 cpu dey $E8 cpu inx $C8 cpu iny
$EA cpu nop $48 cpu pha $08 cpu php
$68 cpu pla $28 cpu plp $40 cpu rti
$60 cpu rts $38 cpu sec $F8 cpu sed
$78 cpu sei $AA cpu tax $A8 cpu tay
$BA cpu tsx $8A cpu txa $9A cpu txs
$98 cpu tya





\ Block No. 8
\ m/cpu                        20oct87re

: m/cpu  ( mode opcode -)  Create c, ,
 Does>
 dup 1+ @ $80 and IF $10 mode +! THEN
 over $FF00 and upmode upmode
 IF mem true Abort" invalid" THEN
 c@ mode @ index + c@ + c, mode @ 7 and
 IF mode @  $F and 7 <
  IF c, ELSE , THEN THEN mem ;

$1C6E $60 m/cpu adc $1C6E $20 m/cpu and
$1C6E $C0 m/cpu cmp $1C6E $40 m/cpu eor
$1C6E $A0 m/cpu lda $1C6E $00 m/cpu ora
$1C6E $E0 m/cpu sbc $1C6C $80 m/cpu sta
$0D0D $01 m/cpu asl $0C0C $C1 m/cpu dec
$0C0C $E1 m/cpu inc $0D0D $41 m/cpu lsr
$0D0D $21 m/cpu rol $0D0D $61 m/cpu ror
$0414 $81 m/cpu stx $0486 $E0 m/cpu cpx
$0486 $C0 m/cpu cpy $1496 $A2 m/cpu ldx
$0C8E $A0 m/cpu ldy $048C $80 m/cpu sty
$0480 $14 m/cpu jsr $8480 $40 m/cpu jmp
$0484 $20 m/cpu bit


\ Block No. 9
\ Assembler conditionals       20oct87re

| : range?   ( branch -- branch )
 dup abs  $7F u> Abort" out of range " ;

: [[  ( BEGIN)  here ;

: ?]  ( UNTIL)  c, here 1+ - range? c, ;

: ?[  ( IF)     c,  here 0 c, ;

: ?[[ ( WHILE)  ?[ swap ;

: ]?  ( THEN)   here over c@  IF swap !
 ELSE over 1+ - range? swap c! THEN ;

: ][  ( ELSE)   here 1+   1 jmp
 swap here over 1+ - range?  swap c! ;

: ]]  ( AGAIN)  jmp ;

: ]]? ( REPEAT) jmp ]? ;



\ Block No. 10
\ Assembler conditionals       20oct87re

$90 Constant CS     $B0 Constant CC
$D0 Constant 0=     $F0 Constant 0<>
$10 Constant 0<     $30 Constant 0>=
$50 Constant VS     $70 Constant VC

: not    $20 [ Forth ] xor ;

: beq    0<> ?] ;   : bmi   0>= ?] ;
: bne    0=  ?] ;   : bpl   0<  ?] ;
: bcc    CS  ?] ;   : bvc   VS  ?] ;
: bcs    CC  ?] ;   : bvs   VC  ?] ;












\ Block No. 11
\ 2inc/2dec   winc/wdec        20oct87re

: 2inc  ( adr -- )
 dup lda  clc  2 # adc
 dup sta  CS ?[  swap 1+ inc  ]?  ;

: 2dec  ( adr -- )
 dup lda  sec  2 # sbc
 dup sta  CC ?[  swap 1+ dec  ]?  ;

: winc  ( adr -- )
 dup inc  0= ?[  swap 1+ inc  ]?  ;

: wdec  ( adr -- )
 dup lda  0= ?[  over 1+ dec  ]?  dec  ;

: ;c:
 recover jsr  end-code ]  0 last !  0 ;







\ Block No. 12
\ ;code Code code>          bp/re03feb85

Onlyforth

: Assembler
 Assembler   [ Assembler ] mem ;

: ;Code
 [compile] Does>  -3 allot
 [compile] ;      -2 allot   Assembler ;
immediate

: Code  Create here dup 2- ! Assembler ;

: >label  ( adr -)
 here | Create  immediate  swap ,
 4 hallot heap 1 and hallot ( 6502-alig)
 here 4 - heap  4  cmove
 heap last @ count $1F and + !  dp !
  Does>  ( - adr)   @
  state @ IF  [compile] Literal  THEN ;

: Label
 [ Assembler ]  here >label Assembler ;

\ Block No. 13
\ frei                         20oct87re
























\ Block No. 14
\ 2! 2@ 2variable 2constant clv20aug87re

Code 2!  ( d adr --)
 tya  setup jsr  3 # ldy
 [[  SP )Y lda  N )Y sta  dey  0< ?]
 1 # ldy  Poptwo jmp  end-code

Code 2@  ( adr -- d)
 SP X) lda  N sta  SP )Y lda  N 1+ sta
 SP 2dec  3 # ldy
 [[  N )Y lda  SP )Y sta  dey  0< ?]
 xyNext jmp  end-code

: 2Variable  ( --)   Create 4 allot ;
             ( -- adr)

: 2Constant  ( d --)   Create , ,
  Does> ( -- d)   2@ ;

\ 2dup  exists
\ 2swap exists
\ 2drop exists



\ Block No. 15
\ unlink                    clv20aug87re

$FFF0 >label plot

(64

Code unlink  ( -- )
  $288 lda  $80 # ora  tay  txa
  [[  $D9 ,X sty  clc  $28 # adc
   CS ?[  iny  ]?  inx  $1A # cpx  0= ?]
  $D3 lda  $28 # cmp
  CS ?[  $28 # sbc  $D3 sta  ]?
  $D3 ldy  $D6 ldx  clc  plot jsr C)

(16 : unlink  0 0  $7EE 2! ; C)

Label setptrs
 0 # ldx  1 # ldy  Next jmp  end-code







\ Block No. 16
( changing codes              18may85we)
( Wie gut, dass commodore ...          )
( ... besondere screen-codes hat.      )

Label (scr>cbm
 N 6 + sta $3F # and  N 6 + asl
 N 6 + bit  0< ?[ $80 # ora  ]?
            VC ?[ $40 # ora  ]?  rts

Label (cbm>scr
 N 6 + sta $7F # and $20 # cmp
 CS ?[ $40 # cmp
    CS ?[ $1F # and  N 6 + bit
       0< ?[ $40 # ora  ]?  ]?  rts  ]?
 Ascii . # lda  rts

Code cbm>scr  ( 8b1 -- 8b2)
 SP X) lda  (cbm>scr jsr  SP X) sta
 Next jmp  end-code

Code scr>cbm  ( 8b1 -- 8b2)
 SP X) lda  (scr>cbm jsr  SP X) sta
 Next jmp  end-code


\ Block No. 17
\ schnelles search        bp   17jun85re

\needs Code -$D +load \ Trans Assembler

Onlyforth

 ' 0< @ 4 +  >label puttrue
puttrue 3 +  >label putfalse

Code (search
( text tlen buffer blen -- adr tf / ff)
 7 # ldy
 [[  SP )Y lda  N ,Y sta dey  0< ?]
 [[ N 4 + lda  N 5 + ora  0<> ?[
 [[ N     lda   N 1+ ora  0<> ?[
    N 2+ X) lda  N 6 + X) cmp  swap
    0<> ?[[  N wdec  N 2+ winc  ]]?

-->






\ Block No. 18
\ Edi schnelles search    bp   17jun85re

 7 # ldy
 [[  N ,Y lda  SP )Y sta  dey  0< ?]
 [[  N 2+ winc  N 6 + winc  N wdec
 N 4 + wdec  N 4 + lda  N 5 + ora
 0= ?[  SP lda  clc  4 # adc  SP sta
        CS ?[  SP 1+ inc  ]?
        3 # ldy  N 3 + lda  SP )Y sta
        N 2+ lda  dey  SP )Y sta  dey
        puttrue jmp  ]?
 N lda  N 1+ ora  0= ?[
 3 roll  3 roll ]? ]?
 SP lda  clc  6 # adc  SP sta
 CS ?[  SP 1+ inc ]?   1 # ldy
 putfalse jmp  ]?
 N 2+ X) lda  N 6 + X) cmp  0= not ?]
 7 # ldy
 [[ SP )Y lda  N ,Y sta  dey  0< ?]
 N wdec  N 2+ winc
 ( next char as first )  ]]  end-code




\ Block No. 19
\ Editor loadscreen           clv13jul87
\ Idea and first implementation:  WE/re

Onlyforth
\needs .blk       $1B +load \ .blk
\needs Code       -$F +load \ Assembl
\needs (search     -2 +load \ (search

Onlyforth
(64 | : at  at curoff ; C) \ sorry

\needs 2variable  -5 +load
\needs unlink     -4 +load  \ unlink
\needs scr>cbm    -3 +load  \ cbm><scr

Vocabulary Editor
Editor also definitions

                1 $17 +thru  \ Editor
              $18 $19 +thru  \ edit-view
                  $1A +load  \ Ediboard

Onlyforth  1 scr !  0 r# !

save
\ Block No. 20
\ Edi Constants Variables     clv15jul87

$28 | Constant #col $19 | Constant #row
#col  #row  *           | Constant b/scr
  Variable shadow   $55 shadow !
| Variable ascr     1 ascr !
|  Variable imode   imode off
| Variable char     #cr char !
| Variable scroll   scroll on
| Variable send     1 send !
| 2variable chars   | 2variable lines
| 2variable fbuf    | 2variable rbuf

(64 $288 C)  (16 $53e C)  >Label scradr
(64 $d800 C) (16 $800 C)  >Label coladr

$d1  (16 drop $c8 C) | Constant linptr
$d3  (16 drop $ca C) | Constant curofs

(64 $D020 C) (16 $ff19 C)
 | Constant border
(64 $286  C) (16 $53b C) | Constant pen
(64 $d021 C) (16 $ff15 C)
 | Constant bkgrnd

\ Block No. 21
( Edi special cmoves         clv21.3.87)
( Dank an commodore ...                )

Label incpointer
 N    lda  clc  #col 1+ # adc
 N    sta  CS ?[  N 1+  inc  ]?
 N 2+ lda  clc  #col    # adc
 N 2+ sta  CS ?[  N 3 + inc  ]?  rts

| Code b>sc   ( blkadr --)
 tya  setup jsr
 N 2+ stx  scradr lda  N 3 + sta
 #row # ldx
 [[  #col 1- # ldy
     [[  N    )Y lda  (cbm>scr jsr
         N 2+ )Y sta  dey  0< ?]
     incpointer jsr  dex
 0= ?]
 pen lda
 [[ coladr        ,X sta
    coladr $100 + ,X sta
    coladr $200 + ,X sta
    coladr $300 + ,X sta
    inx  0= ?]  setptrs jmp   end-code

\ Block No. 22
( Edi special cmoves cont.   clv21.3.87)
( ... fuer dies Bildschirmformat.      )

| Code sc>b   ( blkadr --)
 tya  setup jsr
 N 2+ stx  scradr lda  N 3 + sta
 #row # ldx
 [[  0 # ldy
     [[  N 2+ )Y lda  (scr>cbm jsr
         N )Y sta  iny  #col # cpy CS ?]
     dex
 0<> ?[[
     bl # lda  N )Y sta
     incpointer jsr
 ]]?  setptrs jmp  end-code

| Code >scrmove  ( from to 8bquan --)
 3 # lda  setup jsr  dey
 [[  N cpy  0= ?[  setptrs jmp  ]?
     N 4 + )Y lda  (cbm>scr jsr
     N 2+  )Y sta  iny  0= ?]  end-code




\ Block No. 23
( Edi changed?               clv21.3.87)

| Code changed?   ( blkadr -- f)
 tya  setup jsr
 N 2+ stx  scradr lda  N 3 + sta
 #row # ldx
 [[  #col 1- # ldy
     [[  N )Y lda  (cbm>scr jsr
         N 2+ )Y cmp
         0<> ?[  $FF # lda  PushA jmp ]?
         dey 0<  ?]
     incpointer jsr  dex
 0= ?]
 txa  PushA jmp  end-code

| : memtop  sp@ #col 2* - ;









\ Block No. 24
\ Edi c64-specials           clv2:jull87

| Code scrstart  ( -- adr)
 txa pha scradr lda  Push jmp end-code


| Code rowadr  ( -- adr)
 curofs lda  #col # cmp  txa
 CS ?[  #col 1- # lda  ]?
 linptr adc pha linptr 1 + lda  0 # adc
 Push jmp  end-code

| Code curadr  ( -- adr)
 clc curofs lda linptr adc  pha
 linptr 1 + lda 0 # adc Push jmp
 end-code
(64
| Code unlinked?     \ -- f
 $D5 lda  #col # cmp  CC ?[  dex  ]?
 txa  PushA jmp  end-code C)





\ Block No. 25
\ Edi scroll? put/insert/do  clv2:jull87

| : blank.end?  ( -- f)
 scrstart [ b/scr #col - ] Literal +
 #col -trailing nip  0=  scroll @ or ;

| : atlast?  ( -- f)
 curadr  scrstart b/scr + 1-  =
 scroll @ 0=  and ;

| : putchar  ( -- f)
 char c@ con! false ;

| : insert  ( -- f)
 atlast?  ?dup ?exit
(64  unlinked? C) (16 true C)
 rowadr #col + 1- c@  bl = not  and
 blank.end? not  and  dup ?exit
 $94 con! ;

| : dochar  ( -- f)
 atlast?  ?dup ?exit
 imode @ IF insert ?dup ?exit
 THEN putchar ;

\ Block No. 26
( Edi cursor control          15may85re)

| : curdown  ( -- f)
 scroll @ 0=  row  #row 2-  u>  and
 dup ?exit $11 con! ;

| : currite  ( -- f)
 atlast? dup ?exit $1D con! ;

' putchar | Alias curup
' putchar | Alias curleft
' putchar | Alias home
' putchar | Alias delete

| : >""end  ( -- ff)
 scrstart b/scr -trailing nip
 b/scr 1- min #col /mod swap at false ;

| : +tab  ( -- f)
 0  $a 0 DO  drop currite dup
            IF LEAVE THEN  LOOP ;

| : -tab  ( -- f)
 5 0 DO $9D con!  LOOP  false ;

\ Block No. 27
( Edi cr, clear/newline       12jun85re)

| : <cr>  ( -- f)
 row 0 at  unlink  imode off  curdown ;

| : clrline  ( -- ff)
 rowadr #col bl fill false ;

| : clrright  ( -- ff)
 curadr #col col - bl fill false ;

| : killine  ( -- f)
 rowadr dup #col + swap
 scrstart $3C0 + dup >r
 over - cmove
 r> #col bl fill false ;

| : newline  ( -- f)
 blank.end? not  ?dup ?exit
 rowadr dup #col + scrstart b/scr +
 over - cmove>  clrline ;




\ Block No. 28
( Edi character handling      18jun85re)

| : dchar  ( -- f)
 currite  dup ?exit $14 con! ;

| : @char  ( -- f)
 chars 2@ + 1+  lines @ memtop min
 u>  dup ?exit
 curadr c@  chars 2@ +  c!
 1 chars 2+ +! ;

| : copychar  ( -- f)
 @char  ?dup ?exit  currite ;

| : char>buf  ( -- f)
 @char  ?dup ?exit  dchar ;

| : buf>char  ( -- f)
 chars 2+ @ 0=  ?dup ?exit
 insert        dup ?exit
 -1 chars 2+ +!
 chars 2@ +  c@  curadr c! ;



\ Block No. 29
( Edi line handling, imode    18jun85re)

| : @line  ( -- f)
 lines 2@ +  memtop  u>  dup ?exit
 rowadr  lines 2@ +  #col  cmove
 #col lines 2+ +! ;

| : copyline  ( -- f)
 @line  ?dup ?exit  curdown ;

| : line>buf  ( -- f)
 @line  ?dup ?exit  killine ;

| : !line  ( --)
 #col negate lines 2+ +!
 lines 2@ +  rowadr  #col  cmove  ;

| : buf>line  ( -- f)
 lines 2+ @ 0=  ?dup ?exit
 newline  dup ?exit  !line ;

| : setimd  ( -- f)   imode on false ;

| : clrimd  ( -- f)   imode off false ;

\ Block No. 30
( Edi the stamp               17jun85re)

Forth definitions
: rvson $12 con! ;  : rvsoff $92 con! ;

Code ***ultraFORTH83***
     Next here 2- !  end-code
: Forth-Gesellschaft   [compile] \\ ;
immediate

Editor definitions
Create stamp$ $12 allot stamp$ $12 erase

| : .stamp  ( -- ff)
 stamp$ 1+ count  scrstart #col +
 over -   swap >scrmove false ;

: getstamp  ( --)
 input push  keyboard  stamp$ on
 cr ." your stamp: "  rvson $10 spaces
 row $C at  stamp$ 2+ $10 expect
 rvsoff  span @ stamp$ 1+ c! ;

| : stamp?  ( --)
 stamp$ c@ ?exit getstamp ;
\ Block No. 31
\ Edi the screen#             clv01aug87

| : savetop  ( --)
 scrstart pad #col 2* cmove
 scrstart #col 2* $A0 fill ;
| : resttop  ( --)
 pad scrstart #col 2* cmove ;
| : updated?  ( scr# -- n)
 block 2- @ ;
| : special  ( --)
 curon BEGIN pause key? UNTIL curoff ;

| : drvScr ( --drv scr')
 scr @ offset @ + blk/drv u/mod swap ;

| : .scr#  ( -- ff) at? savetop  rvson
 0 0 at drvScr ." Scr # " . ." Drv " .
 scr @ updated? 0=
 IF ." not " THEN ." updated"  1 1 at
 [ ' ***ultraFORTH83*** >name ] Literal
 count type 2 spaces
 [ ' Forth-Gesellschaft >name ] Literal
 count $1F and type
 rvsoff at special resttop false ;

\ Block No. 32
( Edi exits                   20may85re)

| : at?>r#  ( --)
 at? swap #col 1+ * + r# ! ;

| : r#>at  ( --)
 r# @  dup  #col 1+  mod  #col =  -
 b/blk 1- min  #col 1+  /mod  swap at ;

| : cancel  ( -- n)
 unlink  %0001  at?>r# ;

| : eupdate ( -- n)
 cancel  scr @ block changed?
 IF .stamp drop  scr @ block sc>b
    update %0010 or THEN ;

| : esave   ( -- n)   eupdate %0100 or ;

| : eload   ( -- n)   esave   %1000 or ;





\ Block No. 33
\ leaf thru Edi               clv01aug87

| : elist  ( -- ff)
 scr @ block b>sc  imode off  unlink
 r#>at  false ;

| : next    ( -- ff)
 eupdate drop  1 scr +!  elist ;

| : back    ( -- ff)
 eupdate drop -1 scr +!  elist ;

| : >shadow  ( -- ff)
 eupdate drop  shadow @ dup drvScr nip
 u> not IF negate THEN  scr +!  elist ;

| : alter  ( -- ff)
 eupdate drop  ascr @  scr @
 ascr !  scr !  elist ;






\ Block No. 34
\ Edi digits                    2oct87re

Forth definitions

: digdecode  ( adr cnt1 key -- adr cnt2)
 #bs case?   IF  dup  IF
                 del 1- THEN exit THEN
 #cr case?   IF  dup span !  exit THEN
 capital dup digit?
 IF  drop >r 2dup + r@ swap c!
     r> emit  1+  exit  THEN  drop ;

Input: digits
 c64key c64key? digdecode c64expect ;

Editor definitions

| : replace  ( -- f)
 fbuf @ 0 DO  #bs con!  LOOP
 false rbuf @ 0 DO insert or LOOP
 dup ?exit
 rbuf 2@ curadr swap >scrmove
 eupdate drop ;


\ Block No. 35
( Edi >bufs                   20nov85re)

| : .buf  ( adr count --)
 type Ascii < emit
 #col 1- col - spaces ;

| : >bufs  ( --)
 input push
 unlink savetop at?  rvson
 1 0 at ." replace with: "
 at? rbuf 2@ .buf
 0 0 at ." >     search: "
 at? fbuf 2@ .buf
 0 2  2dup at  send @ 3 u.r  2dup at
 here 1+ 3 digits expect  span @ ?dup
 IF  here under c!  number drop send !
     THEN  at  send @ 3 u.r  keyboard
 2dup at fbuf 2+ @  #col 2- col - expect
 span @ ?dup IF  fbuf !  THEN
 at fbuf 2@ .buf
 2dup at rbuf 2+ @  #col 2- col - expect
 span @ ?dup IF  rbuf !  THEN
 at rbuf 2@ .buf
 rvsoff resttop at ;

\ Block No. 36
\ Edi esearch                 clv06aug87

| : (f      elist drop
 fbuf 2@  r# @  scr @ block  +
 b/blk r# @ - (search 0=
 IF  0  ELSE  scr @ block -  THEN
 r# !  r#>at ;

| : esearch  ( -- f)
 eupdate drop  >bufs
 BEGIN BEGIN  (f  r# @
       WHILE  key  dup Ascii r =
              IF replace ?dup
                 IF nip exit THEN THEN
              3 = ?dup ?exit
       REPEAT  drvScr nip send @ -
       stop? 0= and ?dup
 WHILE 0< IF   next drop
          ELSE back drop THEN
 REPEAT true ;





\ Block No. 37
\ Edi keytable               clv2:jull87
| : Ctrl  ( -- 8b)
 [compile] Ascii $40 - ; immediate
| Create keytable
Ctrl n c, Ctrl b c, Ctrl w c, Ctrl a c,
$1F c, (64 Ctrl ^ C)      (16 $92 C) c,
$0D c,   $8D c,
Ctrl c c, Ctrl x c, Ctrl f c, Ctrl l c,
$85 c,   $89 c,    $86 c,    $8A c,
$9F c,   $1C c, (64 00 C) (16 $1e C) c,
$8B c,   $87 c,    $88 c,    $8C c,
$1D c,   $11 c,    $9D c,    $91 c,
$13 c,   $93 c,    $94 c,
$14 c,    Ctrl d c, Ctrl e c, Ctrl r c,
Ctrl i c, Ctrl o c,
                             $ff c,









\ Block No. 38
( Edi actiontable             clv9.4.87)


| Create actiontable ]
next      back      >shadow   alter
esearch   copyline
<cr>      <cr>
cancel    eupdate   esave     eload
newline   killine   buf>line  line>buf
.stamp    .scr#           copychar
char>buf  buf>char  +tab      -tab
currite   curdown   curleft   curup
home      >""end    insert
delete    dchar     clrline   clrright
setimd    clrimd
                              dochar  [
| Code findkey  ( key n -- adr)
 2 # lda  setup jsr  N ldy  dey
 [[  iny  keytable ,Y lda  $FF # cmp
     0<> ?[  N 2+ cmp  ]?  0= ?]
 tya  .A asl  tay
 actiontable    ,Y lda  pha
 actiontable 1+ ,Y lda  Push jmp
end-code

\ Block No. 39
( Edi show errors            clv21.3.87)


' 0   | Alias dark

' 1   | Alias light

| : half  ( n --)
 border c!  pause $80 0 DO LOOP ;

| : blink ( --)
 border push  dark half light half
              dark half light half ;

| : ?blink ( f1 -- f2)
 dup true = IF  blink 0=  THEN ;









\ Block No. 40
( Edi init                    18jun85re)

' Literal | Alias Li  immediate

Variable (pad       0 (pad !

| : clearbuffer  ( --)
 pad       dup  (pad  !
 #col 2* + dup  fbuf  2+ !
 #col    + dup  rbuf  2+ !
 #col    + dup  chars !
 #col 2* +      lines !
 chars 2+ off  lines 2+ off
 [ ' ***ultraFORTH83*** >name ] Li
 count >r fbuf 2+ @ r@ cmove r> fbuf !
 [ ' Forth-Gesellschaft >name ] Li
 count $1F and >r
 rbuf 2+ @ r@ cmove r> rbuf ! ;

| : initptr ( --)
 pad (pad @ = ?exit clearbuffer ;




\ Block No. 41
\ Edi show                    clv15jul87

' name >body 6 +  | Constant 'name
(16 \ c16 benutzt standard C)

(64
| Code curon
 $D3 ldy    $D1 )Y lda  $CE sta
 $80 # eor  $D1 )Y sta
 xyNext jmp  end-code

| Code curoff
 $CE lda  $D3 ldy  $D1 )Y sta
 xyNext jmp  end-code

C)









\ Block No. 42
( Edi show                    17jun85re)

| : showoff
 ['] exit 'name !  rvsoff  curoff ;

| : show  ( --)
 blk @ ?dup 0= IF  showoff exit  THEN
 >in @ 1-  r# !  rvsoff curoff rvson
 scr @  over - IF  scr !  elist
 1 0 at .status THEN r#>at curon drop ;

Forth definitions

: (load  ( blk pos --)
 >in push  >in !  ?dup 0= ?exit
 blk push  blk !  .status interpret ;

: showload  ( blk pos -)
 scr push  scr off  r# push
 ['] show 'name ! (load showoff ;

Editor definitions



\ Block No. 43
\ Edi edit                    clv01aug87
| : setcol ( 0 / 4 / 8 --)
 ink-pot +
 dup c@ border c! dup 1+ c@ bkgrnd c!
  2+ c@ pen c! ;
| : (edit  ( -- n)
 4 setcol $93 con!
 elist drop  scroll off
 BEGIN key dup char c!
   0 findkey execute ?blink ?dup UNTIL
 0 0 at killine drop  scroll on
 0 setcol (16 0 $7ea c! C) \ Append-Mode
;
Forth definitions
: edit ( scr# -) (16 c64fkeys C)
 scr !  stamp?  initptr  (edit
 $18 0 at  drvScr ." Scr " . ." Drv " .
 dup 2 and 0=  IF ." not "     THEN
                  ." changed"
 dup 4 and     IF save-buffers THEN
 dup 6 and 6 = IF ." , saved"  THEN
     8 and     IF ." , loading" cr
       scr @  r# @  showload   THEN ;


\ Block No. 44
\ Editor Forth83             clv2:jull87

: l  ( scr -)   r# off  edit ;
: r  ( -)       scr @ edit ;
: +l ( n -)     scr @ + l ;

: v  ( -) ( text)
 '  >name  ?dup IF  4 - @  THEN  ;

: view  ( -) ( text)
 v ?dup
 IF  l  ELSE  ." from keyboard"  THEN ;

Editor definitions

(16 | : curaddr \ --Addr
     linptr @ curofs c@ + ; C)

: curlin  ( --curAddr linLen) \ & EOLn
(64 linptr @ $D5 c@ -trailing
     dup $d3 c! C)
(16 $1b con! ascii j con! curaddr
    $1b con! ascii k con! $1d con!
     curaddr  over - C) ;

\ Block No. 45
( Edidecode                  clv26.3.87)

: edidecode  ( adr cnt1 key -- adr cnt2)
 $8D case? IF  imode off cr exit  THEN
 #cr case? IF  imode off
curlin dup span @ u> IF drop span @ THEN
  bounds ?DO
  2dup +  I c@ scr>cbm  swap c!  1+ LOOP
  dup span !  exit  THEN
 dup char c!
 $12 findkey execute ?blink drop ;


: ediexpect ( addr len1 -- )
 initptr  span !
 0 BEGIN  dup span @  u<
   WHILE  key decode  REPEAT
 2drop space ;

Input: ediboard
 c64key c64key? edidecode ediexpect ;

ediboard


\ Block No. 46
( .status                     15jun85re)

' noop Is .status

: .blk  ( -)
 blk @ ?dup IF  ."  Blk " u. ?cr  THEN ;

' .blk Is .status

















\ Block No. 47
\ tracer: loadscreen          clv12oct87

Onlyforth

\needs Code -$2B +load \ Trans Assembler

\needs Tools   Vocabulary Tools

Tools also definitions

   1 6  +thru  \ Tracer
   7 8  +thru  \ Tools for decompiling

Onlyforth

\\

Dieser wundervolle Tracer wurde
von Bernd Pennemann und Co fuer
den Atari entwickelt. Ich liess mir
aufschwatzen, ihn an C64/C16 anzupassen
und muss sagen, es ging erstaunlich
einfach. /clv


\ Block No. 48
\ tracer: wcmp variables      clv04aug87

Assembler also definitions

: wcmp ( adr1 adr2--) \ Assembler-Macro
 over lda dup cmp swap  \ compares word
 1+   lda 1+  sbc ;


Only Forth also Tools also definitions

| Variable (W
| Variable <ip      | Variable ip>
| Variable nest?    | Variable trap?
| Variable last'    | Variable #spaces










\ Block No. 49
\ tracer:cpush oneline        clv12oct87

| Create cpull    0  ]
 rp@ count 2dup + rp! r> swap cmove ;

: cpush  ( addr len -)
 r> -rot   over  >r
 rp@ over 1+ - dup rp!  place
 cpull >r  >r ;

| : oneline  &82 allot keyboard display
 .status  space  query  interpret
 -&82 allot  rdrop
 ( delete quit from tnext )  ;

: range ( adr--) \ ermittelt <ip ip>
 ip> off  dup <ip !
 BEGIN 1+ dup @
   [ Forth ] ['] unnest = UNTIL
 3+ ip> ! ;





\ Block No. 50
\ tracer:step tnext           clv04aug87

| Code step
 $ff # lda trap? sta trap? 1+ sta
           RP X) lda  IP sta
 RP )Y lda  IP 1+ sta  RP 2inc
 (W lda  W sta   (W 1+ lda   W 1+ sta
Label W1-  W 1- jmp  end-code

| Create: nextstep step ;

Label  tnext IP 2inc
 trap? lda  W1- beq
 nest? lda 0=  \ low(!)Byte test
 ?[ IP <ip wcmp W1- bcc
    IP ip> wcmp W1- bcs
 ][ nest? stx  \ low(!)Byte clear
 ]?
  trap? dup stx 1+ stx \ disable tracer
  W lda  (W sta    W 1+ lda   (W 1+ sta





\ Block No. 51
\ tracer:..tnext              clv12oct87

 ;c: nest? @
 IF nest? off r> ip> push <ip push
    dup 2- range
    #spaces push 1 #spaces +! >r THEN
 r@  nextstep >r
 input push    output push
 2- dup last' !
 cr #spaces @ spaces
 dup 4 u.r @ dup 5 u.r space
 >name .name  $10 col - 0 max spaces .s
 state push  blk push  >in push
 [ ' 'quit      >body ] Literal  push
 [ ' >interpret >body ] Literal  push
 #tib push  tib #tib @ cpush  r0 push
 rp@ r0 !
 ['] oneline Is 'quit  quit ;







\ Block No. 52
\ tracer:do-trace traceable   clv12oct87

| Code do-trace \ installs TNEXT
 tnext 0 $100 m/mod
     # lda  Next $c + sta
     # lda  Next $b + sta
 $4C # lda  Next $a + sta  Next jmp
end-code

| : traceable ( cfa--<IP ) recursive
 dup @
 ['] :    @ case? IF >body     exit THEN
 ['] key  @ case? IF >body c@ Input  @ +
                   @ traceable exit THEN
 ['] type @ case? IF >body c@ Output @ +
                   @ traceable exit THEN
 ['] r/w  @ case? IF >body
                   @ traceable exit THEN
 @  [ ' Forth @ @ ] Literal =
                  IF @ 3 + exit THEN
 \ fuer def.Worte mit does>
 >name .name ." can't be DEBUGged"
 quit ;


\ Block No. 53
\ tracer:Benutzer/innen-Worte clv12oct87

: nest   \ trace into current word
 last' @ @ traceable drop nest? on ;

: unnest \ proceeds at calling word
 <ip on ip> off ; \ clears trap range

: endloop last' @ 4 + <ip ! ;
\ no trace of next word to skip LOOP..

' end-trace Alias unbug \ cont. execut.

: (debug  ( cfa-- )
 traceable range
 nest? off trap? on #spaces off
 Tools do-trace ;

Forth definitions

: debug  ' (debug ; \ word follows

: trace'            \ word follows
 ' dup (debug execute end-trace ;

\ Block No. 54
\ tools for decompiling,      clv12oct87

( interactive use                      )

Onlyforth Tools also definitions

| : ?:  ?cr dup 4 u.r ." :"  ;
| : @?  dup @ 6 u.r ;
| : c?  dup c@ 3 .r ;
| : bl  $24 col - 0 max spaces ;

: s  ( adr - adr+)
 ( print literal string)
 ?:  space c? 4 spaces dup count type
 dup c@ + 1+ bl  ;  ( count + re)

: n  ( adr - adr+2)
 ( print name of next word by its cfa)
 ?: @? 2 spaces
 dup @ >name .name 2+ bl ;

: k  ( adr - adr+2)
 ( print literal value)
 ?: @? 2+ bl ;

\ Block No. 55
( tools for decompiling, interactive   )

: d  ( adr n - adr+n) ( dump n bytes)
 2dup swap ?: 3 spaces  swap 0
 DO  c? 1+ LOOP
 4 spaces -rot type bl ;

: c  ( adr - adr+1)
 ( print byte as unsigned value)
 1 d ;

: b  ( adr - adr+2)
 ( print branch target location )
 ?: @? dup @  over + 6 u.r 2+ bl  ;

( used for : )
( Name String Literal Dump Clit Branch )
( -    -      -       -    -    -      )







\ Block No. 56
( debugging utilities      bp 19 02 85 )


: unravel   \  unravel perform (abort"
 rdrop rdrop rdrop
 cr ." trace dump is "  cr
 BEGIN  rp@   r0 @ -
 WHILE   r>  dup  8 u.r  space
         2- @  >name .name  cr
 REPEAT (error ;

' unravel errorhandler !













\ Block No. 57
\ Multitasker               BP 13.9.84 )

Onlyforth

\needs multitask  1 +load  save

  2  4 +thru        \ Tasker
\    5 +load        \ Demotask

















\ Block No. 58
\ Multitasker               BP 13.9.84 )

\needs Code -$36 +load  \ transient Ass

Code stop
 SP 2dec  IP    lda  SP X) sta
          IP 1+ lda  SP )Y sta
 SP 2dec  RP    lda  SP X) sta
          RP 1+ lda  SP )Y sta
 6 # ldy  SP    lda  UP )Y sta
     iny  SP 1+ lda  UP )Y sta
 1 # ldy  tya  clc  UP adc  W sta
 txa  UP 1+ adc  W 1+ sta
 W 1- jmp   end-code

| Create taskpause   Assembler
 $2C # lda  UP X) sta  ' stop @ jmp
end-code

: singletask
 [ ' pause @ ] Literal  ['] pause ! ;

: multitask   taskpause ['] pause ! ;


\ Block No. 59
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

\ Block No. 60
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


\ Block No. 61
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




\ Block No. 62
\ Taskdemo                    clv12aug87

: taskmark ; \needs cbm>scr : cbm>scr ;

: scrstart  ( -- adr)
  (64 $288 C) (16 $53e C) c@ $100 * ;

Variable counter  counter off

$100 $100 Task Background

: >count  ( n -)
 Background 1 pass
 counter !
 BEGIN  counter @  -1 counter +! ?dup
 WHILE  pause 0 <# #s #>
  0 DO  pause  dup I + c@  cbm>scr
        scrstart I +  c!  LOOP  drop
 REPEAT
 BEGIN stop REPEAT ; \ stop's forever
: wait  Background sleep ;
: go    Background wake ;

multitask       $100 >count  page

\ Block No. 63
\ printer loadscreen          27jul85re)

Onlyforth hex

Vocabulary Print
Print definitions also

Create Prter 2 allot  ( Semaphor)
Prter off

  : ) ; immediate
  : (u ; immediate  \ for user-port
  : (s  [compile] ( ; immediate
\ : (s ; immediate  \ for serial bus
\ : (u  [compile] ( ; immediate

(s  1 +load )

 2 $A +thru

Onlyforth

clear


\ Block No. 64
\ Buffer for the ugly SerBus  28jul85re)

$100 | Constant buflen

| Variable Prbuf  buflen allot Prbuf off

| : >buf  ( char --)
 Prbuf count + c!  1 Prbuf +! ;

| : full?  ( -- f)   Prbuf c@ buflen = ;

| : .buf  ( --)
 Prbuf count -trailing
 4 0 busout bustype busoff Prbuf off ;

: p!  ( char --)
 pause  >r
 r@ $C ( Formfeed  ) =
 IF  r> >buf .buf exit  THEN
 r@ $A ( Linefeed  ) =
 r@ $D ( CarReturn ) = or  full? or
 IF  .buf  THEN  r> >buf ;



\ Block No. 65
\ p! ctrl: ESC esc:           28jul85re)

(u
: p!  \ char --
 $DD01 c!  $DD00 dup c@ 2dup
 4 or swap c!  $FB and swap c!
  BEGIN  pause  $DD0D c@ $10 and
  UNTIL ;  )

| : ctrl:  ( 8b --)   Create c,
  does>  ( --)   c@ p! ;

   7 ctrl: BEL    | $7F ctrl: DEL
| $d ctrl: CRET   | $1B ctrl: ESC
  $a ctrl: LF       $0C ctrl: FF

| : esc:   ( 8b --)   Create c,
  does>  ( --)   ESC c@ p! ;

 $30 esc: 1/8"       $31 esc: 1/10"
 $32 esc: 1/6"
 $54 esc: suoff
 $4E esc: +jump      $4F esc: -jump


\ Block No. 66
\ printer controls            28jul85re)

| : ESC2   ESC  p! p! ;

  : gorlitz  ( 8b --)   BL ESC2 ;

| : ESC"!"  ( 8b --)   $21 ESC2 ;

| Variable Modus  Modus off

| : on:  ( 8b --)  Create c,
  does>  ( --)
  c@ Modus c@ or dup Modus c! ESC"!" ;

| : off:  ( 8b --)   Create $FF xor c,
  does>  ( --)
  c@ Modus c@ and dup Modus c! ESC"!" ;

 $10 on: +dark    $10 off: -dark
 $20 on: +wide    $20 off: -wide
 $40 on: +cursiv  $40 off: -cursiv
 $80 on: +under   $80 off: -under
|  1 on: (12cpi
|  4 on: (17cpi     5 off: 10cpi

\ Block No. 67
\ printer controls            28jul85re)

: 12cpi   10cpi (12cpi ;
: 17cpi   10cpi (17cpi ;
: super   0 $53 ESC2 ;
: sub     1 $53 ESC2 ;
: lines  ( #lines --)  $43 ESC2 ;
: "long  ( inches --)   0 lines p! ;
: american   0 $52 ESC2 ;
: german     2 $52 ESC2 ;

: prinit
(s  Ascii x gorlitz  Ascii b gorlitz
    Ascii e gorlitz  Ascii t gorlitz
    Ascii z gorlitz  Ascii l gorlitz )
(u  $FF $DD03 c!
    $DD02 dup c@  4 or swap c! ) ;

| Variable >ascii  >ascii on

: normal   >ascii on
  Modus off  10cpi  american  suoff
  1/6"  $c "long  CRET ;


\ Block No. 68
\ Epson printer interface     08sep85re)

| : c>a  ( 8b0 -- 8b1)
 >ascii @ IF
dup $41 $5B uwithin IF $20 or  exit THEN
dup $C1 $DB uwithin IF $7F and exit THEN
dup $DC $E0 uwithin IF $A0 xor THEN
 THEN ;

| Variable pcol  pcol off
| Variable prow  prow off

| : pemit  c>a p!  1 pcol +! ;
| : pcr   CRET LF  1 prow +!  0 pcol ! ;
| : pdel   DEL  -1 pcol +! ;
| : ppage  FF  0 prow !  0 pcol ! ;
| : pat    ( zeile spalte -- )
  over   prow @ < IF  ppage  THEN
  swap prow @ - 0 ?DO pcr LOOP
  dup  pcol < IF  CRET  pcol off  THEN
  pcol @ - spaces ;
| : pat?   prow @  pcol @ ;
| : ptype  ( adr count --)  dup pcol +!
 bounds ?DO  I c@ c>a p!  LOOP ;

\ Block No. 69
\ print  pl                    02oct87re

| Output: >printer
 pemit pcr ptype pdel ppage pat pat? ;


: bemit   dup  c64emit  pemit ;
: bcr          c64cr    pcr   ;
: btype   2dup c64type  ptype ;
: bdel         c64del   pdel  ;
: bpage        c64page  ppage ;
: bat     2dup c64at    pat   ;

| Output: >both
 bemit bcr btype bdel bpage bat pat? ;

Forth definitions

: Printer
  normal  (u prinit )  >printer ;
: Both
  normal  >both ;



\ Block No. 70
\ 2scr's nscr's thru      ks  28jul85re)

Forth definitions

| : 2scr's  ( blk1 blk2 --)
 cr LF  17cpi  +wide +dark $15 spaces
 over 3 .r $13 spaces dup 3 .r
 -dark -wide cr  b/blk 0 DO
  cr I c/l / $15 .r  4 spaces
  over block I +  C/L 1- type  5 spaces
  dup  block I +  C/L 1- -trailing type
 C/L +LOOP  2drop  cr ;

| : nscr's  ( blk1 n -- blk2)   2dup
 bounds DO I  over I + 2scr's LOOP + ;

: pthru  ( from to --)
 Prter lock  Output push Printer  1/8"
 1+ over - 1+ -2 and 6 /mod
 ?dup IF swap >r
 0 DO 3 nscr's 2+ 1+ page LOOP  r> THEN
 ?dup IF 1+ 2/ nscr's page THEN drop
 Prter unlock ;


\ Block No. 71
\ Printing with shadows       28jul85re)

Forth definitions

| : 2scr's  ( blk1 blk2 --)
 cr LF  17cpi  +wide +dark $15 spaces
 dup  3 .r
 -dark -wide cr  b/blk 0 DO
  cr I c/l / $15 .r  4 spaces
  dup  block I +  C/L 1- type  5 spaces
  over block I +  C/L 1- -trailing type
 C/L +LOOP  2drop  cr ;

| : nscr's  ( blk1 n -- blk2)
 0 DO dup [ Editor ]  shadow @   2dup
 u> IF negate THEN
 + over 2scr's 1+ LOOP ;

: dokument  ( from to --)
 Prter lock  Output push  Printer
 1/8"  1+ over - 3 /mod
 ?dup IF swap >r
 0 DO 3 nscr's page LOOP  r> THEN
 ?dup IF nscr's page THEN drop
 Prter unlock ;
\ Block No. 72
\ 2scr's nscr's thru      ks  28jul85re)

Forth definitions  $40 | Constant C/L

| : 2scr's  ( blk1 blk2 --)
 pcr LF LF 10cpi +dark  $12 spaces
 over 3 .r  $20 spaces dup 3 .r
 cr 17cpi -dark
 $10 C/L * 0 DO cr over block I + C/L
 6 spaces type 2 spaces
 dup block I + C/L -trailing type
 C/L  +LOOP  2drop cr ;

| : nscr's ( blk1 n -- blk2)   under 0
 DO 2dup dup rot + 2scr's 1+ LOOP nip ;

: 64pthru  ( from to --)
 Prter lock  >ascii push  >ascii off
 Output push  Printer
 1/6" 1+ over - 1+ -2  and 6 /mod
 ?dup IF swap >r
 0 DO 3 nscr's 2+ 1+ page LOOP  r> THEN
 ?dup IF 1+ 2/ nscr's page THEN drop
 Prter unlock  ;

\ Block No. 73
\ pfindex                      02oct87re

Onlyforth Print also

: pfindex  ( from to --)
 Prter lock  Printer  &12 "long
 +jump  findex  cr page  -jump
 Prter unlock  display  ;

















\ Block No. 74
\ Printspool                   02oct87re

\needs tasks  .( Tasker?!) \\

$100 $100 Task Printspool

: spool  ( from to --)
 Printspool 2 pass

 pthru
 stop ;

: endspool  ( --)
 Printspool activate
 stop ;










\ Block No. 75
\ Printer Routinen 1526       clv14oct87

( Nicht geeignet fuer Printspool!!   re)

Onlyforth  Vocabulary Print

Print also Definitions

: prinit   4 7 busout ( drop ) ;
\needs FF  : FF noop ;
: CRET     $d bus! ;

: pspaces  ( n -)
  0 ?DO  BL bus! LOOP ;

1 2 +thru

Only Forth also Definitions

( save )





\ Block No. 76
\ Printer interface 1526       02oct87re

Variable Pcol   Variable Prow

| : pemit  bus!    1 Pcol +! ;
| : pcr    CRET    1 Prow +!  0 Pcol ! ;
| : pdel   ;
| : ppage  FF  0 Prow !  0 Pcol ! ;
| : pat    ( zeile spalte -- )
  over   Prow @ < IF  ppage  THEN
  0 rot  Prow @ - bounds ?DO pcr LOOP
  dup  Pcol @ - pspaces  Pcol ! ;
| : pat?   Prow @  Pcol @ ;
| : ptype  ( adr count -)  dup Pcol +!
 bounds ?DO  I c@ bus! LOOP ;

| Output: >printer
 pemit pcr ptype pdel ppage pat pat? ;

Forth definitions

: printer   prinit >printer ;

: display   cr busoff display ;

\ Block No. 77
\ printer routinen             20oct87re

Only Forth also definitions

4 Constant B/scr

: .line  ( line# scr# --)
  block swap c/l * + c/l 1- type ;

: .===
 c/l 1- 0 DO  Ascii = emit  LOOP ;

: prlist ( scr# --)
 dup block drop    printer
 $E emit ." Screen Nr. " dup . $14 emit
 cr .===
 l/s 0 DO I over .line cr LOOP drop
 .=== cr cr cr  display ;







\ Block No. 78
\ CP-80 Printer loadscreen    clv14oct87

Onlyforth hex

Vocabulary Print  Print definitions also

Create Prter 2 allot  ( Semaphor)

0 Prter !   \ Prter unlock /clv

1 6 +thru

Only Forth also definitions

(  clear   )










\ Block No. 79
\ p! ctrl: ESC esc:         07may85mawe)

Print definitions

: p!  ( 8b -)
 BEGIN  pause  $DD0D c@  $10 and  UNTIL
 $DD01 c! ;

| : ctrl:  ( B -)   Create c,
  does>  ( -)   c@ p! ;

   07 ctrl: BEL    | $7F ctrl: DEL
| $0D ctrl: CRET   | $1B ctrl: ESC
  $0A ctrl: LF       $0C ctrl: FF

| : esc:   ( B -)   Create c,
  does>  ( -)   ESC c@ p! ;

 $30 esc: 1/8"       $31 esc: 1/10"
 $32 esc: 1/6"       $20 esc: gorlitz

| : ESC2   ESC  p! p! ;



\ Block No. 80
( printer controls          07may85mawe)

 $0e esc: +wide  $14 esc: -wide
 $45 esc: +dark  $46 esc: -dark
 $47 esc: +dub   $48 esc: -dub
 $0f esc: +comp  $12 esc: -comp

: +under 1 $2D esc2 ;
: -under 0 $2D esc2 ;
















\ Block No. 81
( printer controls          07may85mawe)

  $54 esc: suoff

: super   0 $53 ESC2 ;

: sub     1 $53 ESC2 ;

: lines  ( lines -)   $43 ESC2 ;

: "long  ( inches -)   0 lines p! ;

: american   0 $52 ESC2 ;

: german     2 $52 ESC2 ;

: pspaces  ( n -)
  0 swap bounds ?DO  BL p!  LOOP ;

| : initport  0 $DD01 c! $FF $DD03 c! ;

: prinit   initport
  american  suoff  1/6"
  &12 "long  CRET ;

\ Block No. 82
( CP80  printer interface     26mar85re)

| Variable unchanged?  unchanged? off

| : c>a  ( 8b0 - 8b1)
 unchanged? @ ?exit
 dup $41 $5B uwithin
                IF  $20 or  exit THEN
 dup $C1 $DB uwithin
                IF  $7F and exit THEN
 dup $DC $E0 uwithin
                IF  $A0 xor      THEN ;













\ Block No. 83
( print  pl                   06may85we)

Variable Pcol   Variable Prow

| : pemit  c>a p!  1 Pcol +! ;
| : pcr    CRET    1 Prow +!  0 Pcol ! ;
| : pdel   DEL  -1 Pcol +! ;
| : ppage  FF  0 Prow !  0 Pcol ! ;
| : pat    ( zeile spalte -- )
  over   Prow @ < IF  ppage  THEN
  0 rot  Prow @ - bounds ?DO pcr LOOP
  dup  Pcol @ - pspaces  Pcol ! ;
| : pat?   Prow @  Pcol @ ;
| : ptype  ( adr count -)  dup Pcol +!
 bounds ?DO  I c@ c>a p!  LOOP ;

| Output: >printer
 pemit pcr ptype pdel ppage pat pat? ;

Forth definitions

: Printer   prinit  >printer ;



\ Block No. 84
( 3scr's nscr's thru      ks07may85mawe)
Forth definitions

| : 3scr's  ( blk  -)
 cr  -comp +dark
  $B spaces dup    3 .r
 $19 spaces dup 1+ 3 .r
 $19 spaces dup 2+ 3 .r
 cr  +comp  -dark  L/S C/L *  0 DO
  cr 5 spaces dup  block I + C/L 1- type
   8 spaces dup 1+ block I + C/L 1- type
   8 spaces dup 2+ block I + C/L 1- type
 C/L +LOOP  drop  cr LF ;

| : nscr's ( blk1 n - blk2)  under 0
 DO dup 3scr's over + LOOP nip ;

: pthru  ( from to -)
 Output @ -rot  Printer Prter lock 1/8"
 1+ over - 1+ 9 /mod
 ?dup IF swap >r
 0 DO 3 nscr's  page LOOP  r> THEN
 ?dup IF 1- 3 / 1+ 0
   DO dup 3scr's 3 + LOOP  THEN drop
 Prter unlock  Output ! ;
\ Block No. 85

























\ Block No. 86

























\ Block No. 87
\\ zu LongJsr fuer C16        clv08aug87


Das Speichermodell:

$0000 - $8000 : LowRAM
$8000 - $ffff : HighRAM  & ROM

Auf ROM schalten   Auf RAM schalten
sys kann wie jsr beutzt werden


ein ROM-Ruf der Art '0ffd2 sys'

 rom jsr ram  == $ff3e sta jsr $ff3f sta

das geht natuerlich nicht, wenn
HERE groesse $8000 ist. Warum wohl?

--- Beim c64 Lassen sich Basic und
 Betriebssystem getrennt schalten.
 Diese Makros sind nur fuer das
 Basic-Rom noetig.


\ Block No. 88
\\ zu LongJsr fuer C16      clv20aug87re

ACHTUNG! bei falscher Benutzung
         Systemabsturz


das Makro muss immer unter $8000 liegen

ein Aufruf der Form ' $ffd2 sysMacro'
gibt:
   pha
   $ff # lda  LONG1 2+ sta
   $d2 # lda  LONG1 1+ sta
   pla  LONG jsr
so hat mittels Umleitung doch noch der
Sprung ins drueberliegende ROM geklappt

sys entscheidet nun selbst, ob Umleitung
oder nicht.

ACHTUNG! DAS ZERO-Flag wird zerstoert!




\ Block No. 89
( transient Forth-6502 Assemclv20aug87re
( Basis: Forth Dimensions VOL III No. 5)

Der Assembler wird komplett auf den
Heap geladen und ist so nur bis zum
naechsten 'clear' oder 'save' benutzbar,
danach ist er komplett aus dem Speicher
entfernt. Er ist dann zwar nicht mehr
zu benutzen, aber er belegt auch nicht
unnoetig Speicherplatz.















\ Block No. 90

























\ Block No. 91

























\ Block No. 92

























\ Block No. 93

























\ Block No. 94

























\ Block No. 95

























\ Block No. 96

























\ Block No. 97

























\ Block No. 98
\ frei                         20oct87re
























\ Block No. 99

























\ Block No. 100

























\ Block No. 101

























\ Block No. 102

























\ Block No. 103

























\ Block No. 104

























\ Block No. 105

























\ Block No. 106

























\ Block No. 107

























\ Block No. 108

























\ Block No. 109

























\ Block No. 110

























\ Block No. 111

























\ Block No. 112

























\ Block No. 113

























\ Block No. 114

























\ Block No. 115

























\ Block No. 116

























\ Block No. 117

























\ Block No. 118

























\ Block No. 119

























\ Block No. 120

























\ Block No. 121

























\ Block No. 122

























\ Block No. 123

























\ Block No. 124

























\ Block No. 125

























\ Block No. 126

























\ Block No. 127

























\ Block No. 128

























\ Block No. 129

























\ Block No. 130

























\ Block No. 131

























\ Block No. 132
\\ zu tracer:loadscreen       clv12oct87


***Fuer die naechste u4th-Version****

Falls jemand mal die <IP IP>-Sache
ordnet und mit Atari vereinheitlicht,
hier ein paar kritische
Beispiele zum Testen:

| : aa dup drop ;
| : bb aa ;
\\
debug bb
trace' aa

trace' Forth



Mein Verdacht: Das IP 2inc findet bei
CBM/Atari vorher bzw. nachher statt.



\ Block No. 133
\\ zu tracer:wcmp variables   clv04aug87



benutzt in der Form: adr1 adr2 wcmp
vergleicht das ganze Wort. Danach
ist: Carry=1  : (adr1) >= (adr2)
     Carry=0  : (adr1) <  (adr2)
mit den andern Flags ist nix anzufangen


Temporaer Speicher fuer W
Bereich, in dem getraced werden soll
Flag: ins Wort rein  Flag: trace ja/nein
hab ich vergessen    Schachtelungstiefe










\ Block No. 134
\ zu tracer:cpush oneline     clv04aug87




sichert LEN bytes ab ADDR auf dem
Return-Stack. Das naechste UNNEST
oder EXIT tut sie wieder zurueck


die neue Hauptbefehlsschleife.
Ermoeglicht die Eingabe einer Zeile.



ermittelt den zu tracenden Bereich









\ Block No. 135
\ zu tracer:step tnext        clv04aug87

wird am Ende von TNEXT aufgerufen,
 um TRAP? wieder einzuschalten und
 die angeschlagene NEXT-Routine
 wieder zu reparieren.




Diese Routine wird auf die NEXT-Routine
gepatched und ist das Kernstueck.
 Wenn nicht getraced wird: ab
 Ins aktuelle Wort rein?
    nein: ist IP im debug-Bereich?
          nein: dann ab
    ja:   dann halb(!) loeschen

 trap? ausschalten ( der Tracer soll
 sich schliesslich nicht selbst tracen,
 wo kommen wir denn da hin!)




\ Block No. 136
\ tracer:..tnext              clv04aug87

Forth-Teil von TNEXT
 ins aktuelle Wort rein?
    ja: Debug-Bereich pushen, neuen
        Schachtelungstiefe incr.
 STEP soll nachher ausgefuehrt werden
 PUSHed alle wichtige Sachen

 gibt eine Informationszeile aus



 PUSHed nochmehr Zeug

 PUSHed den Return-Stack-Pointer !!
 und tut so, als waer der RStack leer
 Haengt ONELINE in die
 Haupt-Befehls-Schleife und ruft sie auf






\ Block No. 137
\ zu tracer:do-trace traceableclv12oct87

installiert (patched) TNEXT in NEXT
 (NEXT ist die innerste Routine,
  zu der jedes Wort zurueckkehrt)




guckt, ob Wort getraced werden kann
  und welche adr dazugehoert
 :      -def.  <IP=cfa+2
 INPUT: -def.  <IP aus input-Vektor

 OUTPUT:-def.  <IP aus output-Vektor

 DEFER  -def.  <IP aus [cfa+2]

 DOES>  -def.  <IP=[cfa]+3

 alle anderen Definitionen gehen nicht




\ Block No. 138
\ zu tracer:Benutzer-Worte    clv12oct87

NEST erlaubt das Hineinsteigen in
     ein getracedes Worte

UNNEST fuehrt das Wort zuende und
     traced dann wieder.

ENDLOOP traced erst hinterm naechsten
     Wort wieder (z.B. bei LOOPs)

UNBUG schaltet jegliches getrace ab.






DEBUG <word> setzt den zu tracenden
     Bereich. Wenn <word> anschliessend
     ausgefuehrt wird, meldet sich der
     Tracer.

TRACE' fuehrt <word> gleich noch aus.

\ Block No. 139
\\ zu tools for decompil  01oct87clv/re)

\ Wenn zum Beispiel das Wort


: test 5   0   DO    ." magst Du mich ?"
    key Ascii j =
    IF   ." selber schuld " leave
    ELSE ." Aber bestimmt " THEN LOOP
  ." !" ;

\\ beguckt werden soll, dann gehts so:


  bitte umblaettern..>










\ Block No. 140
\  zu tools for decompil  01occlv10oct87

cr
tools
' test
k      n c n   n b   n s
    n   n     c n
    n b  n   s              n
    n b    n   s                   n b
  n s   n















\ Block No. 141

























\ Block No. 142

























\ Block No. 143

























\ Block No. 144

























\ Block No. 145

























\ Block No. 146

























\ Block No. 147

























\ Block No. 148


setzt order auf FORTH FORTH ONLY   FORTH




fuer multitasking



Centronics-Schnittstelle ueber User-Port
(s Text bis ) wird ueberlesen
serielle Schnittstelle (wegkommentiert)
(u Text bis ) wird ueberlesen

lade den naechsten Screen nur fuer
     seriellen Bus




unbrauchbare Koepfe weg


\ Block No. 149
Beim seriellen Bus ist die Ausgabe jedes
einzelnen Zeichens zu langsam


Buffer fuer Zeichen zum Drucker

ein Zeichen zum Buffer hinzufuegen


Buffer voll?

Buffer ausdrucken und leeren



Hauptausgaberoutine fuer seriellen Bus
Zeichen merken
ist es ein Formfeed?
  ja, Buffer ausdrucken incl. Formfeed
ist es ein Linefeed?
oder ein CR oder ist der Buffer voll?
  ja, Buffer ausdrucken, CR/LF merken



\ Block No. 150



Hauptausgaberoutine fuer Centronics
Zeichen auf Port  , Strobe-Flanke
        ausgeben
wartet bis Busy-Signal zurueckgenommen
wird

gibt Steuerzeichen an Drucker


Steuerzeichen fuer den Drucker
in hexadezimaler Darstellung
gegebenenfalls anpassen !

gibt Escape-Sequenzen an Drucker


Zeilenabstand in Zoll

Superscript und Subscript ausschalten
Perforation ueberspringen ein/aus


\ Block No. 151


Escape + 2 Zeichen

 nur fuer Goerlitz-Interface

spezieller Epson-Steuermodus

  Kopie des Drucker-Steuer-Registers

schaltet Bit in Steuer-Register ein



schaltet Bit in Steuer-Register aus



Diese Steuercodes muessen fuer andere
Drucker mit Hilfe von ctrl:, esc: und
ESC2 umgeschrieben werden

Zeichenbreite in characters per inch
eventuell durch Elite, Pica und Compress
ersetzen
\ Block No. 152


gegebenenfalls aendern



Aufruf z.B.mit 66 lines
Aufruf z.B mit 11 "long
Zeichensaetze, beliebig erweieterbar


Initialisierung ...
 . fuer Goerlitz-Interface


 . fuer Centronics:  Port B auf Ausgabe
            PA2 auf Ausgabe fuer Strobe

Flag fuer Zeichen-Umwandlung

schaltet Drucker mit Standardwerten ein




\ Block No. 153


wandelt Commodore's Special-Ascii in
ordinaeres ASCII






Routinen zur Druckerausgabe      Befehl

ein Zeichen auf Drucker          emit
CR und LF auf Drucker            cr
ein Zeichen loeschen (?!)        del
Formfeed ausgeben                page
Drucker auf zeile und spalte     at
positionieren, wenn noetig,
neue Seite


Position feststellen             at?
Zeichenkette ausgeben            type


\ Block No. 154


erzeugt die Ausgabetabelle >printer

Routinen fuer Drucker
und Bildschirm gleichzeitig (both)

Ausgabe erfolgt zuerst auf Bildschirm
( Routinen von DISPLAY )
dann auf Drucker
( Routinen von >PRINTER )



erzeugt die Ausgabetabelle >both


Worte sind von Forth aus zugaenglich

legt Ausgabe auf Drucker

legt Ausgabe auf Drucker und Bildschirm



\ Block No. 155




gibt 2 Screens nebeneinander aus
Screennummer in Fettschrift und 17cpi


formatierte Ausgabe der beiden Screens




gibt die Screens so aus:   1    3
                           2    4

gibt die Screens von from bis to aus
Ausgabegeraet merken und Printer ein
errechnet Druckposition der einzelnen
Screens und gibt sie nach obigem Muster
aus




\ Block No. 156




wie 2scr's (mit Shadow)








wie nscr's (mit Shadow)
                           screen Shadow
                           scr+1  Sh+1


wie pthru  (mit Shadow)






\ Block No. 157




Dasselbe nochmal fuer Standard-Forth
Screens mit 16 Zeilen zu 64 Zeichen







Siehe oben


Wie pthru fuer Standard-Screens








\ Block No. 158




Ein schnelles Index auf den Drucker
                      12" Papierlaenge
 Perforation ueberspringen


















\ Block No. 159
Drucken im Untergrund

Der Tasker wird gebraucht

Der Arbeitsbereich der Task wird erzeugt

Hintergrund-Druck ein
 von/bis werden an die Task gegeben
 beim naechsten PAUSE fuehrt die
 Task pthru aus und legt sich dann
 schlafen.

Hintergrund-Druck abbrechen
 die Task wird nur aktiviert,
 damit sie sich sofort wieder schlafen
 legt.









\ Block No. 160
\\ zu Printer interface 1526  clv14oct87

Dieser Treiber laueft auch mit:

 C16 & CITIZEN-100DM \ s.Handbuch


<--dieses DROP war doch wohl falsch /clv


FF : Die Formfeed-Definition fehlt
     hier. Wer's kann schreibe sie
     sich selber, wer's nicht kann,
     arbeite halt ohne Seiten-Vorschuebe











\ Block No. 161
                              clv14oct87
























\ Block No. 162

























\ Block No. 163

























\ Block No. 164

























\ Block No. 165

























\ Block No. 166

























\ Block No. 167

























\ Block No. 168

























\ Block No. 169

























