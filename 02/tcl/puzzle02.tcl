# Advent of Code 2016 :: Day 2 :: Bathroom Security

proc move_L {posn keypad} {
    set x [lindex $posn 0]
    set y [lindex $posn 1]
    set x0 [expr {$x - 1}]
    if {$x0 < 0} {
        return [list $x $y]
    } elseif {[lindex [lindex $keypad $y] $x0] == 0} {
        return [list $x $y]
    } else {
        return [list $x0 $y]
    }
}

proc move_R {posn keypad} {
    set x [lindex $posn 0]
    set y [lindex $posn 1]
    set x0 [expr {$x + 1}]
    if {$x0 >= [llength $keypad]} {
        return [list $x $y]
    } elseif {[lindex [lindex $keypad $y] $x0] == 0} {
        return [list $x $y]
    } else {
        return [list $x0 $y]
    }
}

proc move_U {posn keypad} {
    set x [lindex $posn 0]
    set y [lindex $posn 1]
    set y0 [expr {$y - 1}]
    if {$y0 < 0} {
        return [list $x $y]
    } elseif {[lindex [lindex $keypad $y0] $x] == 0} {
        return [list $x $y]
    } else {
        return [list $x $y0]
    }
}

proc move_D {posn keypad} {
    set x [lindex $posn 0]
    set y [lindex $posn 1]
    set y0 [expr {$y + 1}]
  
    if {$y0 >= [llength $keypad]} {
        return [list $x $y]
    } elseif {[lindex [lindex $keypad $y0] $x] == 0} {
        return [list $x $y]
    } else {
        return [list $x $y0]
    }
}

proc solve {instructions posn keypad} {
    set combination {}
    foreach instruction $instructions {
        foreach letter [split $instruction ""] {
            set posn [move_$letter $posn $keypad]
        }
        set x [lindex $posn 0]
        set y [lindex $posn 1]
        lappend combination [lindex [lindex $keypad $y] $x]
    }
    return [join $combination ""]
}

if {!$tcl_interactive} {
    set input [string trimright [read stdin]]
    set instructions [split $input "\n"]
    set keypad {{1 2 3} { 4 5 6} {7 8 9}}
    puts "The solution to part 1 is [solve $instructions [list 1 1] $keypad]."
    set keypad {{0 0 1 0 0} {0 2 3 4 0} {5 6 7 8 9} {0 A B C 0} {0 0 D 0 0}}
    puts "The solution to part 1 is [solve $instructions [list 0 2] $keypad]."
}
