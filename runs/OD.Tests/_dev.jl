## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
begin
    using CSCReactor_HavV1
    using Random
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# setup
let
    ch_try_connect(CONFIG)
    nothing
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: Utils
function gID(prefix...)
    return string(join(prefix, "-"), "-", rand())
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: setup
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
# MARK: DEV
let
    RID = "R1"

    for it in 1:10
        # MARK: ........LASER ON
        laser_pwm = 255
        log_extras = Dict("group" => gID(RID, "OD"))
        global res = send_csvcmd(SP, 
            "INO", "ANALOG-WRITE", 
            CONFIG[RID]["laser.pin"], laser_pwm;
            log = false,
            log_extras
        )
        
        # MARK: ........CONTROL LED
        global res = send_csvcmd(SP, 
            "INO", "PULSE-IN", 
            CONFIG[RID]["led.control.pin"], 200;
            log = true,
            log_extras
        )
        control_led = vad_data(res, "read", nothing; T = Float64)
        @show control_led
        # @assert res_success(res)

        # MARK: ........SAMPLE LED
        global res = send_csvcmd(SP, 
            "INO", "PULSE-IN", 
            CONFIG[RID]["led.sample.pin"], 200;
            log = true,
            log_extras
        )
        sample_led = vad_data(res, "read", nothing; T = Float64)
        @show sample_led
        # @assert res_success(res)

        # MARK: ........LASER OFF
        laser_pwm = 0
        log_extras = Dict("group" => gID("OD"))
        global res = send_csvcmd(SP, 
            "INO", "ANALOG-WRITE", 
            CONFIG[RID]["laser.pin"], laser_pwm;
            log = true,
            log_extras
        )
        # @assert res_success(res)
        sleep(0.5)
    end
end