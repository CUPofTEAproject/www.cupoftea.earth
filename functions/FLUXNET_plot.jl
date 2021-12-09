using WGLMakie, JSServe

#=  
;cd ..
include(joinpath("functions", "FLUXNET", "load.jl"))
ID = getID()[1]
include(joinpath("functions", "quantilebins.jl"))

=#

# WIP! put these in function, then delete
# NOTE: needs raw data, no gap-filling
# e-mail FLUXNET to ask what filter to use to get raw data 
T = dropmissing(loadFLUXNET(ID[1]), [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).TS_F_MDS_1
M = dropmissing(loadFLUXNET(ID[1]), [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).SWC_F_MDS_1
R = dropmissing(loadFLUXNET(ID[1]), [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).RECO_NT_VUT_USTAR50
n = 10
qbin(T, M, R, n)


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


