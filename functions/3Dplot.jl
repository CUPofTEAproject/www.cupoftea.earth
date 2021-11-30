using GLMakie, UnicodeFun, SparseArrays
# using WGLMakie, UnicodeFun, SparseArrays, JSServe

L = 40 # resolution, and max T
x_ax = collect(range(1, length=L, stop=L))

xD = collect(range(1, length=L, stop=1))
[append!(xD, collect(range(i, length=L, stop=i))) for i = 2:L]
xD = reduce(vcat, xD)
yD = collect(range(0, length=L, stop=poro_val))
yD = repeat(yD, outer=L)
x_range = hcat(xD, yD)

xD = Int.(x_range[:, 1])
y_ax = collect(range(0, length=L, stop=poro_val))
yD = collect(range(1, length=L, stop=L))
yD = repeat(yD, outer=L)
yD = Int.(yD)

DAMM_Matrix = Matrix(sparse(xD, yD, DAMM(x_range, params)))

function plot3D(Ind_var, Resp)
	fig = Figure()
	ax3D = Axis3(fig[1,1])
	ax3D.xlabel = to_latex("T_{soil} (°C)");
	ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
	ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");

	data3D = Vec3f0.(Ind_var[:, 1], Ind_var[:, 2], Resp)
	surface3D = DAMM_Matrix
	
	p3D = scatter!(ax3D, data3D, markersize = 1000, color = :black)
	surface!(ax3D, x_ax, y_ax, surface3D, colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false)
	wireframe!(ax3D, x_ax, y_ax, surface3D, overdraw = true, transparency = true, color = (:black, 0.1));

	xlims!(0, 40)
	ylims!(0, 0.7)
	zlims!(0, 25)
	fig
end



