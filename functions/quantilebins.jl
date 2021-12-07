using DataFrames, Statistics
# to test/build function create df with 3 rand column
df = DataFrame(R=1:20, T=6:25, M=11:30)
n = 3 # number of quantiles
Tq = quantile(df.T, 0:1/n:1)

# a bin of T is > and < a quantile
# for each bin of T, get quantiles of M
Mbin1 = df.M[df.T .>= Tq[1] .&& df.T .<= Tq[2]]

Mbin1_q = quantile(Mbin1, 0:1/n:1)

Rbin1 = median(df.R[df.T .>= Tq[1] .&& df.T .<= Tq[2] .&& df.M .>= Mbin1_q[1] .&& df.M .<= Mbin1_q[2]])


# function bindata(x, y, z, X)
# z = f(x,y), e.g., Reco = f(Tsoil, SWC)
# 1. bin x into X quantiles (containing k% of z data)
# 2. for each quantile, bin y into X quantiles
# 3. for each x and y bin, calculate the median of z


# other script:
# then, normalize z (e.g., max = 10)
# normalize SWC (wettest = 100, driest = 0)
# normalize Tsoil or not?

# other script: 
# plot binned normalized z = f(x,z), for all COSORE and FLUXNET sites

# other script: 
# get DAMM param for all binned normalized z = f(x, z) 

# other script: 
# plot those DAMM param for FLUXNET and COSORE, by biome and climate

# later: do same analysis with CMIP6, Reco and Rsoil

