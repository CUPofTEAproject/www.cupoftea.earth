using DataFrames, Statistics

function qbin(x, y, z, n)
  xq = quantile(x, 0:1/n:1)
  zmed = Array{Float64}(undef, n, n) # median of z for n bins of x and y
  for i = 1:n # loop for each x between-quantile bin
    ybin = y[x .>= xq[i] .&& x .<= xq[i+1]]
    ybinq = quantile(ybin, 0:1/n:1)
    for j = 1:n # loop for each y between-quantile bin
      zmed[i,j] = median(z[x .>= xq[i] .&& x .<= xq[i+1] .&& y .>= ybinq[j] .&& y .<= ybinq[j+1]])
    end
  end
  return zmed
end

# test function
# df = DataFrame(R=1:20, T=6:25, M=11:30)
# qbin(df.T, df.M, df.R, 3)
