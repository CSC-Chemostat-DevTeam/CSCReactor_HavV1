## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
begin
    using CSCReactor_HavV1
    using Random
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: CONNECT
let
    ch_try_connect(CONFIG)
    nothing
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: UTILS
function gID(prefix...)
    return string(join(prefix, "-"), "-", rand())
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: SETUP
Rs = ["R1", "R2", "R3", "R4", "R5"]
let
    setup_config = []
    
    # Reactors
    for RID in Rs
        push!(setup_config, 
            (CONFIG[RID]["pump.air.in.pin"], OUTPUT),
            # (CONFIG[RID]["pump.medium.in.pin"], OUTPUT),
            # (CONFIG[RID]["stirrel.pin"], OUTPUT),
            # (CONFIG[RID]["pump.medium.out.pin"], OUTPUT),
            # (CONFIG[RID]["pump.medium.out.pin"], OUTPUT),
            (CONFIG[RID]["laser.pin"], OUTPUT),
            (CONFIG[RID]["led.control.pin"], INPUT_PULLUP),
            (CONFIG[RID]["led.sample.pin"], INPUT_PULLUP),
        )
    end

    # Stirrel
    push!(setup_config, (CONFIG["STIRREL"]["stirrel.pin"], OUTPUT))

    # pinMode
    for (pin, mode) in setup_config
        @show pin, mode
        global res = send_csvcmd(SP, "INO", "PIN-MODE", pin, mode;
            log = true,
            log_extras = Dict("group" => gID("setup.pinMode"))
        )
        @assert res_success(res)
    end
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: LOOP
while (true)

    # INFO
    println("="^40)

    # MARK: ..DHT11
    log_extras = Dict("group" => gID("DHT11"))
    global res = send_csvcmd(SP, 
        "DHT11", "MEASSURE", 
        CONFIG["DHT11"]["pin"]; 
        tout = 1, 
        log = true, 
        log_extras
    )
    @assert res_success(res)
    T = vad_data(res, "T", nothing; T = Float64)
    @show T
    H = vad_data(res, "H", nothing; T = Float64)
    @show H


    # MARK: ..RID
    shuffle!(Rs)
    for RID in Rs
        @show RID

        # MARK: ....AIR IN
        log_extras = Dict("group" => gID(RID, "AIR.IN"))
        global res = send_csvcmd(SP, "INO", "DIGITAL-S-PULSE", 
            CONFIG[RID]["pump.air.in.pin"], 1, 500, 0;
            log = true,
            log_extras
        )
        # @assert ch_success(res)

        # MARK: ....STIRREL
        # $INO:DIGITAL-S-PULSE:PIN1:VAL01:TIME1:VAL11...%
        log_extras = Dict("group" => gID(RID, "stirrel"))
        global res = send_csvcmd(SP, 
            "INO", "DIGITAL-S-PULSE", 
            CONFIG["STIRREL"]["stirrel.pin"], 1, 500, 0;
            log = true, 
            log_extras
        )
        # @assert res_success(res)

        # MARK: ....OD
        log_extras = Dict()
        log_extras["group"] = gID(RID, "OD")

        # MARK: ......LASER ON
        laser_pwm = rand(0:255)
        log_extras["action"] = "laser.on"
        global res = send_csvcmd(SP, 
            "INO", "ANALOG-WRITE", 
            CONFIG[RID]["laser.pin"], laser_pwm;
            log = true,
            log_extras
        )
        sleep(1)
        # @assert res_success(res)

        # MARK: ......CONTROL LED
        log_extras["action"] = "read.control.pin"
        global res = send_csvcmd(SP, 
            "INO", "PULSE-IN", 
            CONFIG[RID]["led.control.pin"], 200;
            log = true,
            log_extras
        )
        control_led = vad_data(res, "read", nothing; T = Float64)
        @show control_led
        # @assert res_success(res)

        # MARK: ......SAMPLE LED
        log_extras["action"] = "read.sample.pin"
        global res = send_csvcmd(SP, 
            "INO", "PULSE-IN", 
            CONFIG[RID]["led.sample.pin"], 200;
            log = true,
            log_extras
        )
        sample_led = vad_data(res, "read", nothing; T = Float64)
        @show sample_led
        # @assert res_success(res)

        # MARK: ......LASER OFF
        laser_pwm = 0
        log_extras["action"] = "laser.off"
        global res = send_csvcmd(SP, 
            "INO", "ANALOG-WRITE", 
            CONFIG[RID]["laser.pin"], laser_pwm;
            log = true,
            log_extras
        )
        # @assert res_success(res)

    end
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
nothing