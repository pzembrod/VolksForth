
\ *** Block No. 4, Hexblock 4

\ logfile log-type log-emit log-cr alsologtofile     phz 21mai25

  variable logfile      variable log-char

  : (log-type  ( adr len -- )
    under  logfile @ (filewrite  - abort" log write error" ;
  : log-type  ( adr len -- )  2dup STtype  (log-type ;

  : log-emit  ( char -- )  dup STemit
    log-char c! log-char 1 (log-type ;

  : log-cr  ( -- )  STcr
    #cr log-char c!  #lf log-char 1+ c!  log-char 2 (log-type ;

Output: alsologtofile
  log-emit log-cr log-type STdel STpage STat STat? ;

\ *** Block No. 5, Hexblock 5

\ logopen logclose                                   phz 22mai25

  create logfilename ," output.log" 0 c,

  : logopen  ( -- )
    logfilename 1+ (createfile
    dup 0< abort" logfile create error"  logfile !
    alsologtofile ;

  : logclose  ( -- )
    display  logfile @ (closefile
    0< abort" logfile close error" ;
