# CONFIG
empty!(CONFIG)
include("../configs/reactor.basic.0.main.jl")

# log extras
log_extras = Dict()
log_extras["sim.name"] = "bash.basic.v1 - $(now())"

nothing