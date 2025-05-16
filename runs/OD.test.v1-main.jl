## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
begin
    using CSCReactor_HavV1
    using Random
    using Dates
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")
include("OD.test.v1-0.base.jl")

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
    run_routine("DHT11.meassure.T.and.H")

    # MARK: ..for RID
    shuffle!(CONFIG["RIDs"])
    for RID in CONFIG["RIDs"]
        @show RID
        CONFIG["curr.RID"] = RID
        
        # MARK: ....OD
        run_routine("OD.meassure.random.intensity")

    end
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
nothing