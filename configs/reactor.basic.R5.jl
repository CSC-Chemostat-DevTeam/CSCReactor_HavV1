get!(CONFIG, "R5", Dict())
merge!(CONFIG["R5"], Dict(
    # EXTRAS
    "R.name" => "R5",
    "type" => "reactor.config",
    
    # PIN LAYOUT
    "laser.pin.layout"=> Dict(
        "type" => "pin.layout",
        "pin" => CONFIG["PIN.LAYOUT"]["CH5_LASER_PIN"],
        "mode"=> OUTPUT
    ),
    "led.control.pin.layout" => Dict(
        "type" => "pin.layout",
        "pin" => CONFIG["PIN.LAYOUT"]["CH5_CONTROL_LED_PIN"],
        "mode" => INPUT_PULLUP
    ),
    "led.sample.pin.layout" => Dict(
        "type" => "pin.layout",
        "pin" => CONFIG["PIN.LAYOUT"]["CH5_SAMPLE_LED_PIN"],
        "mode" => INPUT_PULLUP
    ),
    
    # CONFIG
    "led.reading.time" => 200, # ms
    "laser.pwm.max" => 255,
    "laser.pwm.min" => 1,

    # STATE CONTROL
    "run.dry" => false,

))

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
nothing
