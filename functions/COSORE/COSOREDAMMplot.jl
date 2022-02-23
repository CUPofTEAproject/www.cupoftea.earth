function COSOREDAMMplot(slider)
  fig = Figure(resolution = (1000, 1000))
  ax3D = Axis3(fig[1, 1])
  # ax3D = LScene(fig[1, 1])
  site_n = slider.value
  siteID = @lift(IDe[$site_n])
  outs = @lift(COSOREDAMMfit($siteID, 10)) 
  # poro_val = @lift($outs[1])
  Tmed = @lift($outs[2])
  Mmed = @lift($outs[3])
  Rmed = @lift($outs[4])
  # params = @lift($outs[5])
  x = @lift($outs[6])
  y = @lift($outs[7])
  DAMM_Matrix = @lift($outs[8]) 
  ax3D.xlabel = to_latex("T_{soil} (°C)");
  ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
  ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  data3D = @lift(Vec3f.($Tmed, $Mmed, $Rmed))
  p3D = scatter!(ax3D, data3D, markersize = 2500, strokewidth = 3,
	color = Rmed, colormap = Reverse(:Spectral), colorrange = (0, 10))
  s3D = surface!(ax3D, x, y, DAMM_Matrix, colormap = Reverse(:Spectral),
	transparency = true, alpha = 0.01, shading = false, colorrange = (0, 10))
  w3D = wireframe!(ax3D, x, y, DAMM_Matrix, overdraw = true,
	transparency = true, color = (:black, 0.1));
  Colorbar(fig[1, 2], limits = (0, 10), colormap = Reverse(:Spectral),
	   label = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"));
  xlims!(ax3D, -20, 50)
  ylims!(ax3D, 0, 1.0)  
  zlims!(ax3D, 0, 10)
  fig
  return fig, siteID
end

#= MWE, from CUPofTEA home directory
using WGLMakie, DataFrames, CSV, Dates, DAMMmodel, SparseArrays
include(joinpath("functions", "COSORE", "getID.jl"))
include(joinpath("functions", "COSORE", "loadCOSORE.jl"))
include(joinpath("functions", "COSORE", "getID_filtered.jl"))
include(joinpath("functions", "COSORE", "COSOREDAMMfit.jl"))
IDe, n_IDe ,Ts_shallowest_name, SM_shallowest_name = getIDe() 
poro_val, Tmed, Mmed, Rmed, params, x, y, DAMM_Matrix = COSOREDAMMfit(IDe[1], 5)

=#

