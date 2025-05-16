@time begin
    using CSCReactor_HavV1
    using CairoMakie
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")
include("bash.basic.v1-0.base.jl")

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Utils
# Function to create xticks
function create_xticks(x_dates::Vector{DateTime}, period::Period)
    # x0, x1 = DateTime.(Date.(extrema(x_dates)))
    x0, x1 = extrema(x_dates)
    xtick_dates = x0:period:x1
    xtick_vals = Dates.value.(xtick_dates)
    xtick_labels = Dates.format.(xtick_dates, "yyyy-mm-dd  HH:MM")
    return (xtick_vals, xtick_labels)
end


## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Temperature
let
    global xs = DateTime[]
    global ys = Float64[]
    foreach_log(len = Int(1e10)) do res
        # @show res["time_tag"]
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
# MARK: collect OD
global DAT0 = Dict()

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
let
    global RID = "R5"
    global DAT = DAT0[RID] = Dict()
    # group
    # - read led1
    # - read led2
    # - laser power

    foreach_log(len = Int(1e10)) do res
        global _res = res
        haskey(res["log_extras"], "group") || return
        gID = res["log_extras"]["group"]
        contains(gID, "OD") || return
        contains(gID, RID) || return
        haskey(res["log_extras"], "action") || return
        contains(res["echo"]["csvline"], "INO:PULSE-IN") || return
        val = vad_data(res, "read", nothing; T = Float64)
        isnothing(val) && return;

        pin = parse(Int, _res["echo"]["tokens"][6])
        if pin == CONFIG[RID]["led.sample.pin"]
            action = "read.sample.pin"
        end
        if pin == CONFIG[RID]["led.control.pin"]
            action = "read.control.pin"
        end
        
        gDat = get!(DAT, gID, Dict())
        gDat["time_tag"]  = res["time_tag"]
        gDat[action] = val

    end

end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: plot OD
let
    global RID = "R5"
    global DAT = DAT0[RID]

    x_dates = DateTime[]
    ys = Float64[]
    for (gID, dat1) in DAT
        date0 = DateTime("2025-04-13T17:00", "yyyy-mm-ddTHH:MM")
        date1 = DateTime("2025-06-13T23:01", "yyyy-mm-ddTHH:MM")
        date = dat1["time_tag"]
        date > date0 || continue
        date < date1 || continue
        push!(x_dates, date)
        push!(ys, 
            abs(dat1["read.control.pin"] - dat1["read.sample.pin"]) / (dat1["read.sample.pin"] + dat1["read.control.pin"])) 
    end

    # Convert DateTime to Float64 using Dates.value (nanoseconds since epoch)
    # ys = (ys  .- minimum(ys)) 
    # ys = ys ./ maximum(ys)
    xs = Dates.value.(x_dates)

    # Control how many xticks to display
    xticks = create_xticks(x_dates, Hour(1))

    # Plot
    f = Figure()
    ax = Axis(f[1, 1];
        title = RID,
        xticks = xticks,
        xticklabelrotation = pi / 4, # 45 degrees
        xlabel = "Date",
        ylabel = L"\frac{abs(sample.led - control.led)}{(sample.led + control.led)}",
        limits = (nothing, nothing, -0.05, 1.05)
    )
    scatter!(ax, xs, ys)

    f
    
    # f = Figure()
    # ax = Axis(f[1,1];
    #     title = string(RID),
    #     xlabel = "date",
    #     ylabel = "sample.led / control.led",
    #     # limits = (nothing, nothing, 0, nothing)
    # )

    # # Customize x-ticks
    # x0, x1 = DateTime.(Date.(extrema(x_dates)))
    # tick_dates = collect(x0:Hour(1):x1)
    # tick_labels = Dates.format.(tick_dates, "yyyy-mm-dd HH:MM")
    # ax.xticks = (tick_dates, tick_labels)
    # ax.xticklabelrotation = π/4  # 45 degrees in radians
    
    # dates_values = Dates.value.(x_dates)
    # scatter!(ax, x_dates, ys)

    # # axislegend(ax)
    # f
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
let

    using CairoMakie
    using Dates

    # Generate sample DateTime data
    n = 100
    start_date = DateTime(2020, 1, 1)
    x_dates = [start_date + Day(i) for i in 1:n]
    y = randn(n)

    

end