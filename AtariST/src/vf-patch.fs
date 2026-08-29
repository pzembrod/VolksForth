\ *** Block No. 119, Hexblock 77

\ System patchup                                       14sep86we

Forth definitions

$D3AA s0 !    $D7AA r0 !   \ gives &10 Buffers
s0 @ dup s0 2- !         6 + s0 8 - !
here dp !

Host  Tudp @         Target  udp !
Host  Tvoc-link @    Target  voc-link !
Host  Tnext-link @   Target  next-link !
Host  move-threads
