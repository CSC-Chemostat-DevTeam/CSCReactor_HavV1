using CSCReactor_HavV1

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-

# INCLUDES
include("../hardware/pin.layout.jl")
include("../hardware/inOs.jl")
include("3.R1.config.jl")
include("3.R2.config.jl")
include("3.R3.config.jl")
include("3.R4.config.jl")
include("3.R5.config.jl")
include("../stirrel.basic/stirrel.jl")
include("../dht11.basic/dht11.jl")

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
# Meta
CONFIG["mode"] = "chemostat.basic"

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
nothing