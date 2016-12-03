#lang brag
pp-program : (op | push)*
op         : "U" | "D" | "R" | "L"
push       : NEWLINE-TOKEN
