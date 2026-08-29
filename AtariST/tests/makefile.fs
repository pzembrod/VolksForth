\ A minimalistic makefile that just creates an empty file on disk
\ without creating any Forth file in the dictionary.
\ Its only purpose is so that `makefile done` can be invoked
\ inside Hatari even without fileint.fb/fs loaded, to tell
\ run-in-hatari.py to terminate Hatari.

  : makefile ( -- )
    name count over >r + 0 swap c! r> (createfile ;
