# CONFIG
empty!(CONFIG)
include("../configs/reactor.basic.0.main.jl")

CONFIG["RIDs"] = ["R1", "R2", "R3", "R4", "R5"]

# ROUTINES
empty!(ROUTINES)
include("../routines/0.main.jl")

# log extras
log_extras = Dict()
log_extras["sim.name"] = "bash.basic.v1 - $(now())"

nothing