@time begin
    using CSCReactor_HavV1
    using CairoMakie
    using JSON3
    using Dates
    using NDHistograms
    using OrderedCollections
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: CONFIG
empty!(CONFIG)
include("../../configs/batch.basic.0.main.jl")

CONFIG["RIDs"] = ["R1", "R2", "R3", "R4", "R5"]

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Utils
function _pushkey!(dict::Dict, k::String, v::T) where T
    vec::Vector{T} = get!(dict, k, T[])
    push!(vec, v)
end

_date_value(date) = Dates.value(date)
_date_value(date::TimePeriod) = 
    Dates.value(Millisecond(date))
function _date_value(date::String;
        df = dateformat"yyyy-mm-ddTHH:MM:SS.sss"
    )
    return _date_value(DateTime(date, df))
end


## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Read
let
    dir = "/Users/pereiro/.julia/dev/CSCReactor_HavV1/runs/hav/log.jsonl"

    global DAT = Dict()
    for name in readdir(dir)
        endswith(name, ".jsonl") || continue
        path = joinpath(dir, name)
        @show name
        jslines = JSON3.read(path; jsonlines = true)
        i = 0
        for js in jslines
            # global js = _js
            # i += 1
            # i > 10 || continue
            # i -= 1
            
            log_extras = get(js, "log_extras", nothing)
            group = get(log_extras, "group", nothing)
            action = get(log_extras, "action", nothing)
            
            # Filters
            # contains(group, r"^R\d+-OD") || continue
            # contains(group, r"^R2-OD") || continue
            # contains(action, r"read.control.led") || continue
            # contains(action, r"read.sample.led") || continue

            # @show log_extras
            # @show group

            csvline = js["echo"]["csvline"]
            csvline = strip(csvline, ':')
            contains(csvline, "PULSE-IN") || continue

            # 
            for rid in CONFIG["RIDs"], 
                ledid in ["led.sample", "led.control"]

                pin0 = CONFIG[rid]["$(ledid).pin.layout"]["pin"] 
                
                contains(csvline, "PULSE-IN:$(pin0)") || continue

                # @info rid ledid pin0 csvline
                
                responses = get(js, "responses", nothing)


                ledval = parse(Int, responses["0"]["data"][2])
                _pushkey!(DAT, "$(rid).$(ledid).value", 
                    ledval
                )

                _pushkey!(DAT, "$(rid).$(ledid).timetag", 
                    _date_value(js["time_tag"])
                )

                # i < 10 + 30 || return
            end
        end
    end

end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Histogram
let

    period = _date_value(Minute(1))
    @show period
    start = _date_value("2000-01-01T00:00")
    stop  = _date_value("2100-01-01T00:00")

    Rid = "R3"

    global h0 = NDHistogram(
        "value" => start:period:stop, 
    )
    HIST = Dict()

    for (t, v) in zip(
            DAT["$(Rid).led.control.timetag"], 
            DAT["$(Rid).led.control.value"], 
        )
        t >= _date_value("2025-06-10T00:00") || continue
        t < _date_value("2025-06-22T00:00") || continue
        count!(h0, (t,), v)
    end

    @show sum(values(h0))
    return nothing
end

# -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: plot
let
   f = Figure()
   ax = Axis(f[1,1]) 

   #    bins = map(DateTime, keys(h0, 1))
   bins = collect(keys(h0, "value"))
   bins = bins ./ maximum(bins)
   vals = collect(values(h0))
   scatter!(ax, bins, vals)
   f

end


## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
let
    
    f = Figure()
    
    rid = "R5"
    cled = DAT["$(rid).led.control.value"]
    sled = DAT["$(rid).led.sample.value"]
    dat = sled ./ (cled + sled)
    xs = eachindex(dat)
    ys = dat

    ax = Axis(f[1,1], 
        title = rid, 
        ylabel = "sample intensity fraction"
    )
    scatter!(ax, xs, ys)
    return f
end