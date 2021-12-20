function getIDe(ID) # works, just need to add it, redo figure, commit etc.
  IDe = [];
  for i = 1:length(ID)
    coln = names(loadFLUXNET(ID[i])) # get column name of dataset
    if "TS_F_MDS_1" in coln && "SWC_F_MDS_1" in coln && "RECO_NT_VUT_USTAR50" in coln 
      if isempty(dropmissing(loadFLUXNET(ID[i]), 
	 [:TS_F_MDS_1, :SWC_F_MDS_1, :RECO_NT_VUT_USTAR50])) == false
           # println("data ", i, ", ", ID[i])
           push!(IDe, ID[i]) 
      end
    end
  end
  n_IDe = length(IDe)
  return IDe, n_IDe
end
