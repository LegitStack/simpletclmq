
global $server = Runcmd()
startServer()

global $n11 = Runcmd()
startNaisen11()

global $user = Runcmd()
startUser()

;closeAll()

Func Runcmd()
    ; Run Notepad with the window maximized.
    Local $iPID = Run("cmd.exe", "")

    ; Wait for 1 second.
    Sleep(1000)
	return $iPID

EndFunc

Func startServer()

	send("tclsh server.tcl")
	sleep(50)
	send("{ENTER}")

EndFunc

Func startNaisen11()

	send("tclsh client.tcl")
	sleep(50)
	send("{ENTER}")
	sleep(50)
	send("client 1")
	sleep(50)
	send("{ENTER}")
EndFunc

Func startUser()

	send("tclsh user.tcl")
	sleep(50)
	send("{ENTER}")
	sleep(50)
	send("do this")
EndFunc



Func closeAll()
	ProcessClose($server)
	ProcessClose($n11)
	ProcessClose($n12)
	ProcessClose($n10)
	ProcessClose($n21)
	ProcessClose($sim)
	ProcessClose($user)
EndFunc
