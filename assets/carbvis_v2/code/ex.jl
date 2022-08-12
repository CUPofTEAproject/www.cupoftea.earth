# This file was generated, do not modify it. # hide
#hideall
using WGLMakie, JSServe, CSV, DataFrames, Colors, ColorSchemes, FileIO, Downloads, GeometryBasics
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

include("carbvis_v2.jl")
# test


show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))