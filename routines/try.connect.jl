ROUTINES["try.connect"] = function()
    
    !haskey(CONFIG, "SP") || return nothing
    portname = find_port(CONFIG)
    baudrate = get(CONFIG["INOS"], "ino.baudrate", 19200)
    @show portname
    @show baudrate
    STATE["SP"] = LibSerialPort.open(portname, baudrate)
end