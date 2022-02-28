+++
title = "DAMM COSORE"
+++

# DAMM model fitted to COSORE sites

```julia:ex
#hideall
using WGLMakie, JSServe, UnicodeFun, SparseArrays, LsqFit, DAMMmodel, DataFrames, CSV, Dates, Statistics
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

include("CSR_DAMM.jl")

show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))
```
\textoutput{ex}

v0.1.1

