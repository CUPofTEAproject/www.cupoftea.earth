using LsqFit

include("DAMM_scaled_porosity_2.jl");

lb = [0.0, 0.0, 0.0, 0.0] # params can't be negative
ub = [Inf, Inf, Inf, Inf] 
p_ini = [0.3, 64.0, 1.0, 1.0]

function fitDAMM(Ind_var, Resp)
	fit = curve_fit(DAMM, Ind_var, Resp, p_ini, lower=lb, upper=ub)
	params = coef(fit)
end

