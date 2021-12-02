+++
title = "FLUXNET test"
+++

```julia:ex
#hideall
using WGLMakie, JSServe, UnicodeFun, SparseArrays, Observables
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

include(joinpath("functions", "FLUXNET", "load.jl")) # e.g., loadFLUXNET("US-SLu")
ID = getID()[1]; # ID for FLUXNET sites
include(joinpath("functions", "FLUXNET_plot.jl")) # plot light response 

show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))
```
\textoutput{ex}

