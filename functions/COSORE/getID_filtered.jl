# filter out dataset without soil moisture or temperature
# get name of shallowest soil moisture and temperature column

function getIDe() 
  inputs, ID = getID()
  IDe = String[]
  Ts_shallowest_name = String[]
  SM_shallowest_name = String[]
  for i = 1:length(ID)    
    df = loadCOSORE(ID[i])
    coln = names(df) # get column name of dataset    
# test if at least one soil temperature and moisture data column is present in dataset
    if length(names(df, r"CSR_T[0-9]")) >= 1 && length(names(df, r"CSR_SM[0-9]")) >= 1 
# keep shallowest T and SM      
      Ts_names = names(df, r"CSR_T[0-9]")
      Ts_depth = [Ts_names[j][6:end] for j = 1:length(Ts_names)]
      Ts_depth = parse.(Float64, Ts_depth)
      Ts_shallowest = findall(x -> x == minimum(Ts_depth), Ts_depth)
      SM_names = names(df, r"CSR_SM[0-9]")
      SM_depth = [SM_names[j][7:end] for j = 1:length(SM_names)]
      SM_depth = parse.(Float64, SM_depth)
      SM_shallowest = findall(x -> x == minimum(SM_depth), SM_depth)
      df = dropmissing(df, ["CSR_FLUX_CO2", SM_names[SM_shallowest][1], Ts_names[Ts_shallowest][1]])
      if isempty(df) == false
        push!(IDe, ID[i])
        push!(Ts_shallowest_name, Ts_names[Ts_shallowest][1])
        push!(SM_shallowest_name, SM_names[SM_shallowest][1])
        #printstyled("dataset ", i, ", ", ID[i], " [✔]\n"; color = :green);
      end
    else
      #printstyled("dataset ", i, ", ", ID[i], " [x]\n"; color = :red);
    end
  end
  n_IDe = length(IDe)
  Ts_shallowest_name = Dict(IDe .=> Ts_shallowest_name)
  SM_shallowest_name = Dict(IDe .=> SM_shallowest_name)
  return IDe, n_IDe, Ts_shallowest_name, SM_shallowest_name
end

#= MWE, run from CUPofTEA home directory
using DataFrames, CSV, Dates
include(joinpath("functions", "COSORE", "getID.jl"))
include(joinpath("functions", "COSORE", "loadCOSORE.jl"))
# this script takes a while to run (10 minutes?). Uncomment to print progress
IDe, n_IDe ,Ts_shallowest_name, SM_shallowest_name = getIDe() # run the function
IDe[1] # return a site ID, just like ID
n_IDe # number of FLUXNET datasets kept after the filter
=# 

