# TODO: implement air.pump from this one
ROUTINES["pump.simple.pulse.square"] = function()

    SP = STATE["curr.SP"]
    pin = STATE["curr.pump.pin"]
    pulse_len = get(STATE, "curr.pump.pulse.len", 500)
    val0 = get(STATE, "curr.pump.pulse.pwm.val0", 255)
    val1 = get(STATE, "curr.pump.pulse.pwm.val1", 0)
    
    LOG_EXTRAS["group"] = gID("pump.air")
    LOG_EXTRAS["action"] = "pump.air.in"

    global res = send_csvcmd(SP, 
        "INO", "ANALOG-S-PULSE", 
        pin, val0, pulse_len, val1;
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    # @assert ch_success(res)

end