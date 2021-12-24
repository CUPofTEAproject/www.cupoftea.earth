# This script generates the interactive figure in menu2 

include(joinpath("functions", "FLUXNET", "getID.jl"))
include(joinpath("functions", "FLUXNET", "loadFLUXNET.jl"))
include(joinpath("functions", "FLUXNET", "getID_filtered.jl"))
IDe, n_IDe = getIDe() # Needs to be global because getIDe() is slow
include(joinpath("functions", "FLUXNET", "FNDAMMfit.jl"))
include(joinpath("functions", "FLUXNET", "FNDAMMplot.jl"))

app = App() do session::Session    
	slider = JSServe.Slider(1:n_IDe)
	fig = FNDAMMplot(slider)[1]
	site = FNDAMMplot(slider)[2]
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end
