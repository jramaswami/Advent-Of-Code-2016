# Advent of Code 2016 :: Day 1 :: No Time for a Taxicab

set ::bunny_hq {}

proc N_R {} { return E }
proc N_L {} { return W }
proc W_R {} { return N }
proc W_L {} { return S }
proc S_R {} { return W }
proc S_L {} { return E }
proc E_R {} { return S }
proc E_L {} { return N }

proc walk_N {posn dist} {
    set x [lindex $posn 0]
    set y [lindex $posn 1]
    for {set i 0} {$i < $dist} {incr i} {
        incr y -1
        incr ::visited($x,$y) 1
        if {[set ::visited($x,$y)] == 2 && $::bunny_hq == {}} {
            set ::bunny_hq [list $x $y]
        }
    }
    return [list $x $y]
}

proc walk_S {posn dist} {
    set x [lindex $posn 0]
    set y [lindex $posn 1]
    for {set i 0} {$i < $dist} {incr i} {
        incr y 1
        incr ::visited($x,$y) 1
        if {[set ::visited($x,$y)] == 2 && $::bunny_hq == {}} {
            set ::bunny_hq [list $x $y]
        }
    }
    return [list $x $y]
}

proc walk_W {posn dist} {
    set x [lindex $posn 0]
    set y [lindex $posn 1]
    for {set i 0} {$i < $dist} {incr i} {
        incr x -1
        incr ::visited($x,$y) 1
        if {[set ::visited($x,$y)] == 2 && $::bunny_hq == {}} {
            set ::bunny_hq [list $x $y]
        }
    }
    return [list $x $y]
}

proc walk_E {posn dist} {
    set x [lindex $posn 0]
    set y [lindex $posn 1]
    for {set i 0} {$i < $dist} {incr i} {
        incr x 1
        incr ::visited($x,$y) 1
        if {[set ::visited($x,$y)] == 2 && $::bunny_hq == {}} {
            set ::bunny_hq [list $x $y]
        }
    }
    return [list $x $y]
}

proc solve {instructions} {
    set posn [list 0 0]
    set visited [list [list 0 0]]
    set first_dupe {}
    set facing N
    foreach instruction $instructions {
        set prev $posn
        set turn [string range $instruction 0 0]
        set dist [string range $instruction 1 end]
        set facing [${facing}_${turn}]
        set posn [walk_${facing} $posn $dist]
    }
    set x [lindex $posn 0]
    set y [lindex $posn 1]

    return [expr {abs($x) + abs($y)}]
}

if {!$tcl_interactive} {
    set input [string trimright [read stdin]]
    set instructions [lmap x [split $input ","] {string trim $x}]
    set soln [solve $instructions]
    puts "The solution to part 1 is [lindex $soln]."
    puts "The solution to part 2 is [expr {abs([lindex $::bunny_hq 0]) + abs([lindex $::bunny_hq 1])}]."
}

