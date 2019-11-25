# Advent of Code 2016 :: Day 4 :: Security Through Obscurity

proc ord {c} {
    return [scan $c %c]
}

proc chr {n} {
    return [format %c $n]
}

proc compare {a b} {
    set freq_a [lindex $a 0]
    set freq_b [lindex $b 0]
    # Descending order for frequency.
    if {$freq_a > $freq_b} {
        return -1
    } elseif {$freq_a < $freq_b} {
        return 1
    }
    set name_a [lindex $a 1]
    set name_b [lindex $b 1]
    # Ascending order for name.
    return [string compare $name_a $name_b]
}

proc compute_checksum {encrypted_name} {
    foreach c [split $encrypted_name {}] {
        if {[string is alpha $c]} {
            incr freq($c) 1
        }
    }
    set lst {}
    foreach name [array names freq] {
        lappend lst [list [set freq($name)] $name]
    }
    set sorted [lsort -command compare $lst]
    set checksum {}
    foreach item [lrange $sorted 0 4] {
        lappend checksum [lindex $item 1]
    }
    return [join $checksum {}]
}

proc room_parts {room} {
    set parts [split $room "-"]
    set encrypted_name [lrange $parts 0 end-1]
    set i [string first {[} [lindex $parts end]]
    set sector_id [string range [lindex $parts end] 0 [expr {$i - 1}]]
    set given_csum [string range [lindex $parts end] [expr {$i + 1}] end-1]
    return [list $encrypted_name $sector_id $given_csum]
}

proc decrypt {encrypted_name sector_id} {
    set plaintext {}
    set ord_a [ord a]
    foreach c [split $encrypted_name {}] {
        if {$c == "-"} {
            lappend plaintext " "
            continue
        }
        set c0 [expr {[ord $c] - $ord_a}]
        set c1 [expr {($c0 + $sector_id) % 26}]
        set c2 [chr [expr {$c1 + $ord_a}]]
        lappend plaintext $c2
    }
    return [join $plaintext {}]
}

proc solve_part1 {rooms} {
    set sector_id_sum 0
    foreach room $rooms {
        set parts [room_parts $room]
        set encrypted_name [lindex $parts 0]
        set sector_id [lindex $parts 1]
        set given_csum [lindex $parts 2]
        set computed_csum [compute_checksum $encrypted_name]
        if {[string equal $given_csum $computed_csum]} {
            incr sector_id_sum $sector_id
        }
    }
    return $sector_id_sum
}

proc solve_part2 {rooms} {
    foreach room $rooms {
        set parts [room_parts $room]
        set encrypted_name [lindex $parts 0]
        set sector_id [lindex $parts 1]
        set given_csum [lindex $parts 2]
        set computed_csum [compute_checksum $encrypted_name]
        if {[string equal $given_csum $computed_csum]} {
            set decrypted_name [decrypt $encrypted_name $sector_id]
            if {[string match "*northpole*" $decrypted_name]}  {
                return $sector_id 
            }
        }
    }
}

if {!$tcl_interactive} {
    set input [string trimright [read stdin]]
    set rooms [split $input "\n"]
    puts "The solution to part 1 is [solve_part1 $rooms]."
    puts "The solution to part 2 is [solve_part2 $rooms]."
}
