using DataFrames, CSV, Dates

function getID()
	# get the path of folder files
	folders = readdir(joinpath("Input", "FLUXNET"), join = true);
	deleteat!(folders,1); # first folder is different
	n = length(folders);
	# retrieve a short ID for each site
	ID = []
	[push!(ID, folders[i][19:24]) for i = 1:n];
	return ID, folders, n
end

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

