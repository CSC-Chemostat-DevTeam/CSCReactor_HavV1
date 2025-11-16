# CONFIG
empty!(CONFIG)
include("../../configs/reactor.basic.0.main.jl")

CONFIG["RIDs"] = ["R1", "R2", "R3", "R4", "R5"]

# ROUTINES
empty!(ROUTINES)
include("../../routines/0.main.jl")

# log extras
LOG_EXTRAS = Dict()
LOG_EXTRAS["sim.name"] = "OD.test.v1 - $(now())"

nothing