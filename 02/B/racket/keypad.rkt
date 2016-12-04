#lang racket

(define KEYPAD-WIDTH 5)
(define KEYPAD-HEIGHT 5)
(define KEYPAD '#("" "" "1" "" ""
                     "" "2" "3" "4" ""
                     "5" "6" "7" "8" "9"
                     "" "A" "B" "C" ""
                     "" "" "D" "" ""))
(define START-KEY "5")
(provide KEYPAD KEYPAD-WIDTH KEYPAD-HEIGHT START-KEY)