ROUTINES["DHT11.meassure.T.and.H"] = function()

    LOG_EXTRAS["group"] = gID("DHT11")
    LOG_EXTRAS["action"] = "DHT11.meassure"
    global res = send_csvcmd(SP, 
        "DHT11", "MEASSURE", 
        CONFIG["DHT11"]["pin"]; 
        tout = 1, 
        log = get(CONFIG, "log.enable", true), 
        log_extras = LOG_EXTRAS
    )
    @assert res_success(res)
    T = vad_data(res, "T", nothing; T = Float64)
    @show T
    H = vad_data(res, "H", nothing; T = Float64)
    @show H

end