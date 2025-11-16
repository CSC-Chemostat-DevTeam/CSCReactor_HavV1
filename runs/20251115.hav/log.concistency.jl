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
function _walkdict(f::Function, dict::AbstractDict, path)
    push!(path, "")
    for (k, v) in dict
        path[end] = k
        if v isa AbstractDict
            _walkdict(f, v, path)
        else
            f(path, dict)
        end
    end
    pop!(path)
end
walkdict(f::Function, dict::AbstractDict) = 
    _walkdict(f, dict, [])

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Utils
PIN_META = Dict()
let
    # CONFIG
    walkdict(CONFIG) do path, depot
        last(path) == "type" || return
        depot["type"] == "pin.layout" || return
        pin = depot["pin"]
        PIN_META[pin] = join(path[1:end-1], ":")
    end
    PIN_META
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# MARK: Read
# DOING: 
# Given an action/group data
# You can reconstruct the command (or part of it) that was sended
# Rememmber you have the configuration
# #TODO All routines should provides one validator
# revcmd(log) -> expected command

let
    dir = "/Users/pereiro/.julia/dev/CSCReactor_HavV1/runs/hav/log.jsonl"

    global PARSED = []
    global PARSING = Dict()
    for name in readdir(dir)
        endswith(name, ".jsonl") || continue
        path = joinpath(dir, name)
        # @show name
        jslines = JSON3.read(path, 
            Vector{Dict{String, Any}}; 
            jsonlines = true
        )
        i = 0
        for js in jslines

            ttag0 = DateTime(js["time_tag"])

            ttag0 > DateTime("2025-06-18T14:00") || continue
            
            _next = false
            # global js = _js
            # i += 1
            # i > 10 || continue
            # i -= 1
            
            log_extras = get(js, "log_extras", nothing)
            group = get(log_extras, "group", nothing)
            action = get(log_extras, "action", nothing)

            tokens = js["echo"]["tokens"]
            csvline = js["echo"]["csvline"]
            csvline = strip(csvline, ':')
            
            # MARK: laser.on
            while true
                contains(csvline, "ANALOG-WRITE") || break

                pin0 = parse(Int, tokens[6])
                
                pinmeta = PIN_META[pin0]
                js["pinmeta"] = pinmeta
                contains(pinmeta, "laser.pin")  || break
                
                power0 = parse(Int, tokens[7])
                power0 > 0 || break
    
                # terminate
                if !isempty(PARSING)
                    push!(PARSED, deepcopy(PARSING))
                    empty!(PARSING) # clear old
                end
                
                PARSING["laser.on"] = js

                _next = true
                break
            end
            _next && continue

            # MARK: leds
            while true

                contains(csvline, "PULSE-IN") || break

                pin0 = parse(Int, tokens[6])
                
                pinmeta = PIN_META[pin0]
                js["pinmeta"] = pinmeta
                contains(pinmeta, ":led.")  || break
                
                time0 = parse(Int, tokens[7])
                time0 > 0 || break

                _next = true
                leds = get!(PARSING, "led.reads", [])
                push!(leds, js)
                
                _next = true
                break
            end
            _next && continue
            
        end # for js in jslines
        empty!(PARSING) # clear old
    end # readdir(dir)

end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
global DAT = Dict()
let
    for blob in PARSED

        haskey(blob, "led.reads") || continue
        haskey(blob, "laser.on") || continue

        leds = blob["led.reads"]

        laser = blob["laser.on"]
        lpower = laser["echo"]["tokens"][7]
        lpower = parse(Int, lpower)
        lpinmeta = laser["pinmeta"]
        lpinmeta = replace(lpinmeta, ".pin.layout" => "")

        length(leds) == 2 || continue
            
        val1 = leds[1]["responses"]["0"]["tokens"][end]
        val1 = parse(Int, val1)
        val2 = leds[2]["responses"]["0"]["tokens"][end]
        val2 = parse(Int, val2)

        ttag1 = leds[1]["time_tag"]
        ttag2 = leds[2]["time_tag"]
        
        pinmeta1 = leds[1]["pinmeta"]
        pinmeta1 = replace(pinmeta1, ".pin.layout" => "")
        pinmeta2 = leds[2]["pinmeta"]
        pinmeta2 = replace(pinmeta2, ".pin.layout" => "")

        
        DAT[ttag1] = Dict(
            pinmeta1 => val1, 
            pinmeta2 => val2, 
            lpinmeta => lpower
        )
    end
end

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
f = Figure()
ax = Axis(f[1,1]; 
    xlabel = "time",
    ylabel = "\\propto X",
)

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
let

    xs = []
    ys = []

    control_val = 0
    sample_val = 0
    lpower = 0

    cid = "R5"
    for (tstr, dat1) in DAT

        for (meta, val) in dat1
            startswith(meta, cid) || @goto CONTINUE
            if contains(meta, "led.control")
                control_val = val
            elseif contains(meta, "led.sample")
                sample_val = val
            elseif contains(meta, "laser")
                lpower = val
            else
                error("WTF, ", meta)
            end
        end

        lpower > 150 || continue
        lpower < Inf || continue

        push!(xs, tstr)
        push!(ys, 1 - sample_val / (sample_val + control_val))
        # push!(ys, lpower)

        @label CONTINUE
    end

    xs1 = DateTime.(xs)
    idx = sortperm(xs1)
    scatter!(ax, xs1[idx], ys[idx]; 
        label = cid, 
    )
    f
end


## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
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