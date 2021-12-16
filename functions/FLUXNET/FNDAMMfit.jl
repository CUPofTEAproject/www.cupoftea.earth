function FNDAMMfit(siteID, r)   
  T = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).TS_F_MDS_1
  M = dropmissing(loadFLUXNET(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).SWC_F_MDS_1
  R = dropmissing(loadFLUXNET(siteID), 
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50]).RECO_NT_VUT_USTAR50
  n = 5 # 5 bins of T and M quantiles 
  Tmed = Float64.(qbin(T, M, R, n)[1])
  Mmed = Float64.(qbin(T, M, R, n)[2]) ./100
  Rmed = Float64.(qbin(T, M, R, n)[3])
  params = fitDAMM(hcat(Tmed, Mmed), Rmed)
  poro_val = params[5]
# DAMMmatrix
  x = collect(range(1, length=r, stop=40)) # T axis, °C from 1 to 40
  y = collect(range(0, length=r, stop=poro_val)) # M axis, % from 0 to poro_val
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params)))
  #return x, y, DAMM_Matrix
  return poro_val, Tmed, Mmed, Rmed, params, x, y, DAMM_Matrix
end
