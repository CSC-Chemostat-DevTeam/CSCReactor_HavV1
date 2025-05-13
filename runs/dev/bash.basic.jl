## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
@time begin
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
        global res = send_csvcmd(SP, "INO", "PIN-MODE", pin, OUTPUT;
            log = true,
            log_extras = Dict("group" => gID("setup.pinMode"))
        )
        @assert res_success(res)
    end
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: LOOP
# while (true)
for it in 1:5

    # INFO
    println("="^40)

    # MARK: ....DHT11
    log_extras = Dict("group" => gID("DHT11"))
    global res = send_csvcmd(SP, 
        "DHT11", "MEASSURE", 
        CONFIG["DHT11"]["pin"]; 
        tout = 1, 
        log = true, 
        log_extras
    )
    @assert res_success(res)


    # MARK: ....RID
    Rs = ["R3"]
    shuffle!(Rs)
    for RID in Rs

        # MARK: AIR IN
        log_extras = Dict("group" => gID(RID, "AIR.IN"))
        global res = send_csvcmd(SP, "INO", "DIGITAL-S-PULSE", 
            CONFIG[RID]["pump.air.in.pin"], 1, 500, 0;
            log = true,
            log_extras
        )
        # @assert ch_success(res)

        # MARK: ....STIRREL
        # $INO:DIGITAL-S-PULSE:PIN1:VAL01:TIME1:VAL11...%
        log_extras = Dict("group" => gID("stirrel"))
        @time global res = send_csvcmd(SP, "INO", "DIGITAL-S-PULSE", 
            CONFIG["STIRREL"]["stirrel.pin"], 1, 500, 0;
            log = true, 
            log_extras
        )
        # @assert res_success(res)
        sleep(1)

        # MARK: ........LASER ON
        laser_pwm = rand(0:255)
        log_extras = Dict("group" => gID(RID, "OD"))
        @time global res = send_csvcmd(SP, 
            "INO", "ANALOG-WRITE", 
            CONFIG[RID]["laser.pin"], laser_pwm;
            log = true,
            log_extras
        )
        # @assert res_success(res)

        # MARK: ........CONTROL LED
        @time global res = send_csvcmd(SP, 
            "INO", "PULSE-IN", 
            CONFIG[RID]["led.control.pin"], 100;
            log = true,
            log_extras
        )
        # @assert res_success(res)

        # MARK: ........SAMPLE LED
        @time global res = send_csvcmd(SP, 
            "INO", "PULSE-IN", 
            CONFIG[RID]["led.sample.pin"], 100;
            log = true,
            log_extras
        )
        # @assert res_success(res)

        # MARK: ........LASER OFF
        laser_pwm = 0
        log_extras = Dict("group" => gID("OD"))
        @time global res = send_csvcmd(SP, 
            "INO", "ANALOG-WRITE", 
            CONFIG[RID]["laser.pin"], laser_pwm;
            log = true,
            log_extras
        )
        # @assert res_success(res)

    end
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# DOING: create a bash.basic protocole
let 
    global res;

    global res = send_csvcmd(SP, 
        "INO", "PIN-MODE", 
        CONFIG["R2"]["led.control.pin"], INPUT_PULLUP; 
        tout = 1, 
        log = true
    )
    
    # # INPUT_PULLUP
    # global res = send_csvcmd(
    #     SP, "INO", "PIN-MODE",
    #     CONFIG["R2"]["led.control.pin"], INPUT_PULLUP; 
    #     tout = 1, 
    # )

    # read sensors 1
    global res = send_csvcmd(SP, 
        "INO", "PULSE-IN", CONFIG["R2"]["led.control.pin"], 100;
        tout = 1, 
        log = true
    )


    foreach_log() do res
        ttag = res["time_tag"]
        val = vad_data(res, "read", NaN; T = Float64)
        @show val
    end
end
