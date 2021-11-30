using Statistics
include("LoadCOSORE.jl");

n = length(Names)
df =  Dict(Names .=> [[] for i in 1:n])
Ts_names = Dict(Names .=> [[] for i in 1:n])
Ts_depth = Dict(Names .=> [[] for i in 1:n])
SWC_names = Dict(Names .=> [[] for i in 1:n])
SWC_depth = Dict(Names .=> [[] for i in 1:n])
Ts_shallowest = Dict(Names .=> [[] for i in 1:n])
Ts_shallowest_name = Dict(Names .=> [[] for i in 1:n])
SWC_shallowest = Dict(Names .=> [[] for i in 1:n])
SWC_shallowest_name = Dict(Names .=> [[] for i in 1:n])
#count = 0
for i in Names
	#count += 1
	println("Working on dataset ", i, "...")
	df[i] = Data[i]
	coln = names(df[i][1])
	Ts_names[i] = names(df[i][1], r"CSR_T[0-9]")
	Ts_depth[i] = [Ts_names[i][j][6:end] for j = 1:length(Ts_names[i])]
	Ts_depth[i] = parse.(Float64, Ts_depth[i])
	SWC_names[i] = names(df[i][1], r"CSR_SM[0-9]")
	SWC_depth[i] = [SWC_names[i][j][7:end] for j = 1:length(SWC_names[i])]
	SWC_depth[i] = parse.(Float64, SWC_depth[i])
	Ts_shallowest[i] = findall(x -> x == minimum(Ts_depth[i]), Ts_depth[i])
	Ts_shallowest_name[i] = Ts_names[i][Ts_shallowest[i]]
	SWC_shallowest[i] = findall(x -> x == minimum(SWC_depth[i]), SWC_depth[i])
	SWC_shallowest_name[i] = SWC_names[i][SWC_shallowest[i]]
	if (isempty(Ts_shallowest_name[i]) == true || isempty(SWC_shallowest_name[i]) == true) == false
		dropmissing!(df[i][1], ["CSR_FLUX_CO2", Ts_shallowest_name[i][1], SWC_shallowest_name[i][1]])
	end
	if isempty(df[i][1]) == false
		if (isempty(Ts_shallowest_name[i]) == true || isempty(SWC_shallowest_name[i]) == true) == false
			if median(df[i][1][!, SWC_shallowest_name[i][1]]) > 1 # some SWC are in % instead of m3 m-3
				println("SWC in % detected. Converting to m3 m-3.")
				df[i][1][!, SWC_shallowest_name[i][1]] = df[i][1][!, SWC_shallowest_name[i][1]]./100
			end
		end
	end
end

