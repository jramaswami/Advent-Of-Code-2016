# Advent of Code 2016 :: Day 5 :: How About a Nice Game of Chess

package require md5

proc password_complete {password} {
    foreach posn $password {
        if {$posn == ""} {
            return 0
        }
    }
    return 1
}

proc correct_prefix {hash} {
    for {set i 0} {$i < 5} {incr i} {
        if {[string index $hash $i] != 0} {
            return 0
        }
    }
    return 1
}

proc password_string {password_var} {
    set pass {}
    upvar $password_var password
    for {set i 0} {$i < 8} {incr i} {
        if {[info exists password($i)]} {
            lappend pass [set password($i)]
        } else {
            lappend pass "_"
        }
    }
    return [join $pass ""]
}

proc get_password {door_id} {
    set digits_guessed 0
    set n 0
    set password1 {}
    while {$digits_guessed < 8} {
        set tok [md5::MD5Init]
        md5::MD5Update $tok $door_id
        md5::MD5Update $tok $n
        set hash [md5::Hex [md5::MD5Final $tok]]
        if {[string match "00000*" $hash]} {
            set posn [string index $hash 5]
            if {[llength $password1] < 8} {
                lappend password1 $posn
            }
            set char [string index $hash 6]
            if {[string is digit $posn] && $posn < 8 && ![info exists password2($posn)]} {
                incr digits_guessed
                set password2($posn) $char
                puts [password_string password2]
            }
        }
        incr n
    }
    puts "$n MD5 hashes inspected."
    return [list [join $password1 ""] [password_string password2]]
}

if {!$tcl_interactive} {
    set door_id abbhdwsy
    # set door_id abc
    puts "Door id: $door_id ..."
    set soln [get_password $door_id]
    puts "The solution to part 1 is [lindex $soln 0]."
    puts "The solution to part 2 is [lindex $soln 1]."
}
