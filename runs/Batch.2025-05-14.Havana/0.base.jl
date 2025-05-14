# CONFIG
empty!(CONFIG)
include("../../configs/chemostat.basic/0.config.main.jl")

# LOG
logdir!(joinpath(@__DIR__, "log"))


nothing