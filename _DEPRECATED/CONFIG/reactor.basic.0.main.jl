using CSCReactor_HavV1

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-

# INCLUDES
include("hardware.pin.layout.jl")
include("hardware.inOs.main.jl")
include("reactor.basic.R1.jl")
include("reactor.basic.R2.jl")
include("reactor.basic.R3.jl")
include("reactor.basic.R4.jl")
include("reactor.basic.R5.jl")
include("stirrel.basic.main.jl")
include("dht11.basic.main.jl")

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
# Meta
CONFIG["mode"] = "chemostat.basic"

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
nothing