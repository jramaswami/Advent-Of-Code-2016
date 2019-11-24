# Advent of Code 2016 :: Day 1 :: No Time for a Taxicab
# GUI Version

package require tooltip

set block_size 3
set x_offset 25
set y_offset 150
set dimension 300

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
        .c itemconfigure [set ::cells($x,$y)] -fill red
        if {[set ::visited($x,$y)] == 2 && $::bunny_hq == {}} {
            set ::bunny_hq [list $x $y]
            set msg "Bunny HQ: [expr {abs($x) + abs($y)}] from start."
            mark_coordinates $x $y $msg
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
        .c itemconfigure [set ::cells($x,$y)] -fill red
        if {[set ::visited($x,$y)] == 2 && $::bunny_hq == {}} {
            set ::bunny_hq [list $x $y]
            set msg "Bunny HQ: [expr {abs($x) + abs($y)}] from start."
            mark_coordinates $x $y $msg
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
        .c itemconfigure [set ::cells($x,$y)] -fill red
        if {[set ::visited($x,$y)] == 2 && $::bunny_hq == {}} {
            set ::bunny_hq [list $x $y]
            set msg "Bunny HQ: [expr {abs($x) + abs($y)}] from start."
            mark_coordinates $x $y $msg
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
        .c itemconfigure [set ::cells($x,$y)] -fill red
        if {[set ::visited($x,$y)] == 2 && $::bunny_hq == {}} {
            set ::bunny_hq [list $x $y]
            set msg "Bunny HQ: [expr {abs($x) + abs($y)}] from start."
            mark_coordinates $x $y $msg
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
        update
        after 50
    }
    set x [lindex $posn 0]
    set y [lindex $posn 1]

    set msg "End: [expr {abs($x) + abs($y)}] from start."
    mark_coordinates $x $y $msg
    return [expr {abs($x) + abs($y)}]
}

proc init_canvas {} {
    global block_size
    for {set row 0} {$row < $::dimension} {incr row} {
        for {set col 0} {$col < $::dimension} {incr col} {
            set y1 [expr {$block_size * $row}]
            set x1 [expr {$block_size * $col}]
            set y2 [expr {$y1 + $block_size}]
            set x2 [expr {$x1 + $block_size}]
            set cell_id [.c create rectangle $x1 $y1 $x2 $y2 -fill gray -outline black]
            set row0 [expr {$row - $::y_offset}]
            set col0 [expr {$col - $::x_offset}]
            set ::cells($col0,$row0) $cell_id
        }
    }
}

proc mark_coordinates {cell_x cell_y {msg ""}} {
    set coordinates [.c coords $::cells($cell_x,$cell_y)]
    set x [expr {[lindex $coordinates 0] - (2 * $::block_size)}]
    set y [expr {[lindex $coordinates 1] - (2 * $::block_size)}]
    set id [.c create rectangle $x $y [expr {$x + (5 * $::block_size)}] [expr {$y + (5 * $::block_size)}] -fill green]
    tooltip::tooltip .c -item $id $msg
}

proc go {} {
    set fp [open "../input.txt" r]
    set input [read $fp]
    close $fp
    set instructions [lmap x [split $input ","] {string trim $x}]
    mark_coordinates 0 0 "Start"
    solve $instructions
}

if {!$tcl_interactive} {
    set canvas_dimension [expr {$::dimension * $::block_size}] 
    canvas .c -height $canvas_dimension -width $canvas_dimension -background white
    pack .c -side top
    init_canvas
    go
}
