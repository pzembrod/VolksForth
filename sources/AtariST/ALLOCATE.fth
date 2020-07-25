\ *** Block No. 0 Hexblock 0 
\\                      *** Allocate ***               12oct86we
                                                                
Dieses File enth�lt die Betriebssystemroutinen, mit denen man   
RAM-Speicher beim Betriebssystem an- und abmelden kann.         
                                                                
MALLOC erwartet die - doppelt genaue - Anzahl der zu reservie-  
 renden Bytes und gibt die Langadresse des allokierten Speicher-
 bereichs zur�ck. Wenn nicht genug Speicherplatz zur Verf�gung  
 steht, wird der Befehl abgebrochen.                            
                                                                
MFREE gibt den Speicher ab laddr wieder frei. Bei Fehlern wird  
 der Befehl abgebrochen.                                        
                                                                
                                                                
                                                                
                                                                
\ *** Block No. 1 Hexblock 1 
\ malloc mfree                                         16oct86we
                                                                
Code malloc   ( d -- laddr )                                    
  .l SP ) A7 -) move  .w $48 # A7 -) move  1 trap               
   6 A7 addq  .l D0 SP ) move                                   
   ;c: 2dup or 0= abort" No more RAM" ;                         
                                                                
Code mfree    ( laddr -- )                                      
  .l SP )+ A7 -) move  .w $49 # A7 -) move  1 trap              
   6 A7 addq  .w D0 SP -) move  ;c: abort" mfree Error!" ;      
                                                                
                                                                
                                                                
                                                                
                                                                
                                                                
