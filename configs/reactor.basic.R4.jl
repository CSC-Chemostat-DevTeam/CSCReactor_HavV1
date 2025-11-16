get!(CONFIG, "R4", Dict())
merge!(CONFIG["R4"], Dict(
    # EXTRAS
    "R.name" => "R4",
    "type" => "reactor.config",
    
    # PIN LAYOUT
    "laser.pin.layout"=> Dict(
        "type" => "pin.layout",
        "pin" => CONFIG["PIN.LAYOUT"]["CH4_LASER_PIN"],
        "mode"=> OUTPUT
    ),
    "led.control.pin.layout" => Dict(
        "type" => "pin.layout",
        "pin" => CONFIG["PIN.LAYOUT"]["CH4_CONTROL_LED_PIN"],
        "mode" => INPUT_PULLUP
    ),
    "led.sample.pin.layout" => Dict(
        "type" => "pin.layout",
        "pin" => CONFIG["PIN.LAYOUT"]["CH4_SAMPLE_LED_PIN"],
        "mode" => INPUT_PULLUP
    ),
    
    # CONFIG
    "led.reading.time" => 800, # ms
    "laser.pwm.max" => 255,
    "laser.pwm.min" => 1,

    # STATE CONTROL
    "run.dry" => false,

))

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
nothing