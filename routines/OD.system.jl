ROUTINES["OD.meassure.random.intensity"] = function()
    
    RID = CONFIG["curr.RID"]

    LOG_EXTRAS["group"] = gID(RID, "OD")

    # MARK: ......LASER ON
    laser_pwm_min = get(CONFIG[RID], "laser.pwm.min", 1)
    laser_pwm_max = get(CONFIG[RID], "laser.pwm.max", 255)
    laser_pwm = rand(laser_pwm_min:laser_pwm_max)
    LOG_EXTRAS["action"] = "laser.on"
    global res = send_csvcmd(SP,
        "INO", "ANALOG-WRITE", 
        CONFIG[RID]["laser.pin"], laser_pwm;
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    @show laser_pwm
    # @assert res_success(res)
    
    # MARK: ......RELAX TIME
    relax_time = get(CONFIG[RID], "OD.meassure.laser.relax.time", 0.500)
    @show relax_time
    sleep(relax_time)

    # MARK: ......CONTROL LED
    LOG_EXTRAS["action"] = "read.control.pin"
    global res = send_csvcmd(SP,
        "INO", "PULSE-IN", 
        CONFIG[RID]["led.control.pin"], 
        CONFIG[RID]["led.reading.time"];
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    control_led = vad_data(res, "read", nothing; T = Float64)
    @show control_led
    # @assert res_success(res)

    # MARK: ......SAMPLE LED
    LOG_EXTRAS["action"] = "read.sample.pin"
    global res = send_csvcmd(SP,
        "INO", "PULSE-IN", 
        CONFIG[RID]["led.sample.pin"], 
        CONFIG[RID]["led.reading.time"];
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    sample_led = vad_data(res, "read", nothing; T = Float64)
    @show sample_led
    # @assert res_success(res)

    # MARK: ......LASER OFF
    LOG_EXTRAS["action"] = "laser.off"
    global res = send_csvcmd(SP,
        "INO", "ANALOG-WRITE",
        CONFIG[RID]["laser.pin"], 0;
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    # @assert res_success(res)
end
