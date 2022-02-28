# function to load dataset based on ID
function CSR_load(site) # site = e.g. Names[1]
  inputs, ID = CSR_ID()
# Dict: ID => path of input files
  paths = Dict(ID .=> inputs); 
  data = DataFrame(CSV.File(paths[site];
  dateformat="yyyy-mm-dd HH:MM:SS",
  missingstring="NA"))
return data
end

#= MWE, from CUPofTEA home
using DataFrames, CSV, Dates
include(joinpath("functions","COSORE","CSR_ID.jl"))
inputs, ID = CSR_ID()
CSR_load(ID[1])
=#

