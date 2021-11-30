# to do: put this script in a function

using DataFrames, CSV, StatsBase

# get the path of all COSORE input files
inputs = readdir(joinpath("Input", "COSORE", "datasets"), join = true);

# Retrieve a short name for each dataset
Names = []
# in loop below,
# 38 is the number of character in e.g., "Input/COSORE/datasets/data_d20190409_" 
# 4 is the number of character in ".csv"
[push!(Names, inputs[i][38:end-4]) for i = 1:length(inputs)];
Names

# Some names appear more than once, e.g. MATHES, 
# Need to numerize them e.g. MATHES1, MATHES2
# Note, this is something Ben Bond-Lamberty could update in next COSORE version
n = countmap(Names)
global d = []
for i = 1:length(n)
	if n[Names[i]] > 1
		global d = push!(d, Names[i]) 	
	end
end
#d = unique(d)
for i = 1:length(d)
	x = findfirst(x -> x == d[i], Names)
	Names[x] = string(Names[x], string(i))
end
# Note, Names work for now, but VARGAS1 and VARGAS2 would be better


# Create a Dictionary with name => dataframe
# e.g., Data["ZOU"] is ZOU site dataframe
Data = Dict(Names .=> [[] for i in 1:length(Names)]);
[push!(Data[Names[i]], DataFrame(CSV.File(inputs[i];
	dateformat="yyyy-mm-dd HH:MM:SS",
	missingstring="NA"))) for i = 1:length(Names)];


