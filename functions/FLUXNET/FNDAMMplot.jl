function FNDAMMplot(slider)
  fig = Figure()
  #=
  slider = Slider(fig[2, 1], range = [1, 3, 4, 5])
  =#
  ax3D = Axis3(fig[1, 1])
  #ax3D = LScene(fig[1, 1])
  site_n = slider.value
  siteID = @lift(ID[$site_n])
  outs = @lift(FNDAMMfit($siteID, 50)) 
  poro_val = @lift($outs[1])
  Tmed = @lift($outs[2])
  Mmed = @lift($outs[3])
  Rmed = @lift($outs[4])
  params = @lift($outs[5])
  x = @lift($outs[6])
  y = @lift($outs[7])
  DAMM_Matrix = @lift($outs[8]) 
  ax3D.xlabel = to_latex("T_{soil} (°C)");
  ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
  ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  data3D = @lift(Vec3f0.($Tmed, $Mmed, $Rmed))
  p3D = scatter!(ax3D, data3D, markersize = 2500, color = :black)
  s3D = surface!(ax3D, x, y, DAMM_Matrix, colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false)
  w3D = wireframe!(ax3D, x, y, DAMM_Matrix, overdraw = true, transparency = true, color = (:black, 0.1));
  #xlims!(0, 40)
  #ylims!(0, 0.7)
  #zlims!(0, 25)
  return fig, siteID
end
