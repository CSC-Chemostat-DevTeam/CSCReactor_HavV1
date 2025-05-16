ROUTINES["run.pinMode.from.pin.layout"] = function()

    SP = STATE["SP"]
    
    pinMode_config = []
    foreach_child(Dict, CONFIG) do hist, obj
        get(obj, "type", "") == "pin.layout" || return
        hist = join(hist, ":")
        push!(pinMode_config, hist => obj)
    end

    # pinMode
    println("send.pinMode")
    println("id:pin:mode")
    for (hist, config) in pinMode_config
        pin = config["pin"]
        isnothing(pin) && continue
        mode = config["mode"]
        isnothing(mode) && continue
        println(hist, ":", pin, ":",  mode)
        LOG_EXTRAS["group"] = gID("setup.pinMode")
        LOG_EXTRAS["action"] = "pinMode.$pin.$mode"
        global res = send_csvcmd(SP, 
            "INO", "PIN-MODE", pin, mode;
            log = get(CONFIG, "log.enable", true),
            log_extras = LOG_EXTRAS
        )
        @assert res_success(res)
    end

end