function loadFLUXNET(site)
	ID, folders, n = getID();	
	# get the path of input files
	paths = Dict(ID .=> [readdir(folders[i], join = true)[9] for i in 1:n]);
	# load data corresponding to ID
	data = DataFrame(CSV.File(paths[site];
	dateformat="yyyymmddHHMM",
	types = Dict([:TIMESTAMP_START, :TIMESTAMP_END] .=> DateTime),
	missingstring="-9999"));
	return data
end

#= MWE, run from CUPofTEA home directory
using Dates, DataFrames, CSV # load package
include(joinpath("functions", "FLUXNET", "getID.jl")) # load getID.jl
ID = getID()[1] # first output of getID.jl
i = 1 # there are 206 FLUXNET datasets
site = ID[i] # FLUXNET site 1 ID, "AR-SLu"
loadFLUXNET(site) # load "AR-SLu" dataset 
=#
