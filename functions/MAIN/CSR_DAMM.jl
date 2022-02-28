include(joinpath("functions", "COSORE", "CSR_ID.jl"))
include(joinpath("functions", "COSORE", "CSR_load.jl"))
include(joinpath("functions", "COSORE", "CSR_IDf.jl"))
IDe, n_IDe, Ts_shallowest_name, SM_shallowest_name = CSR_IDf() # Needs to be global because getIDe() is slow
include(joinpath("functions", "COSORE", "CSR_DAMMfit.jl"))
include(joinpath("functions", "COSORE", "CSR_DAMMplot.jl"))

app = App() do session::Session    
	slider = JSServe.Slider(1:n_IDe)
	fig = CSR_DAMMplot(slider)[1]
	site = CSR_DAMMplot(slider)[2]
	sl = DOM.div("COSORE site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end
