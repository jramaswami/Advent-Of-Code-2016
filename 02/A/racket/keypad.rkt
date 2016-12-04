#lang racket

(define KEYPAD-WIDTH 3)
(define KEYPAD-HEIGHT 3)
(define KEYPAD '#("1" "2" "3"
                      "4" "5" "6"
                      "7" "8" "9"))
(define START-KEY "5")

(provide KEYPAD KEYPAD-WIDTH KEYPAD-HEIGHT START-KEY)