function getIDe(ID) # works, just need to add it, redo figure, commit etc.
  IDe = [];
  for i = 1:length(ID)    
    df = loadFLUXNET(ID[i])
    coln = names(df) # get column name of dataset    
    if "TS_F_MDS_1" in coln && "SWC_F_MDS_1" in coln && "NEE_CUT_USTAR50" in coln && "NIGHT" in coln && "NEE_CUT_USTAR50_QC" in coln
      df = dropmissing(df, [:TS_F_MDS_1, :SWC_F_MDS_1, :NEE_CUT_USTAR50, :NIGHT, :NEE_CUT_USTAR50_QC])
      filter = df.NIGHT .== 1 .&& df.NEE_CUT_USTAR50_QC .== 0
      if isempty(df) == false
	if count(filter) .>= 200
	  #printstyled("dataset ", i, ", ", ID[i], " [✔]\n"; color = :green);
          push!(IDe, ID[i])
          else
	  #printstyled("dataset ", i, ", ", ID[i], " skipped, less than 200 observations [✖]\n"; color = :red);
        end
        else
	  #printstyled("dataset ", i, ", ", ID[i], " skipped, empty column [✖]\n"; color = :red); 
      end
      else
	#printstyled("dataset ", i, ", ", ID[i], " skipped, missing column [✖]\n"; color = :red);
    end
  end
  n_IDe = length(IDe)
  return IDe, n_IDe
end
