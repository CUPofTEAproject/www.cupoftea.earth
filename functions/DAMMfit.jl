using LsqFit

include("DAMM_scaled_porosity.jl");

lb = [0.0, 0.0, 0.0] # params can't be negative
ub = [Inf, Inf, Inf] 
p_ini = [1.7, 5.9, 3.15]

function fitDAMM(Ind_var, Resp)
	fit = curve_fit(DAMM, Ind_var, Resp, p_ini, lower=lb, upper=ub)
	params = coef(fit)
end

