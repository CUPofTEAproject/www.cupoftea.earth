function CSR_ID()
# get the path of all COSORE input files
  inputs = readdir(joinpath("input", "COSORE", "datasets"), join = true);
# Retrieve a short name for each dataset
  ID = []
# in loop below,
# 29 is the number of character in "Input/COSORE/datasets/data_d" 
# 4 is the number of character in ".csv"
  [push!(ID, inputs[i][29:end-4]) for i = 1:length(inputs)];
return inputs, ID
end

#= MWE, from CUPofTEA home directory
using DataFrames, CSV, StatsBase
inputs, ID = CSR_ID()
=#

