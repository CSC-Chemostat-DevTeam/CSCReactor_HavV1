# .-- .. . . - --  - ----. . . . .. .- . - -- -. .- 
# MARK: air.pump.pulse.square
ROUTINES["dev:air.pump.pulse.square"] = function()

    SP = STATE["SP"]
    
    LOG_EXTRAS["group"] = gID("pump.air")
    LOG_EXTRAS["action"] = "pump.air.in"
    rid = CONFIG["curr.RID"]
    pin = CONFIG[rid]["pump.air.in.pin.layout"]["pin"]
    pulse_len = get(CONFIG[rid], "pump.air.in.pulse.time", 500)
    global res = send_csvcmd(SP, 
        "INO", "DIGITAL-S-PULSE", 
        pin, 1, pulse_len, 0;
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    # @assert ch_success(res)

end