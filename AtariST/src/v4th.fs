
\ *** Block No. 1, Hexblock 1

\ Atari 520 ST    Forth loadscreen                     cas201301
\ volksFORTH-83 was developed by K. Schleisiek, B. Pennemann
\ G. Rehfeld & D. Weineck
\ Atari ST - Version by D. Weineck
\ Atari ST/STE/TT/Falcon/FireBee Version by C. Strotmann

Onlyforth

        0 dup displace !
Target definitions here!

 include vf-prghd.fs  \ Basepage (TOS PRG Header)

\ use forth83.fb

\   $83 load  \ Basepage (TOS PRG Header)
\ 2 $75 thru
 include vf-main.fs

Code restart      here >restart !
   ' (restart >body FP D) IP lea   bootsystem bra   end-code

\ $78 $82 thru        \ Atari 520 ST Interface
 include vf-sys.fs

include tinclude.fs  \ Bootstrap stream include

   
Host    ' Transient 8 + @  Transient Forth context @ 6 + !
\ Tlatest aus Transient wird Tlatest in Forth

Target Forth also definitions
: forth-83 ;     \ last word in Dictionary

\ $77 load  \ System patchup
\ include vf-patch.fs
\ vf-patch.fs contains the same code as block $77, yet replacing
\ load with include her crashes Forth.
\ In fact, including any file, even simple, even non-existing,
\ at htis point crashes Forth. To be investigated more.
\ include vf-hello2.fs

\ Temporary workaround: Inlining the code from vf-patch.fs works.
\ begin inlined vf-patch.fs

Forth definitions

$D3AA s0 !    $D7AA r0 !   \ gives &10 Buffers
s0 @ dup s0 2- !         6 + s0 8 - !
here dp !

Host  Tudp @         Target  udp !
Host  Tvoc-link @    Target  voc-link !
Host  Tnext-link @   Target  next-link !
Host  move-threads

\ end inlined vf-patch.fs

cr .( unresolved: )  .unresolved 
' .blk is .status

save-target v4th.prg

cr .( new kernel written as v4th.prg) cr
