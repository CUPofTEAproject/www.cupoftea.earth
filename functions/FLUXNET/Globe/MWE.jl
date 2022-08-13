using GLMakie 
using WGLMakie

fig = Figure(resolution = (400,400))

ax = Axis(fig[1,1])

x = Observable([1,2])

plot!(x,[1,2])

x[] = [1,1] # GLMakie: plot updated! WGLMakie: nothing happens

