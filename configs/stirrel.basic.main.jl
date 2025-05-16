get!(CONFIG, "STIRREL", Dict())
merge!(CONFIG["STIRREL"], Dict(
    "type" => "stirrel.config",

    # PIN LAYOUT
    "pin.layout" => Dict(
        "type" => "pin.layout",
        "pin" => CONFIG["PIN.LAYOUT"]["STIRREL_PIN"],
        "mode" => OUTPUT
    ),

    # CONTROL
    "stirrel.enable" => true,
    "stirrel.pulse_period.min" => 3,
    "stirrel.pulse_period.target" => nothing,
))
