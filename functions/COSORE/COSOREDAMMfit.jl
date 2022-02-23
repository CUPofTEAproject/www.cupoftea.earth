function COSOREDAMMfit(siteID, r)   
# load data, bin by quantiles, fit DAMM on it
  df = dropmissing(loadCOSORE(siteID),
       [Ts_shallowest_name[siteID], SM_shallowest_name[siteID], "CSR_FLUX_CO2"])
  T = df[!, Ts_shallowest_name[siteID]] 
  M = df[!, SM_shallowest_name[siteID]]
  if median(M) > 1
    M = M ./ 100
  end
  R = df.CSR_FLUX_CO2
  n = 5 # 5 bins of T and M quantiles
  Tmed, Mmed, Rmed = qbins(T, M, R, n)
  poro_val = maximum(M)
  params = DAMMfit(hcat(Tmed, Mmed), Rmed, poro_val)  
# create x y arrays, and z matrix, to plot DAMM surface
  x = collect(range(minimum(Tmed), length=r, stop=maximum(Tmed))) # T axis, °C from min to max
  y = collect(range(minimum(Mmed), length=r, stop=maximum(Mmed))) # M axis, % from min to max
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params)))
  return poro_val, Tmed, Mmed, Rmed, params, x, y, DAMM_Matrix
end

#= MWE, from CUPoTEA home directory
using DataFrames, CSV, Dates, DAMMmodel, SparseArrays
include(joinpath("functions", "COSORE", "getID.jl"))
include(joinpath("functions", "COSORE", "loadCOSORE.jl"))
include(joinpath("functions", "COSORE", "getID_filtered.jl"))
IDe, n_IDe ,Ts_shallowest_name, SM_shallowest_name = getIDe() 
poro_val, Tmed, Mmed, Rmed, params, x, y, DAMM_Matrix = COSOREDAMMfit(IDe[1], 5)
=#

