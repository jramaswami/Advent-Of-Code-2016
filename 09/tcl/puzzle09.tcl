# Advent of Code 2016 :: Day 9 :: Explosives in Cyberspace

proc solve {input {recursive 0}} {
    set soln 0
    set start_search 0
    set open_paren_index [string first "(" $input $start_search]
    while {$open_paren_index >= 0} {
        incr soln [expr $open_paren_index - $start_search]
        set close_paren_index [string first ")" $input [expr {$open_paren_index + 1}]]
        set marker [string range $input [expr {$open_paren_index + 1}] [expr {$close_paren_index - 1}]]
        set tokens [split $marker "x"]
        set len [lindex $tokens 0]
        set reps [lindex $tokens 1]
        if {$recursive} {
            set s [string range $input [expr {$close_paren_index + 1}] [expr {$close_paren_index + $len}]]
            incr soln [expr {$reps * [solve $s 1]}]
        } else {
            incr soln [expr {$len * $reps}]
        }
        set start_search [expr {$close_paren_index + $len + 1}]
        set open_paren_index [string first "(" $input $start_search]
    }
    incr soln [expr {[string length $input] - $start_search}]
    return $soln
}

if {$::argv0 eq [info script]} {
    set input [string trimright [read stdin]]
    puts "The solution to part 1 is [solve $input]."
    puts "The solution to part 2 is [solve $input 1]."
}
