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
function create_xticks(x_dates::Vector{DateTime}, period::Period, offset = Minute(0))
    # x0, x1 = DateTime.(Date.(extrema(x_dates)))
    x0, x1 = extrema(x_dates)
    xtick_dates = (x0 + offset):period:(x1 + offset)
    xtick_vals = Dates.value.(xtick_dates)
    xtick_labels = Dates.format.(xtick_dates, "yyyy-mm-dd  HH:MM")
    return (xtick_vals, xtick_labels)
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: DHT11
DAT0 = Dict()

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
let
    @time foreach_log(;
        maxfiles = Int(1e5)
    ) do res
        global _res = res

        haskey(res["log_extras"], "group") || return
        gID = res["log_extras"]["group"]
        contains(gID, "DHT11") || return
        
        date0 = DateTime("2025-05-10T16:00", "yyyy-mm-ddTHH:MM")
        date1 = DateTime("2025-05-25T18:01", "yyyy-mm-ddTHH:MM")
        date = res["time_tag"]
        date > date0 || return
        date < date1 || return

        # collect
        H_dates = get!(DAT0, "H_dates", DateTime[])
        H_vals = get!(DAT0, "H_vals", Float64[])
        H_val = vad_data(res, "H", nothing; T = Float64)
        if !isnothing(H_val)
            push!(H_dates, res["time_tag"])
            push!(H_vals, H_val)
        end
        T_dates = get!(DAT0, "T_dates", DateTime[])
        T_vals = get!(DAT0, "T_vals", Float64[])
        T_val = vad_data(res, "T", nothing; T = Float64)
        if !isnothing(T_val)
            push!(T_dates, res["time_tag"])
            push!(T_vals, T_val)
        end
    end
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: T & H
@time let
    # Plot

    f = Figure(size=(800, 400))

    ax1 = Axis(f[1, 1]; 
        ylabel="Temperature (Celsius)", 
        xlabel="date",
        xticklabelrotation = pi / 4, 
        xticks = create_xticks(DAT0["T_dates"], 
            Minute(4 * 60)
        ),
    )

    ax2 = Axis(f[1, 1]; 
        ylabel="Humidity (%)",     
        yaxisposition = :right, 
        xticklabelsvisible=false, 
        xgridvisible=false, ygridvisible=false,
        spinewidth=0, 
    )   
    ser1 = scatter!(ax1, 
        Dates.value.(DAT0["T_dates"]), DAT0["T_vals"];
        color = :blue, 
    )
    ser2 = scatter!(ax2, 
        Dates.value.(DAT0["H_dates"]), DAT0["H_vals"];
        color = :red,
    )
    Legend(f[1, 2], [ser1, ser2], ["Temp", "Hum"], tellwidth=false)
    colsize!(f.layout, 2, Auto(0.15))  

    f
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: collect OD
DAT0 = Dict()

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
@time let
    global RID = "R4"
    global DAT = DAT0[RID] = Dict()

    foreach_log(
        maxfiles = Int(1e15)
    ) do res
        global _res = res

        haskey(res["log_extras"], "group") || return
        gID = res["log_extras"]["group"]
        contains(gID, "OD") || return
        contains(gID, RID) || return
        
        date0 = DateTime("2025-05-10T16:00", "yyyy-mm-ddTHH:MM")
        date1 = DateTime("2025-05-25T18:01", "yyyy-mm-ddTHH:MM")
        date = res["time_tag"]
        date > date0 || return
        date < date1 || return
        
        
        contains(res["echo"]["csvline"], "INO:PULSE-IN") || return
        
        val = vad_data(res, "read", nothing; T = Float64)
        isnothing(val) && return;
        
        res_pin = parse(Int, res["echo"]["tokens"][6])
        config_pin = CONFIG[RID]["led.sample.pin.layout"]["pin"]
        action = "missing"
        if res_pin == config_pin
            action = "read.sample"
        end
        config_pin = CONFIG[RID]["led.control.pin.layout"]["pin"]
        if res_pin == config_pin
            action = "read.control"
        end
        
        gDat = get!(DAT, gID, Dict())
        gDat["time_tag"]  = res["time_tag"]
        gDat[action] = val
    end
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: plot OD
let
    global RID = "R4"
    global DAT = DAT0[RID]

    x_dates = DateTime[]
    ys = Float64[]
    for (gID, dat1) in DAT
        
        date0 = DateTime("2025-05-15T00:00", "yyyy-mm-ddTHH:MM")
        date1 = DateTime("2025-05-15T02:00", "yyyy-mm-ddTHH:MM")
        date = dat1["time_tag"]
        date > date0 || continue
        date < date1 || continue
        
        haskey(dat1, "read.sample") || continue
        haskey(dat1, "read.control") || continue
        

        push!(x_dates, date)
        # push!(ys, 
        #     abs(dat1["read.control"] - dat1["read.sample"]) / (dat1["read.sample"] + dat1["read.control"])
        # ) 
        push!(ys, 
            dat1["read.sample"] / dat1["read.control"]
        ) 
    end

    # Convert DateTime to Float64 using Dates.value (nanoseconds since epoch)
    # ys = (ys  .- minimum(ys)) 
    # ys = ys ./ maximum(ys)
    xs = Dates.value.(x_dates)

    # Control how many xticks to display

    # Plot
    f = Figure()
    ax = Axis(f[1, 1];
        title = RID,
        xticks = create_xticks(x_dates, 
            Minute(20),
            # -Minute(48),
        ),
        xticklabelrotation = pi / 4, # 45 degrees
        xlabel = "Date",
        ylabel = L"\frac{abs(sample.led - control.led)}{(sample.led + control.led)}",
        # limits = (nothing, nothing, -0.05, 1.05)
    )
    scatter!(ax, xs, ys)

    f
    
end
