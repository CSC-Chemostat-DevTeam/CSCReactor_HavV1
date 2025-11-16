## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
begin
    using CSCReactor_HavV1
    using Random
    using Dates
    using CairoMakie
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")
include("OD.test.v1-0.base.jl")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: CONNECT
# sudo chmod +777 /dev/ttyACM0
run_routine("try.connect")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: SETUP
run_routine("run.pinMode.from.pin.layout")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: RUN
let
    STATE["curr.RID"] = "R3"
    CONFIG["log.enable"] = false

    # OUT
    global out = get(STATE, 
        "OD.meassure.laser.PWM.range:out", 
        Dict{String, Any}()
    )
    empty!(out)

    global nsamples = 200
    for it in 1:nsamples
        run_routine("OD.meassure.random.pwm")
    end

    run(`say "Task finished!!!"`)

    return nothing
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: PLOTS
let
    # laser_pwm_col, control_led_col, sample_led_col
    f = Figure()
    ax = Axis(f[1,1];
    title = string(
        "RID: ", STATE["curr.RID"], 
        ),
        xlabel = "laser pwm", 
        ylabel = "led count", 
    )
    scatter!(ax, out["laser_pwm_col"], out["control_led_col"];
        label = "control_led_col", color = :red
        )
    scatter!(ax, out["laser_pwm_col"], out["sample_led_col"];
        label = "sample_led_col", color = :blue
    )
    axislegend(ax; position = :lt)
    f
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
