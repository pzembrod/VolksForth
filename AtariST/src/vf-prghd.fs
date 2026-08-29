\ *** Block No. 131, Hexblock 83

\ Basepage (TOS PRG Header)                            cas201301

$601A ,                               \ BRA to start of PGM

here $1A allot   $1A erase            \ clear basepage info

Assembler

.l A7 A5 move   4 A5 D) A5 move       \ start basepage
   $1.0600 # D0 move   D0 D1 move     \ store size of forth and
   A5 D1 add   .w $FFFE D1 andi   .l D1 A7 move  \ stack
   D0 A7 -) move   A5 A7 -) move   .w A7 -) clr
   $4A # A7 -) move   1 trap   $0C # A7 adda   \ mshrink
   $100 $1C - # A5 adda   A5 FP lmove   \ FP to start of Forth
