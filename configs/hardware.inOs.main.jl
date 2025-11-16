get!(CONFIG, "INOS", Dict())
merge!(CONFIG["INOS"], Dict(
    "ino.baudrate" => 19200,
    "registered.ports" => [
        "/dev/cu.usbmodem14101",
        "/dev/cu.usbmodem14201",
        "/dev/cu.usbmodem141101",
        "/dev/tty.usbmodem14101",
        "/dev/ttyACM0", 
        "/dev/tty.usdmodem101", 
        "/dev/cu.usbmodem101"
    ]
))