## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
begin
    using CSCReactor_HavV1
    using Random
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")
empty!(CONFIG)
include("../configs/reactor.basic.0.main.jl")
empty!(ROUTINES)
include("../routines/0.main.jl")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
run_routine("try.connect")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
run_routine("run.pinMode.from.pin.layout")

# .. - .- --- .- .-. --- .- .-. -.--- .. . ..