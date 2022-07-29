+++
title = "TEST plot"
+++

# simple slider

```julia:ex
#hideall
using WGLMakie, JSServe
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

include("WGLMakie_slider_MWE.jl")

show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))
```
\textoutput{ex}

v0.1.1

