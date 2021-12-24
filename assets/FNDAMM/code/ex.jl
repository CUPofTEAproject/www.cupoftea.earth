# This file was generated, do not modify it. # hide
#hideall
using WGLMakie, JSServe, UnicodeFun, SparseArrays, LsqFit, DAMMmodel, DataFrames, CSV, Dates, Statistics
# could add a line to copy the .html in /__site/FNDAMM to /menu2/, which I do manually atm
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

include("FNDAMM.jl")
# ddd
show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))