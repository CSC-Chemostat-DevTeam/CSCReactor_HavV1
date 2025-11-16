# MARK: "OD.meassure.base.routine"
ROUTINES["OD.meassure.base.routine"] = function()
    
    RID = STATE["curr.RID"]
    SP = STATE["curr.SP"]
    laser_pwm = STATE["curr.laser.pwm"]

    # TODO
    # Improve extras recording
    # Do not overwrite
    # the top caller is responsable from reseting the LOG_EXTRAS
    # Any routine should empty!(LOG_EXTRAS)
    # Otherwise it loose composition power

    # callstack = get!(LOG_EXTRAS, "callstack", String[]) 
    # push!(callstack, gID(RID, "OD.meassure.base.routine"))

    OUT = get!(STATE, "OD.meassure.laser.PWM.range:out", Dict{String, Any}())
    laser_pwm_col = get!(OUT, "laser_pwm_col", Float64[])
    control_led_col = get!(OUT, "control_led_col", Float64[])
    sample_led_col = get!(OUT, "sample_led_col", Float64[])

    # MARK: ......LASER ON
    LOG_EXTRAS["action"] = "laser.on"
    global res = send_csvcmd(SP,
        "INO", "ANALOG-WRITE", 
        CONFIG[RID]["laser.pin.layout"]["pin"], laser_pwm;
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    @show laser_pwm
    # @assert res_success(res)
    
    # MARK: ......RELAX TIME
    relax_time = get(CONFIG[RID], "OD.meassure.laser.relax.time", 0.1)
    @show relax_time
    sleep(relax_time)

    # MARK: ......CONTROL LED
    LOG_EXTRAS["action"] = "read.control.led"
    global res = send_csvcmd(SP,
        "INO", "PULSE-IN", 
        CONFIG[RID]["led.control.pin.layout"]["pin"], 
        CONFIG[RID]["led.reading.time"];
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    control_led = vad_data(res, "read", nothing; T = Float64)
    @show control_led
    # @assert res_success(res)

    # MARK: ......SAMPLE LED
    LOG_EXTRAS["action"] = "read.sample.led"
    global res = send_csvcmd(SP,
        "INO", "PULSE-IN", 
        CONFIG[RID]["led.sample.pin.layout"]["pin"], 
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
        CONFIG[RID]["laser.pin.layout"]["pin"], 0;
        log = get(CONFIG, "log.enable", true),
        log_extras = LOG_EXTRAS
    )
    # @assert res_success(res)

    push!(laser_pwm_col, laser_pwm)
    push!(control_led_col, control_led)
    push!(sample_led_col, sample_led)

    return nothing
end

# MARK: "OD.meassure.random.pwm"
ROUTINES["OD.meassure.random.pwm"] = function()
    
    RID = STATE["curr.RID"]
    SP = STATE["curr.SP"]

    # rand pwm
    laser_pwm_min = get(CONFIG[RID], "laser.pwm.min", 1)
    laser_pwm_max = get(CONFIG[RID], "laser.pwm.max", 255)
    laser_pwm = rand(laser_pwm_min:laser_pwm_max)
    
    STATE["curr.laser.pwm"] = laser_pwm
    run_routine("OD.meassure.base.routine")
    
end

# MARK: "OD.meassure.laser.PWM.range"
ROUTINES["OD.meassure.laser.PWM.range"] = function()
    
    RID = STATE["curr.RID"]
    SP = STATE["curr.SP"]
    # returns
    
    
    laser_pwm_range = range(
        get(CONFIG[RID], "laser.pwm.min", 1), 
        get(CONFIG[RID], "laser.pwm.max", 255);
        step = get(STATE, "OD.test.laser.PWM.step", 1)
    )
        
    for laser_pwm in laser_pwm_range
        
        STATE["curr.laser.pwm"] = laser_pwm
        run_routine("OD.meassure.base.routine")

        
    end
    # @assert res_success(res)

    return nothing
end
