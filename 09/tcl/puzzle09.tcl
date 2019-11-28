# Advent of Code 2016 :: Day 9 :: Explosives in Cyberspace

proc decompress {input {recursive 0}} {
    set decompressed_string ""
    set start_search 0
    set open_paren_index [string first "(" $input $start_search]
    while {$open_paren_index >= 0} {
        append decompressed_string [string range $input $start_search [expr {$open_paren_index - 1}]]
        set close_paren_index [string first ")" $input [expr {$open_paren_index + 1}]]
        set marker [string range $input [expr {$open_paren_index + 1}] [expr {$close_paren_index - 1}]]
        set tokens [split $marker "x"]
        set len [lindex $tokens 0]
        set reps [lindex $tokens 1]
        set s [string range $input [expr {$close_paren_index + 1}] [expr {$close_paren_index + $len}]]
        if {$recursive} {
            set t [string repeat [decompress $s 1] $reps]
        } else {
            set t [string repeat $s $reps]
        }
        append decompressed_string $t
        set start_search [expr {$close_paren_index + $len + 1}]
        set open_paren_index [string first "(" $input $start_search]
    }
    append decompressed_string [string range $input $start_search end]
    return $decompressed_string
}

if {$::argv0 eq [info script]} {
    set input [string trimright [read stdin]]
    set decompressed [decompress $input]
    puts "The solution to part 1 is [string length $decompressed]."
    set decompressed [decompress $input 1]
    puts "The solution to part 2 is [string length $decompressed]."
}
