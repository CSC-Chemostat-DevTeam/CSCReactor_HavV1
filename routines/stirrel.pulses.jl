ROUTINES["stirrel.run.pulse.square"] = function()
    
    SP = STATE["SP"]

    LOG_EXTRAS["group"] = gID("stirrel")
    LOG_EXTRAS["action"] = "stirrel.pulse.square"
    pin = CONFIG["STIRREL"]["stirrel.pin"]
    pulse_len = get(CONFIG["STIRREL"], "pulse.square.time", 500)
    # $INO:DIGITAL-S-PULSE:PIN1:VAL01:TIME1:VAL11...%
    global res = send_csvcmd(SP,
        "INO", "DIGITAL-S-PULSE", 
        pin, 1, pulse_len, 0;
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    @assert res_success(res)

end