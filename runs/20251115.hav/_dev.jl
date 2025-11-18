## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
begin
    using CSCReactor_HavV1
    using Random
    using Dates
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
using Serialization
using JSON

let
    fn = "/Users/pereiro/.julia/dev/CSCReactor_HavV1/runs/20251115.hav/log.bk/17-11-2025-02-03.jls"
    dat = deserialize(fn)
    println(JSON.json(dat, 2))
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