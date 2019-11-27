# Advent of Code 2016 :: Day 7 :: Internet Protocol Version 7

proc contains_abba {seq} {
    set seq_length [string length $seq]
    set search_limit [expr {$seq_length - 3}]
    for {set i 0} {$i < $search_limit} {incr i} {
        set a0 [string index $seq $i]
        set b0 [string index $seq [expr {$i + 1}]]
        set b1 [string index $seq [expr {$i + 2}]]
        set a1 [string index $seq [expr {$i + 3}]]
        if {$a0 != $b0 && $a0 == $a1 && $b0 == $b1} {
            return 1
        }
    }
    return 0
}

proc parse_ip_address {addr} {
    set parsed {}
    set token {}
    foreach c [split $addr ""] {
        if {$c == {[}} {
            lappend parsed [list outside [join $token ""]]
            set token {}
        } elseif {$c == {]}} {
            lappend parsed [list hypernet [join $token ""]]
            set token {}
        } else {
            lappend token $c
        }
    }
    lappend parsed [list outside [join $token ""]]
    return $parsed
}

proc ip_supports_tls {addr} {
    set parsed_addr [parse_ip_address $addr]
    set ok 0
    foreach part $parsed_addr {
        set type [lindex $part 0]
        set seq [lindex $part 1]
        if {$type == "outside" && [contains_abba $seq]} {
            set ok 1
        } elseif {$type == "hypernet" && [contains_abba $seq]} {
            return 0
        }
    }
    return $ok
}

proc solve_part1 {addresses} {
    set support_count 0
    foreach addr $addresses {
        if {[ip_supports_tls $addr]} {
            incr support_count
        }
    }
    return $support_count
}

proc get_abas {seq} {
    set abas {}
    set seq_length [string length $seq]
    set search_limit [expr {$seq_length - 2}]
    for {set i 0} {$i < $search_limit} {incr i} {
        set a0 [string index $seq $i]
        set b [string index $seq [expr {$i + 1}]]
        set a1 [string index $seq [expr {$i + 2}]]
        if {$a0 != $b && $a0 == $a1} {
            lappend abas "${a0}${b}${a1}"
        }
    }
    return $abas
}

proc ip_supports_ssl {addr} {
    set parsed_addr [parse_ip_address $addr]
    set abas {}
    set babs {}
    foreach part $parsed_addr {
        set type [lindex $part 0]
        set seq [lindex $part 1]
        set abas0 [get_abas $part]
        if {$type == "hypernet"} {
            lappend babs {*}$abas0
        } else {
            lappend abas {*}$abas0
        }
    }
    foreach aba $abas {
        set a [string index $aba 0]
        set b [string index $aba 1]
        set bab "${b}${a}${b}"
        if {[lsearch $babs $bab] >= 0} {
            return 1
        }
    }
    return 0
}

proc solve_part2 {addresses} {
    set support_count 0
    foreach addr $addresses {
        if {[ip_supports_ssl $addr]} {
            incr support_count
        }
    }
    return $support_count
}

if {!$tcl_interactive} {
    set input [string trimright [read stdin]]
    set addresses [split $input "\n"]
    puts "The solution to part 1 is [solve_part1 $addresses]."
    puts "The solution to part 2 is [solve_part2 $addresses]."
}
