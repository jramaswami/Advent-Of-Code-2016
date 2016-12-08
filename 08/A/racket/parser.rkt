#lang brag
screen-program : screen-decl (rect | rotate-row | rotate-col)*
rect           : RECT NUMBER NUMBER
rotate-row     : ROTATE-ROW NUMBER NUMBER
rotate-col     : ROTATE-COL NUMBER NUMBER
screen-decl    : SCREEN-DECL NUMBER NUMBER
