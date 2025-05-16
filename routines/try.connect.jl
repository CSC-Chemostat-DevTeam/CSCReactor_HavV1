ROUTINES["try.connect"] = function()
    isnothing(SP) || return nothing
    portname = find_port(CONFIG)
    baudrate = get(CONFIG["INOS"], "ino.baudrate", 19200)
    @show portname
    @show baudrate
    global SP = LibSerialPort.open(portname, baudrate)
end