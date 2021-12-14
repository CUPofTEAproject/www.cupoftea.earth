using GLMakie, UnicodeFun, SparseArrays
# using WGLMakie, UnicodeFun, SparseArrays, JSServe

# TO DO: clean script to get matrix to plot on DAMM surface
#=
r = 20
poro_val = 0.3
include("DAMM_scaled_porosity_2.jl")
params = [0.3, 64.0, 1.0, 1.0]
Ind_var = hcat(x,y)
Resp = DAMM(Ind_var, params)
=#

function DAMMmatrix(r) # resolution
  x = collect(range(1, length=r, stop=40)) # T axis, °C from 1 to 40
  y = collect(range(0, length=r, stop=poro_val)) # M axis, % from 0 to poro_val
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params)))
  return x, y, DAMM_Matrix
end

function plot3D(Ind_var, Resp)
	x, y, DAMM_Matrix = DAMMmatrix(40)
	fig = Figure()
	ax3D = Axis3(fig[1,1])
	ax3D.xlabel = to_latex("T_{soil} (°C)");
	ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
	ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");

	data3D = Vec3f0.(Ind_var[:, 1], Ind_var[:, 2], Resp)
	surface3D = DAMM_Matrix
	
	p3D = scatter!(ax3D, data3D, markersize = 2500, color = :black)
	surface!(ax3D, x, y, surface3D, colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false)
	wireframe!(ax3D, x, y, surface3D, overdraw = true, transparency = true, color = (:black, 0.1));

	#xlims!(0, 40)
	#ylims!(0, 0.7)
	#zlims!(0, 25)
	fig
end

