function FN_ID()
	# get the path of folder files
	folders = readdir(joinpath("input", "FLUXNET"), join = true);
	deleteat!(folders,1); # first folder is different
	n = length(folders);
	# retrieve a short ID for each site
	ID = String[]
	[push!(ID, folders[i][19:24]) for i = 1:n];
	return ID, folders, n
end

#= MWE, run from CUPofTEA of directory 
ID, folders, n = FN_ID(); # run function
ID # short ID for each site 
folders # path to folder containing data file
n # number of datasets
=#
