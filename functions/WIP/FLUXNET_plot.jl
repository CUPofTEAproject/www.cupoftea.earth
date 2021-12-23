using WGLMakie, JSServe, SparseArrays, UnicodeFun, LsqFit

#=  
;cd ..
using GLMakie, SparseArrays, UnicodeFun, LsqFit, DAMMmodel, DataFrames, CSV, Dates, Statistics
include(joinpath("functions", "FLUXNET", "load.jl"))
ID = getID()[1]
siteID = ID[1]

=#

function getIDe(ID) # works, just need to add it, redo figure, commit etc.
  IDe = [];
  for i = 1:4 # length(ID)
    coln = names(loadFLUXNET(ID[i])) # get column name of dataset
    if "TS_F_MDS_1" in coln && "SWC_F_MDS_1" in coln && "NEE_CUT_USTAR50" in coln && "NIGHT" in coln && "NEE_CUT_USTAR50_QC" in coln
      if isempty(dropmissing(loadFLUXNET(ID[i]), 
	 [:TS_F_MDS_1, :SWC_F_MDS_1, :NEE_CUT_USTAR50, :NIGHT, :NEE_CUT_USTAR50_QC])) == false
           println("dataset ", i, ", ", ID[i])
           push!(IDe, ID[i]) 
      end
    end
  end
  n_IDe = length(IDe)
  return IDe, n_IDe
end
IDe, n_IDe = getIDe(ID)

function FNDAMMfit(siteID, r)
  df = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :NEE_CUT_USTAR50, :NIGHT, :NEE_CUT_USTAR50_QC])
  filter = df.NIGHT .== 1 .&& df.NEE_CUT_USTAR50_QC .== 0 # nighttime NEE, u* filtered, observation only
  T = df.TS_F_MDS_1[filter]
  M = df.SWC_F_MDS_1[filter]
  R = df.NEE_CUT_USTAR50[filter]
  n = 5 # 5 bins of T and M quantiles

  Tmed, Mmed, Rmed = qbin(T, M, R, n)
  Mmed = Mmed ./ 100

  # Tmed = Float64.(qbin(T, M, R, n)[1]) 
  #Tmed_N = Tmed .+ -minimum(Tmed) # move min temp to 0 
  #Tmed_N = Tmed_N .* 10/maximum(Tmed_N) # normalize max T to 10
  #Mmed = Float64.(qbin(T, M, R, n)[2]) ./100 
  #Mmed_N = Mmed .+ -minimum(Mmed)
  #Mmed_N = Mmed_N .* 0.5/maximum(Mmed_N)
  #Rmed = Float64.(qbin(T, M, R, n)[3])
  #Rmed_N = Rmed .+ -minimum(Rmed) 
  #Rmed_N = Rmed_N .* 10/maximum(Rmed_N) # normalize max R to 10
  poro_val = maximum(M) ./100
  params = fitDAMM(hcat(Tmed, Mmed), Rmed, poro_val)
  # params_N = fitDAMM(hcat(Tmed_N, Mmed_N), Rmed_N)
  # poro_val = params[5]
  #poro_val_N = (poro_val - minimum(Mmed)) * 0.5/maximum(Mmed_N)
# DAMMmatrix
  x = collect(range(minimum(Tmed), length=r, stop=maximum(Tmed))) # T axis, °C from 1 to 40
  y = collect(range(minimum(Mmed), length=r, stop=maximum(Mmed))) # M axis, % from 0 to poro_val
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params)))
  #return x, y, DAMM_Matrix
  return poro_val, Tmed, Mmed, Rmed, params, x, y, DAMM_Matrix
end

function FNDAMMplot(slider)
  fig = Figure()
  #=
  slider = Slider(fig[2, 1], range = [1, 3, 4, 5])
  =#
  ax3D = Axis3(fig[1, 1])
  #ax3D = LScene(fig[1, 1])
  site_n = slider.value
  siteID = @lift(IDe[$site_n])
  outs = @lift(FNDAMMfit($siteID, 50)) 
  # poro_val_o = @lift($outs[1]) # do we even need to return poro_val?
  Tmed = @lift($outs[2]) # needed below for data3D
  Mmed = @lift($outs[3])
  Rmed = @lift($outs[4])
  # params = @lift($outs[5]) # do we need this?
  x = @lift($outs[6]) # needed below
  y = @lift($outs[7])
  DAMM_Matrix = @lift($outs[8]) # needed below 
  ax3D.xlabel = to_latex("T_{soil} (°C)");
  ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
  ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  data3D = @lift(Vec3f0.($Tmed, $Mmed, $Rmed))
  p3D = scatter!(ax3D, data3D, markersize = 2500, strokewidth = 3,
		 color = Rmed, colormap = Reverse(:Spectral), colorrange = (0, 10))
  s3D = surface!(ax3D, x, y, DAMM_Matrix,
        colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false, colorrange = (0, 10))
  w3D = wireframe!(ax3D, x, y, DAMM_Matrix,
        overdraw = true, transparency = true, color = (:black, 0.1));
  Colorbar(fig[1, 2], limits = (0, 10), colormap = Reverse(:Spectral));
  # Legend(fig[1, 2], [p3D, s3D], ["Observation", "DAMM"]) # not supported yet
  # autolimits!(ax3D)
  xlims!(-10, 45)
  ylims!(0, 1.0)
  zlims!(0, 10)
  fig
  return fig, siteID
end

#=
function FNplot(slider)
	fig = Figure()
	# slider = Slider(fig[1, 1], range = 1:5)
	ax = Axis(fig[1, 1])	
	site_n = slider.value
	test = @lift(ID[$site_n])
	data = @lift(Point2f0.(dropmissing(loadFLUXNET(ID[$site_n]), [:SW_IN_POT, :GPP_DT_CUT_50]).SW_IN_POT, 
		               dropmissing(loadFLUXNET(ID[$site_n]), [:SW_IN_POT, :GPP_DT_CUT_50]).GPP_DT_CUT_50)) 	
	p = plot!(ax, data)
	return fig, test
end
=#

app = App() do session::Session    
	# slider = JSServe.Slider([1, 3, 4, 5]) # not implemented right now, later
	slider = JSServe.Slider(3:6)
	fig = FNDAMMplot(slider)[1]
	site = FNDAMMplot(slider)[2]
	# params 
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end

