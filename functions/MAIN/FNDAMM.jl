include(joinpath("functions", "FLUXNET", "load.jl"))
ID = getID()[1] # should be called in functions that needs it instead of global
include(joinpath("functions", "quantilebins.jl")) # could be added to DAMMmodel.jl
include(joinpath("functions", "DAMMfit.jl")) # could be added to DAMMmodel.jl 
include(joinpath("functions", "FLUXNET", "getID_filtered.jl"))
IDe, n_IDe = getIDe(ID)
include(joinpath("functions", "FLUXNET", "FNDAMMfit.jl"))
include(joinpath("functions", "FLUXNET", "FNDAMMplot.jl"))

app = App() do session::Session    
	slider = JSServe.Slider(1:50)
	fig = FNDAMMplot(slider)[1]
	site = FNDAMMplot(slider)[2]
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end
