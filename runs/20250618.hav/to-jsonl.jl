@time begin
    using JSON3
    using Serialization
end

## --- . . . .-. -- - - -.- . -. .- .
let
    runsdir = "/Users/pereiro/.julia/dev/CSCReactor_HavV1/runs/hav"
    srcdir = joinpath(runsdir, "log")
    dstdir = joinpath(runsdir, "log.jsonl")
    mkpath(dstdir)

    for srcname in readdir(srcdir)
        endswith(srcname, ".jls") || continue
        srcpath = joinpath(srcdir, srcname)
        dstname = replace(srcname, ".jls" => ".jsonl")
        dstpath = joinpath(dstdir, dstname)
        logdat = deserialize(srcpath)
        open(dstpath, "w") do io
            for record in logdat
                println(io, JSON3.write(record)) 
            end
            # println(io, JSON.json(logdat, 0))
        end
    end

end


## --- . . . .-. -- - - -.- . -. .- .
