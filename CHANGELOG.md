## 1.1.5
\* Multi sspell callers (e.g. awake #\[one\[#two\[\_]])
\+ Forget function
\- Duplicated entities bug (souls and deads with same name)
\- Math lib bug (attempt to call a nil value (global 'unpack'))

## 1.1.4
\- 1.1.3 when block bug ('\[-+]%d+%.%d*' -> '\[-+]%d+%.?%d*')<br/>
\- rt, sml, gre, sle bug (attempt to compare string with number)

## 1.1.3
\- Exhume function bug (wrong extension)<br/>
\* Better compiling<br/>
\* Better <eof> error catcher

## 1.1.2
\- lines working inside false when block<br/>
\- grt, sml, gre, sle bug<br/>
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
