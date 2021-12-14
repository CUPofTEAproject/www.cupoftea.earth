using WGLMakie, JSServe, SparseArrays, UnicodeFun

#=  
;cd ..
using GLMakie, SparseArrays, UnicodeFun
include(joinpath("functions", "FLUXNET", "load.jl"))
ID = getID()[1]
include(joinpath("functions", "quantilebins.jl"))

siteID = ID[1] 

=#

# WIP! put these in function, then delete
# NOTE: needs raw data, no gap-filling
# e-mail FLUXNET to ask what filter to use to get raw data

# seems like I need to give initial value to poro_val, or fix this issue
poro_val = 0.5 # temp

# need to filter out sites that don't have TS or SWC or RECO (e.g., site 2 doesn't have TS)

function FNDAMMfit(siteID, r)   
  T = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).TS_F_MDS_1
  M = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).SWC_F_MDS_1
  R = dropmissing(loadFLUXNET(siteID), 
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).RECO_NT_VUT_USTAR50
  n = 5 # 5 bins of T and M quantiles 
  Tmed = Float64.(qbin(T, M, R, n)[1])
  Mmed = Float64.(qbin(T, M, R, n)[2]) ./100
  Rmed = Float64.(qbin(T, M, R, n)[3])
  # meds = hcat(Tmed, Mmed, Rmed)
  poro_val = maximum(M)/100 
  include(joinpath("functions", "DAMMfit.jl"))  # can it be outside of function?
  params = fitDAMM(hcat(Tmed, Mmed), Rmed)
  # DAMMmatrix
  x = collect(range(1, length=r, stop=40)) # T axis, °C from 1 to 40
  y = collect(range(0, length=r, stop=poro_val)) # M axis, % from 0 to poro_val
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params)))
  #return x, y, DAMM_Matrix
  return poro_val, Tmed, Mmed, Rmed, params, x, y, DAMM_Matrix
end

# poro_val might create issues, because it's a Float64 on first call,
# and then an observable
# maybe need to add poro_val as an argument in functions that use it

function FNDAMMplot()
  fig = Figure()
  #=
  slider = Slider(fig[2, 1], range = 1:5)
  =#
  ax3D = Axis3(fig[1, 1])	
  site_n = slider.value
  siteID = @lift(ID[$site_n])
  outs = @lift(FNDAMMfit($siteID, 50)) # sometime bug, not sure why yet. probably poro_val issue.
  				       # don't forget to re-initialize slider, commented out above
  poro_val = @lift($outs[1])
  Tmed = @lift($outs[2])
  Mmed = @lift($outs[3])
  Rmed = @lift($outs[4])
  params = @lift($outs[5])
  x = @lift($outs[6])
  y = @lift($outs[7])
  DAMM_Matrix = @lift($outs[6]) 
  ax3D.xlabel = to_latex("T_{soil} (°C)");
  ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
  ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  Ind_var = @lift(hcat($Tmed, $Mmed)) # might be not needed
  data3D = @lift(Vec3f0.($Tmed, $Mmed, $Rmed))
  # surface3D = DAMM_Matrix
  p3D = scatter!(ax3D, data3D, markersize = 2500, color = :black)

  surface!(ax3D, x, y, DAMM_Matrix, colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false)
  wireframe!(ax3D, x, y, DAMM_Matrix, overdraw = true, transparency = true, color = (:black, 0.1));

  #xlims!(0, 40)
  #ylims!(0, 0.7)
  #zlims!(0, 25)
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
	slider = JSServe.Slider(1:5)
	fig = FNplot(slider)[1]
	site = FNplot(slider)[2]
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end

