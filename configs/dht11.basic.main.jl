get!(CONFIG, "DHT11", Dict())
merge!(CONFIG["DHT11"], Dict(
    # PIN LAYOUT
    "pin.layout" => Dict(
        "pin" => CONFIG["PIN.LAYOUT"]["DHT11_PIN"],
        "mode" => nothing,
    ),

    # CONTROL
    "enable" => true,
    "meassure.period.min" => 10, # secs
))
