using GLMakie

v = [[1,2,3], [1,4,6], [0,5,10]]
fig = Figure(resolution = (400, 400))
ax3D = Axis3(fig[1, 1])
sl = Slider(fig[2, 1], range = 1:1:3, startvalue = 1)
s = sl.value
data = @lift(Vec3f.(v[$s], v[$s], v[$s]))
p3D = scatter!(ax3D, data, markersize = 20, strokewidth = 2)
xlims!(ax3D, 0, 10) 
ylims!(ax3D, 0, 10)
zlims!(ax3D, 0, 10)
fig

