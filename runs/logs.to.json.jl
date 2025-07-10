@time begin
    using CSCReactor_HavV1
    using JSON
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")
include("bash.basic.v1-0.base.jl")

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
let
    logs_jsondir = joinpath(@__DIR__, "logs_json")
    mkpath(logs_jsondir)
    logs_jlsdir = joinpath(@__DIR__, "log")
    jls_files = readdir(logs_jlsdir; join = true)
    for jls_file in jls_files
        endswith(jls_file, ".jls") || continue
        jls = deserialize(jls_file)
        json_name = replace(basename(jls_file), ".jls" => ".json")
        json_file = joinpath(logs_jsondir, json_name)
        @show jls_file
        isfile(json_file) && continue
        @show json_file

        open(json_file, "w") do io
            print(io, JSON.json(jls))
        end
    end

end