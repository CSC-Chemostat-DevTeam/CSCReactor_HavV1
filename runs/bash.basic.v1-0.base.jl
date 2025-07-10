# CONFIG
empty!(CONFIG)
include("../configs/batch.basic.0.main.jl")

CONFIG["RIDs"] = ["R1", "R2", "R3", "R4", "R5"]

# ROUTINES
empty!(ROUTINES)
include("../routines/0.main.jl")

# log extras
empty!(LOG_EXTRAS)
LOG_EXTRAS["sim.name"] = "bash.basic.v1 - $(now())"

nothing