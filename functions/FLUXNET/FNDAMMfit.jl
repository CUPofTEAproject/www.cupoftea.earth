# write a normalize function to shorten code below
# Also, Tmed, Mmed and Rmed should be calculated in 1 line of code

function FNDAMMfit(siteID, r)   
  T = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).TS_F_MDS_1
  M = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).SWC_F_MDS_1
  R = dropmissing(loadFLUXNET(siteID), 
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).RECO_NT_VUT_USTAR50
  n = 5 # 5 bins of T and M quantiles 
  Tmed = Float64.(qbin(T, M, R, n)[1]) 
  Tmed_N = Tmed .+ -minimum(Tmed) # move min temp to 0 
  Tmed_N = Tmed_N .* 10/maximum(Tmed_N) # normalize max T to 10
  Mmed = Float64.(qbin(T, M, R, n)[2]) ./100 
  Mmed_N = Mmed .+ -minimum(Mmed)
  Mmed_N = Mmed_N .* 0.5/maximum(Mmed_N)
  Rmed = Float64.(qbin(T, M, R, n)[3])
  Rmed_N = Rmed .+ -minimum(Rmed) 
  Rmed_N = Rmed_N .* 10/maximum(Rmed_N) # normalize max R to 10
  global poro_val = maximum(M) ./ 100
  params = fitDAMM(hcat(Tmed, Mmed), Rmed) # still problem of M > poro_val ... 
  # params_N = fitDAMM(hcat(Tmed_N, Mmed_N), Rmed_N)
  # poro_val = params[5]
  poro_val_N = (poro_val - minimum(Mmed)) * 0.5/maximum(Mmed_N)
# DAMMmatrix
  x = collect(range(minimum(Tmed), length=r, stop=maximum(Tmed))) # T axis, °C from min to max
  y = collect(range(minimum(Mmed), length=r, stop=maximum(Mmed))) # M axis, % from min to max
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params)))
  #return x, y, DAMM_Matrix
  return poro_val, Tmed, Mmed, Rmed, params, x, y, DAMM_Matrix
end
