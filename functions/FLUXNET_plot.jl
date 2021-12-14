using WGLMakie, JSServe, SparseArrays

#=  
;cd ..
include(joinpath("functions", "FLUXNET", "load.jl"))
ID = getID()[1]
include(joinpath("functions", "quantilebins.jl"))

=#

# WIP! put these in function, then delete
# NOTE: needs raw data, no gap-filling
# e-mail FLUXNET to ask what filter to use to get raw data 
T = dropmissing(loadFLUXNET(ID[i]), [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).TS_F_MDS_1
M = dropmissing(loadFLUXNET(ID[i]), [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).SWC_F_MDS_1
R = dropmissing(loadFLUXNET(ID[i]), [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).RECO_NT_VUT_USTAR50
n = 5
Tmed, Mmed, Rmed = qbin(T, M, R, n)

Tmed = Float64.(Tmed)
Mmed = Float64.(Mmed) ./100
Rmed = Float64.(Rmed)

# Matrix(sparse(Tmed, Mmed, Rmed))

#= testing with GLMakie first
using GLMakie
fig = Figure()
ax = Axis3(fig[1, 1])
# ax = LScene(fig[1, 1])
data = Point3f0.(Tmed, Mmed, Rmed)
p = plot!(ax, data, markersize = 5000)
#p = scatter!(ax, data, markersize = 100)
#s = surface!(ax, data)
fig
=#

include(joinpath("functions","DAMMfit.jl"))

poro_val = maximum(M)/100

params = fitDAMM(hcat(Tmed, Mmed), Rmed)

include(joinpath("functions","3Dplot.jl"))

plot3D(hcat(Tmed, Mmed), Rmed)


# to do: plot 3D scatter (as above)
# fit DAMM to it, plot DAMM surface





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

app = App() do session::Session    
	slider = JSServe.Slider(1:5)
	fig = FNplot(slider)[1]
	site = FNplot(slider)[2]
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end


