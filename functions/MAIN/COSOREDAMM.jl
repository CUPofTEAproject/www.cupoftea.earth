# This script generates the interactive figure in menu2 

include(joinpath("functions", "COSORE", "getID.jl"))
include(joinpath("functions", "COSORE", "loadCOSORE.jl"))
include(joinpath("functions", "COSORE", "getID_filtered.jl"))
const IDe, n_IDe, Ts_shallowest_name, SM_shallowest_name = getIDe() # Needs to be global because getIDe() is slow
include(joinpath("functions", "COSORE", "COSOREDAMMfit.jl"))
include(joinpath("functions", "COSORE", "COSOREDAMMplot.jl"))

app = App() do session::Session    
	slider = JSServe.Slider(1:n_IDe)
	fig = COSOREDAMMplot(slider)[1]
	site = COSOREDAMMplot(slider)[2]
	sl = DOM.div("COSORE site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end
