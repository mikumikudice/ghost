## 1.2.0
\+ Names idexing like graveyards<br/>
\* Fixed some bugs of pattern matching<br/>
\* Fixed read_grave (returning table itself instead of copy)<br/>
    
  * This change undoes the 1.1.18 commit<br/>

\- Empty lines with tabs

## 1.1.18
\- Internal safe copy function for graveyards (``read_grave()``)

## 1.1.17
\- (BUG) Ghost interpreter not finding files with special characters in name<br/>
\- Mathlib bug<br/>
\- Syntax error catcher bug (matching with correct graveyards)

## 1.1.16  
\- Duplicated entities bug (souls and deads could have the same name)<br/>
    - dead creator fixed (see 1.1.5)

\* Better compiling (syntax error catcher)<br/>
    - tell, read, when, sle, gte keywords typo finder

## 1.1.14 - 15
\* Fixed bug in spells with multiple args<br/>
\* Changed error message (SGSA -> SGEA : '\[...] spare' -> '\[...] extra')<br/>
\* Error catching for mathlib

## 1.1.13
\* better_gsub() getting metachars instead of raw strings (ghst_opr)<br/>
    - Fixed: parentheses operations not working

## 1.1.12
\- Output bug (not replacing internal metachars)

## 1.1.11
\* Better compiling (names behaviour and value replacement)<br/>
\* Better error catching

## 1.1.10
\- Bug in ghst_opr (function returning wrong error format)<br/>
\- Spell internal return bug<br/>
\- Other compiling bugs<br/>
\* Some internal changes<br/>
\* Better compiling<br/>
\+ OOP Suport (for Phantom lib)

## 1.1.9
\+ Forget function now can erease graveyards

## 1.1.8
\* Missing error catcher in 1st ghst_opr()<br/>
\+ Support for numbers in scientific notation

## 1.1.7
\* Better compiling (fixed (possible) string missmatch/added new internal escape chars)<br/>
\* Path loading to external files<br/>
\* Other code changes

## 1.1.6
\* Possibility to instantiate empty graveyards<br/>
\+ Error catcher for invoked libs

## 1.1.5
\- Duplicated entities bug (souls and deads with same name)<br/>
\- Math lib bug (attempt to call a nil value (global 'unpack'))<br/>
\* Multi sspell callers (e.g. awake #\[one\[#two\[\_]])<br/>
\+ Forget function

## 1.1.4
\- 1.1.3 when block bug ('\[-+]%d+%.%d*' -> '\[-+]%d+%.?%d*')<br/>
\- rt, sml, gre, sle bug (attempt to compare string with number)

## 1.1.3
\- Exhume function bug (wrong extension)<br/>
\* Better compiling<br/>
\* Better <eof> error catcher

## 1.1.2
\- lines working inside false when block<br/>
\- grt, sml, gte, sle bug<br/>
\- Spell args bug<br/>
\* Fixed quote escape char (`\q` -> `\'`)<br/>
\* File extention (`.g` -> `.gh`)<br/>
\* Better compiling<br/>
\+ Operations inside parentheses

## 1.0.2
\- Unused table "spell"<br/>
\* Greater or equal operator (gre -> gte)<br/>
\* CNEI error catcher<br/>
\+ File Not Found error to `invoke` spell<br/>

## 1.0.1
\- Spell return bug
