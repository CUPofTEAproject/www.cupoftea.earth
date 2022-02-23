# Get COSORE short ID
# I suggested to recude to short unique ID... 

using DataFrames, CSV, StatsBase

function getID()
# from home directory
# get the path of all COSORE input files
  inputs = readdir(joinpath("input", "COSORE", "datasets"), join = true);
# Retrieve a short name for each dataset
  Names = []
# in loop below,
# 29 is the number of character in "Input/COSORE/datasets/data_d" 
# 4 is the number of character in ".csv"
  [push!(Names, inputs[i][29:end-4]) for i = 1:length(inputs)];
return inputs, Names
end

