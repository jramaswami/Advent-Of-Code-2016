#lang brag

assembunny-program : (copy-val | copy-reg | inc | dec | jnz)+
copy-val           : COPY NUMBER REGISTER
copy-reg           : COPY REGISTER REGISTER
inc                : INC REGISTER
dec                : DEC REGISTER
jnz                : JNZ REGISTER NUMBER 
