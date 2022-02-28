function FN_DAMMfit(siteID, r)   
# load data, bin by quantiles, fit DAMM on it
  df = dropmissing(FN_load(siteID),
	    [:TS_F_MDS_1, :SWC_F_MDS_1, :NEE_CUT_USTAR50, :NIGHT, :NEE_CUT_USTAR50_QC])
  filter = df.NIGHT .== 1 .&& df.NEE_CUT_USTAR50_QC .== 0 # nighttime NEE, u* filtered, observation only
  T = df.TS_F_MDS_1[filter]
  M = df.SWC_F_MDS_1[filter]
  R = df.NEE_CUT_USTAR50[filter]
  n = 5 # 5 bins of T and M quantiles
  Tmed, Mmed, Rmed = qbins(T, M, R, n)
  Mmed = Mmed ./ 100
  poro_val = maximum(M) ./ 100
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
