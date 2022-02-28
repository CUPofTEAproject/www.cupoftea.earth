include(joinpath("functions", "FLUXNET", "FN_ID.jl"))
include(joinpath("functions", "FLUXNET", "FN_load.jl"))
include(joinpath("functions", "FLUXNET", "FN_IDf.jl"))
IDe, n_IDe = FN_IDf() # Needs to be global because FN_IDf() is slow
include(joinpath("functions", "FLUXNET", "FN_DAMMfit.jl"))
include(joinpath("functions", "FLUXNET", "FN_DAMMplot.jl"))

app = App() do session::Session    
	slider = JSServe.Slider(1:n_IDe)
	fig = FN_DAMMplot(slider)[1]
	site = FN_DAMMplot(slider)[2]
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end
