@time begin
    using CSCReactor_HavV1
    using CairoMakie
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Temperature
let
    global xs = DateTime[]
    global ys = Float64[]
    foreach_log(len = Int(1e10)) do res
        haskey(res["log_extras"], "group") || return
        gID = res["log_extras"]["group"]
        contains(gID, "DHT11") || return
        # @show res["log_extras"]
        global _res = res
        val = vad_data(res, "T", nothing; T = Float64)
        isnothing(val) && return;
        push!(xs, res["time_tag"])
        push!(ys, val)
    end
    
    f = Figure()
    ax = Axis(f[1,1];
        xticklabelrotation=45.0,
        xlabel = "date",
        ylabel = "Temperature (celsius)",
        limits = (nothing, nothing, 20, 30)
    )
    scatter!(ax, xs, ys)
    f
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Huminidity
let
    global xs = DateTime[]
    global ys = Float64[]
    foreach_log(len = Int(1e10)) do res
        haskey(res["log_extras"], "group") || return
        gID = res["log_extras"]["group"]
        contains(gID, "DHT11") || return
        # @show res["log_extras"]
        global _res = res
        val = vad_data(res, "H", nothing; T = Float64)
        isnothing(val) && return;
        push!(xs, res["time_tag"])
        push!(ys, val)
    end
    
    f = Figure()
    ax = Axis(f[1,1];
        xticklabelrotation=45.0,
        xlabel = "date",
        ylabel = "Humidity (%)",
        limits = (nothing, nothing, 40, 80)
    )
    scatter!(ax, xs, ys)
    f
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: OD
let
    RID = "R5"
    global DAT = Dict()
    foreach_log(len = Int(1e10)) do res
        haskey(res["log_extras"], "group") || return
        gID = res["log_extras"]["group"]
        contains(gID, "OD") || return
        contains(gID, RID) || return
        echo = res
        contains(res["echo"]["csvline"], "INO:PULSE-IN") || return
        pin = res["echo"]["tokens"][6]
        pindat = get!(DAT, pin, Dict())
        xs = get!(pindat, "xs", DateTime[])
        ys = get!(pindat, "ys", Float64[])
        global _res = res
        val = vad_data(res, "read", nothing; T = Float64)
        isnothing(val) && return;
        push!(xs, res["time_tag"])
        push!(ys, val)
    end
    
    f = Figure()
    ax = Axis(f[1,1];
        title = string(RID),
        xticklabelrotation=45.0,
        xlabel = "date",
        ylabel = "led read",
        # limits = (nothing, nothing, 0, nothing)
    )
    for (pin, pindat) in DAT
        scatter!(ax, pindat["xs"], pindat["ys"];
            label = string("pin: ", pin)
        )
    end
    axislegend(ax)
    f
end