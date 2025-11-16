## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
begin
    using CSCReactor_HavV1
    using Random
    using Dates
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")
include("bash.basic.v1-0.base.jl")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: CONNECT
run_routine("try.connect")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: SETUP
run_routine("run.pinMode.from.pin.layout")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# MARK: LOOP
CONFIG["RIDs"] = ["R1", "R2", "R3", "R4", "R5"]
while (true)

    # INFO
    println("="^40)

    # MARK: ..DHT11
    # run_routine("DHT11.meassure.T.and.H")

    # MARK: ..for RID
    for RID in shuffle(CONFIG["RIDs"])
        @show RID
        STATE["curr.RID"] = RID

        # MARK: ....AIR IN
        # run_routine("air.pump.pulse.square")
        
        # MARK: ....STIRREL
        # run_routine("stirrel.run.pulse.square")
        
        # MARK: ....OD
        # run_routine("OD.meassure.random.pwm")

    end
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
nothing