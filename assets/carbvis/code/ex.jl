# This file was generated, do not modify it. # hide
#hideall
using WGLMakie, JSServe, CSV, DataFrames, Colors, ColorSchemes, FileIO, Downloads, GeometryBasics
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

include("carbvis.jl")
# testu1


show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))