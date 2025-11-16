@time begin
    using CSCReactor_HavV1
    using CairoMakie
end

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
#=
    control the amount of time of each log batch
=#

## .. - .- --- .- .-. --- .- .-. -.--- .. . ..
# include
include("0.base.jl")

## -.- .- - -.. .   . .--- - -- .- .- . - .- .- -.
# 
foreach_log(
    # maxlogs = Int(1e0),
    # maxfiles = Int(1e0)
) do res
    try
        # log/13-05-2025-04-50.jls
        file0 = res["__file__"]
        isfile(file0) || return :breakfile
        @show file0
        datestr0 = replace(basename(file0), ".jls" => "")
        @show datestr0
        date0 = DateTime(datestr0, "dd-mm-yyyy-HH-MM")
        @show date0
        datestr1 = Dates.format(date0, "yyyymmdd-HHMM")
        @show datestr1
        file1 = joinpath(dirname(file0), string(datestr1, ".jls"))
        @show file1
    catch err
        return :breakfile
    end
end