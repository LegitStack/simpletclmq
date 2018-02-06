source ./see.tcl

namespace eval ::client {}
namespace eval ::client::set {}
namespace eval ::client::main {}
namespace eval ::client::actions {}
namespace eval ::client::record {}
namespace eval ::client::find {}
namespace eval ::client::helpers {}
namespace eval ::client::format {}
namespace eval ::client::die {}

############################################################################
# Setup ####################################################################
############################################################################

proc ::client::set::up {} {
  #make a db or whatever.
  #::repo::create $::myname
}

proc ::client::set::globals {} {
  set ::chan {}
  set ::myname {}
}


############################################################################
# Client ###################################################################
############################################################################


proc ::client::run  {} {
  set msg           {}
  set sendmsg       {}
  set introduction  [list from [::client::helpers::getMyName] to server message goodmorning]
  puts $::chan $introduction

  flush $::chan
  ::client::set::up
  puts "Server responded: [gets $::chan]"
  puts "Awaiting instructions from server..."

  while {1} {
    set msg [::client::getsMsg [gets $::chan]]
    puts "received: $msg"
    set sendmsg [::client::explore $msg]
    puts sending
    puts $sendmsg
    ::client::sendMsg $sendmsg
  }
}

proc ::client::getsMsg {message} {
  set x yes
  set msg $message

  while {$x} {
    fconfigure $::chan -blocking 0
    gets $::chan message

    if {$message eq ""} {
      set x no
    } else {
      lappend msg $message
    }

  }
  fconfigure $::chan -blocking 1
  return $msg
}

proc ::client::sendMsg {sendmsg} {
  if {$sendmsg ne ""} {
    #puts "sending: $sendmsg"
    puts $::chan $sendmsg
    flush $::chan
  }
}


############################################################################
# Interpret ################################################################
############################################################################

proc ::client::explore msg {
  return [::client::interpret $msg]
}

proc ::client::interpret msg {
  #return "this is where you send call other modules etc."
  set command [::see::command $msg]
  set from [::see::from $msg]
  if {$from eq "user"} {
    if        {$command eq "speak" } { return [::client::format hello intro [::see::message $msg]]
    } elseif  {$command eq "die"   } { puts "farewell"; ::client::die
    } else    { return [::client::format world hello user] }
  } else {
    if        {$command eq "intro" } { return [::client::format hello intro $from]
    } else    { return [::client::format world hello user] }
  }
}

proc ::client::format {{msg ""} {cmd ""} {to ""}} {
  if {$msg ne "" && $cmd ne "" && $to ne ""} {return [list [list from $::myname to $to  command $cmd message $msg when [clock milliseconds]]]
  } elseif {$msg ne "" && $cmd ne ""} {       return [list [list from $::myname to user command $cmd message $msg when [clock milliseconds]]]
  } elseif {$msg ne "" && $to ne ""} {        return [list [list from $::myname to $to               message $msg when [clock milliseconds]]]
  } elseif {$cmd ne "" && $to ne ""} {        return [list [list from $::myname to $to  command $cmd              when [clock milliseconds]]]
  } elseif {$msg ne ""} {                     return [list [list from $::myname to user              message $msg when [clock milliseconds]]]
  } elseif {$cmd ne ""} {                     return [list [list from $::myname to user command $cmd              when [clock milliseconds]]]
  } else {                                    return ""
  }
}

proc ::client::die {} {
  exit
}



############################################################################
# Helpers ##################################################################
############################################################################


proc ::client::helpers::getMyName {} {
  puts "What is my name?"
  flush stdout
  set ::myname [gets stdin]
  return $::myname
}

############################################################################
# Run ######################################################################
############################################################################


::client::set::globals
set ::chan [socket 127.0.0.1 9900]
::client::run
