# Advent of Code 2016 :: Day 6 :: Signals and Noise

proc solve {reps} {
    set rep_length [string length [lindex $reps 0]]
    foreach rep $reps {
        for {set i 0} {$i < $rep_length} {incr i} {
            set c [string index $rep $i]
            incr frequencies($i,$c)
        }
    }

    set soln1 {}
    set soln2 {}
    for {set i 0} {$i < $rep_length} {incr i} {
        set max_letter a
        set max_frequency [set frequencies($i,a)]
        set min_letter a
        set min_frequency [set frequencies($i,a)]
        foreach c {b c d e f g h i j k l m n o p q r s t u v w x y z} {
            if {![info exists frequencies($i,$c)]} {
                continue
            }
            if {[set frequencies($i,$c)] > $max_frequency} {
                set max_letter $c
                set max_frequency [set frequencies($i,$c)]
            }
            if {[set frequencies($i,$c)] < $min_frequency} {
                set min_letter $c
                set min_frequency [set frequencies($i,$c)]
            }
        }
        lappend soln1 $max_letter
        lappend soln2 $min_letter
    }
    return [list [join $soln1 ""] [join $soln2 ""]]
}
    
if {!$tcl_interactive} {
    set input [string trimright [read stdin]]
    set reps [split $input "\n"]
    set soln [solve $reps]
    puts "The solution to part 1 is [lindex $soln 0]."
    puts "The solution to part 2 is [lindex $soln 1]."
}
