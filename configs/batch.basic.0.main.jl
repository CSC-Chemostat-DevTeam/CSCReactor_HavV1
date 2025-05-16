using CSCReactor_HavV1

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-

# INCLUDES
include("reactor.basic.0.main.jl")

include("batch.basic.R1.jl")
include("batch.basic.R2.jl")
include("batch.basic.R3.jl")
include("batch.basic.R4.jl")
include("batch.basic.R5.jl")

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
# Meta
CONFIG["mode"] = "batch.basic"

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
nothing