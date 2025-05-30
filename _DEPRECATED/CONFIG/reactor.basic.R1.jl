CONFIG["R1"] = Dict(
    # EXTRAS
    "R.name" => "R1",
    "run.dry" => false,
    
    # PIN LAYOUT
    "pump.air.in.pin" => CONFIG["PIN.LAYOUT"]["PUMP_6_PIN"],
    # "pump.medium.out.pin" => CONFIG["PIN.LAYOUT"]["PUMP_2_PIN"],
    # "pump.medium.in.pin" => CONFIG["PIN.LAYOUT"]["PUMP_3_PIN"],
    "laser.pin" => CONFIG["PIN.LAYOUT"]["CH1_LASER_PIN"],
    "led.control.pin" => CONFIG["PIN.LAYOUT"]["CH1_CONTROL_LED_PIN"],
    "led.sample.pin" => CONFIG["PIN.LAYOUT"]["CH1_SAMPLE_LED_PIN"],
    
    # CONFIG
    "vial.working_volume" => 25.0, # mL [MEASSURED]
    
    "pump.medium.in.per_pulse_volume" => 0.03, # mL [MEASSURED]
    "pump.medium.in.pulse_duration" => 50.0, # ms
    
    "pump.medium.out.pulse_duration" => 150.0, # ms

    "laser.pwm.max" => 210,
    
    # MAIN CONTROL
    "dilution.target" => 1000.0, # 1/h

    # STATE
    "pump.medium.in.enable" => true,
    "pump.medium.in.pulse_period.min" => 0,
    "pump.medium.in.pulse_period.target" => 0,
    
    "pump.medium.out.enable" => true,
    "pump.medium.out.pulse_period.min" => 0,
    "pump.medium.out.pulse_period.target" => nothing,

    "pump.air.in.enable" => true,
    "pump.air.in.pulse_period.min" => 0,
    "pump.air.in.pulse_period.target" => nothing,
)

## ---.-.- ...- -- .--- . .- .-. . ..- .--.-
nothing