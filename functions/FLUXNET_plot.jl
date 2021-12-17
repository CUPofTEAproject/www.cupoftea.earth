using WGLMakie, JSServe, SparseArrays, UnicodeFun, LsqFit

#=  
;cd ..
using GLMakie, SparseArrays, UnicodeFun, LsqFit
include(joinpath("functions", "FLUXNET", "load.jl"))
ID = getID()[1]
include(joinpath("functions", "quantilebins.jl"))

siteID = ID[5]
include(joinpath("functions", "DAMMfit.jl")) 
include(joinpath("functions", "DAMM_scaled_porosity_2.jl"))

=#

# WIP! put these in function, then delete
# NOTE: needs raw data, no gap-filling
# e-mail FLUXNET to ask what filter to use to get raw data

# seems like I need to give initial value to poro_val, or fix this issue

###################### to do ######################################
# need to filter out sites that don't have TS or SWC or RECO (e.g., site 2 doesn't have TS)
###################################################################
#
# maybe create a vector of the site that do have data
# e.g., [1, 3, 4, 6, ..., 200] for the 200 sites
# then use those values for the slider
# seems to work, see below. Just need to automate creation of this array

##################### to do #####################################
# split this script into multiple scripts and functions
#################################################################

#################### to do ########################
# do this with WGLMakie instead of GLMakie, then put on Franklin
###################################################

function FNDAMMfit(siteID, r)   
  T = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).TS_F_MDS_1
  M = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).SWC_F_MDS_1
  R = dropmissing(loadFLUXNET(siteID), 
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).RECO_NT_VUT_USTAR50
  n = 5 # 5 bins of T and M quantiles 
  Tmed = Float64.(qbin(T, M, R, n)[1]) 
  Tmed_N = Tmed .+ -minimum(Tmed) # move min temp to 0 
  Tmed_N = Tmed_N .* 10/maximum(Tmed_N) # normalize max T to 10
  Mmed = Float64.(qbin(T, M, R, n)[2]) ./100 
  Mmed_N = Mmed .+ -minimum(Mmed)
  Mmed_N = Mmed_N .* 0.5/maximum(Mmed_N)
  Rmed = Float64.(qbin(T, M, R, n)[3])
  Rmed_N = Rmed .+ -minimum(Rmed) 
  Rmed_N = Rmed_N .* 10/maximum(Rmed_N) # normalize max R to 10
  params = fitDAMM(hcat(Tmed, Mmed), Rmed)
  params_N = fitDAMM(hcat(Tmed_N, Mmed_N), Rmed_N)
  poro_val = params[5]
  poro_val_N = (poro_val - minimum(Mmed)) * 0.5/maximum(Mmed_N)
# DAMMmatrix
  x = collect(range(minimum(Tmed_N), length=r, stop=maximum(Tmed_N))) # T axis, °C from 1 to 40
  y = collect(range(minimum(Mmed_N), length=r, stop=maximum(Mmed_N))) # M axis, % from 0 to poro_val
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params_N)))
  #return x, y, DAMM_Matrix
  return poro_val_N, Tmed_N, Mmed_N, Rmed_N, params_N, x, y, DAMM_Matrix
end

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
  s3D = surface!(ax3D, x, y, DAMM_Matrix,
        colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false)
  w3D = wireframe!(ax3D, x, y, DAMM_Matrix,
        overdraw = true, transparency = true, color = (:black, 0.1));
  autolimits!(ax3D)
  #xlims!(0, 40)
  #ylims!(0, 0.7)
  #zlims!(0, 25)
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
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end

