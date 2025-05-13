@time begin
    using CSCReactor_HavV1
    using CairoMakie
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
let
    global xs = []
    global ys = []
    foreach_log(len = Int(1e10)) do res
        haskey(res["log_extras"], "test") || return
        # @show res["log_extras"]
        global _res = res
        val = vad_data(res, "read", nothing; T = Int)
        isnothing(val) && return;
        push!(xs, res["time_tag"])
        push!(ys, val)
    end
    
    f = Figure()
    ax = Axis(f[1,1];
        xrotate = 45
    )
    scatter!(ax, xs, ys)
    f
end