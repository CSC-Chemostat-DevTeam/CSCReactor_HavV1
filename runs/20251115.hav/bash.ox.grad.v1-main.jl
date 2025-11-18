## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
begin
    using CSCReactor_HavV1
    using Random
    using Dates
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")
include("bash.ox.grad.v1-0.base.jl")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: CONNECT
run_routine("try.connect")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: SETUP
sleep(1)
run_routine("run.pinMode.from.pin.layout")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# NOTES
# Inoculation at 4:15
# Hight risk of contamination
# LB medium
# Incoculum from solid media colonies
# Performed at my home
# Air connection
# R3 -> R5 -> R4 -> R2


## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: LOOP
CONFIG["RIDs"] = ["R2", "R3", "R4", "R5"]
while (true)

    # INFO
    println("="^40)

    # MARK: ..DHT11
    run_routine("DHT11.meassure.T.and.H")

    # MARK: ....AIR IN
    STATE["curr.pump.pin"] = CONFIG["PIN.LAYOUT"]["PUMP_1_PIN"]
    STATE["curr.pump.pulse.len"] = 100
    run_routine("pump.simple.pulse.square")
  
    # MARK: ....STIRREL
    STATE["curr.pump.pin"] = CONFIG["PIN.LAYOUT"]["STIRREL_PIN"]
    for (val0, val1, len) in [
        (0, 180, 100), 
        (180, 190, 100), 
        (190, 200, 100), 
        (200, 210, 100), 
        (220, 0, 500), 
    ]
        STATE["curr.pump.pulse.len"] = len
        STATE["curr.pump.pulse.pwm.val0"] = val0
        STATE["curr.pump.pulse.pwm.val1"] = val1
        run_routine("pump.simple.pulse.square")
    end

    sleep(1)

    # MARK: ..for RID
    shuffle!(CONFIG["RIDs"])
    for RID in CONFIG["RIDs"]

        @show RID
        STATE["curr.RID"] = RID
        
        # # MARK: ....OD
        run_routine("OD.meassure.random.pwm")

    end
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
nothing