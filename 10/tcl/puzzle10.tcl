# Advent of Code 2016 :: Day 10 :: Balance Bots

set max_bot 209

proc bots_with_two_values {} {
    set bots {}
    for {set b 0} {$b <= $::max_bot} {incr b} {
        set var_name "::values($b)"
        if {[info exists $var_name] && [llength [set $var_name]] == 2} {
            lappend bots $b
        }
    }
    return $bots
}

proc solve {instructions} {
    foreach instruction $instructions {
        set tokens [split $instruction " "]
        if {[string equal [lindex $tokens 0] "bot"]} {
            set bot_id [lindex $tokens 1]

            if {[string equal [lindex $tokens 5] "output"]} {
                set low_bot "output[lindex $tokens 6]"
            } else {
                set low_bot [lindex $tokens 6]
            }
            if {[string equal [lindex $tokens end-1] "output"]} {
                set high_bot "output[lindex $tokens end]"
            } else {
                set high_bot [lindex $tokens end]
            }

            set "::bot${bot_id}(low)" $low_bot
            set "::bot${bot_id}(high)" $high_bot
        } else {
            set bot_id [lindex $tokens end]
            set value [lindex $tokens 1]
            lappend "::values($bot_id)" $value
        }
    }

    set queue [bots_with_two_values]
    while {[llength $queue] > 0} {
        foreach bot_id $queue {
            set low_value [::tcl::mathfunc::min {*}[set ::values($bot_id)]]
            set high_value [::tcl::mathfunc::max {*}[set ::values($bot_id)]]

            if {$high_value == 61 && $low_value == 17} {
                set ::part1_bot $bot_id
            }

            set ::values($bot_id) ""
            set low_bot [set ::bot${bot_id}(low)]
            set high_bot [set ::bot${bot_id}(high)]
            lappend "::values($low_bot)" $low_value
            lappend "::values($high_bot)" $high_value
        }
        set queue [bots_with_two_values]
    }
}

if {$::argv0 eq [info script]} {
    set input [string trimright [read stdin]]
    set instructions [split $input "\n"]
    solve $instructions
    puts "The solution to part 1 is $::part1_bot."
    puts "The solution to part 2 is [expr {$::values(output0) * $::values(output1) * $::values(output2)}]."
}
