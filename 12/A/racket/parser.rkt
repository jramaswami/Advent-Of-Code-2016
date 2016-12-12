#lang brag

assembunny-program : [init] (copy-val | copy-reg | inc | dec | jnz-reg | jnz-val)+
copy-val           : COPY NUMBER REGISTER
copy-reg           : COPY REGISTER REGISTER
inc                : INC REGISTER
dec                : DEC REGISTER
jnz-reg            : JNZ REGISTER NUMBER
jnz-val            : JNZ NUMBER NUMBER
init               : INIT NUMBER NUMBER NUMBER NUMBER
