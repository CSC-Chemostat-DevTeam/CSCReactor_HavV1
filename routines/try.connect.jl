ROUTINES["try.connect"] = function()
    
    !haskey(STATE, "curr.SP") || return nothing
    portname = find_port(CONFIG)
    baudrate = get(CONFIG["INOS"], "ino.baudrate", 19200)
    @show portname
    @show baudrate
    STATE["curr.SP"] = LibSerialPort.open(portname, baudrate)
end