# dynamic data
# - for instance, arguments of routines
const STATE = Dict{String, Any}()

# Should be static, only what is load at the begining
const CONFIG = Dict{String, Any}()

# code blocks
const ROUTINES = Dict{String, Function}()

# Extra info for logs
const LOG_EXTRAS = Dict{String, Any}()