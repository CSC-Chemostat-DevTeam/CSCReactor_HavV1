get!(CONFIG, "R3", Dict())
merge!(CONFIG["R3"], Dict(
    # EXTRAS
    
    # PIN LAYOUT
    "pump.air.in.pin.layout" => Dict(
        "type" => "pin.layout",
        "pin" => CONFIG["PIN.LAYOUT"]["PUMP_3_PIN"],
        "mode" => OUTPUT
    ),
    
    # CONFIG
    
    # MAIN CONTROL
    
    # STATE
    "pump.air.in.enable" => true,
    "pump.air.in.pulse_period.min" => 0,
    "pump.air.in.pulse_period.target" => nothing,
))

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
nothing

