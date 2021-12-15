using WGLMakie, JSServe, SparseArrays, UnicodeFun, LsqFit

# note: to be run from CUPofTEA/
# move script when ready

include(joinpath("functions", "FLUXNET", "load.jl"))
ID = getID()[1] # should be called in functions that needs it instead of global
include(joinpath("functions", "quantilebins.jl")) # could be a new Julia package
include(joinpath("functions", "DAMMfit.jl")) # could be added to DAMMmodel.jl
include(joinpath("functions", "DAMM_scaled_porosity_2.jl")) # would be better to use package
include(joinpath("functions", "FLUXNET", "FNDAMMfit"))
include(joinpath("functions", "FLUXNET", "FNDAMMplot"))

# write new script or add more code in existing scripts:
# 1. filter FLUXNET data, only keep qc measurement (no gap-fill)
# 2. get only dataset that contain variables we need (Ts, M, R)
# 3. normalize (max resp = 10, M from 0 to 100, etc.)

app = App() do session::Session    
	# slider = JSServe.Slider([1, 3, 4, 5]) # not implemented right now, later
	slider = JSServe.Slider(3:6)
	fig = FNDAMMplot(slider)[1]
	site = FNDAMMplot(slider)[2]
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, site, fig))
end
