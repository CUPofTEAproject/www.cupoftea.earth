+++
title = "FLUXNET globe"
+++

# FLUXNET globe

```julia:ex
#hideall
using WGLMakie, JSServe, CSV, DataFrames, Colors, ColorSchemes, FileIO, Downloads, GeometryBasics
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

include("carbvis_v2.jl")
# tes44t


show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))
```
\textoutput{ex}

v0.1.1

