using DataFrames, CSV, Dates
include("getID.jl")

# change current directory to home
# function to load dataset based on ID
function loadCOSORE(site) # site = e.g. Names[1]
  inputs, Names = getID()
# Dict: ID => path of input files
  paths = Dict(Names .=> inputs); 
  data = DataFrame(CSV.File(paths[site];
  dateformat="yyyy-mm-dd HH:MM:SS",
  missingstring="NA"))
return data
end

