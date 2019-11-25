# Advent of Code 2016 :: Day 3 :: Squares With Three Sides

proc is_valid_triangle {a b c} {
    if {[expr {$a + $b}] <= $c} { return 0 }
    if {[expr {$a + $c}] <= $b} { return 0 }
    if {[expr {$b + $c}] <= $a} { return 0 }
    return 1
}

proc solve_part1 {triangles} {
    set valid_triangles 0
    foreach triangle $triangles {
        set a [lindex $triangle 0]
        set b [lindex $triangle 1]
        set c [lindex $triangle 2]
        if {[is_valid_triangle $a $b $c]} {
            incr valid_triangles
        }
    }
    return $valid_triangles
}

proc solve_part2 {triangles} {
    set valid_triangles 0
    for {set col 0} {$col < 3} {incr col} {
        for {set row 0} {$row < [llength $triangles]} {incr row 3} {
            set a [lindex [lindex $triangles $row] $col]
            set b [lindex [lindex $triangles [expr {$row + 1}]] $col]
            set c [lindex [lindex $triangles [expr {$row + 2}]] $col]
            if {[is_valid_triangle $a $b $c]} {
                incr valid_triangles
            }
        }
    }
    return $valid_triangles
}

if {!$tcl_interactive} {
    set input [string trimright [read stdin]]
    set lines [split $input "\n"]
    set triangles {}
    foreach line $lines {
        set triangle [join $line " "]  ;# weird way to split on multiple spaces
        lappend triangles $triangle
    }
    puts "The solution to part 1 is [solve_part1 $triangles]."
    puts "The solution to part 2 is [solve_part2 $triangles]."
}
