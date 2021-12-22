+++
title = "DAMM Fluxnet"
+++

# DAMM model fitted to FLUXNET sites

```julia:ex
#hideall
using WGLMakie, JSServe, UnicodeFun, SparseArrays, LsqFit, DAMMmodel, DataFrames, CSV, Dates, Statistics
# could add a line to copy the .html in /__site/FNDAMM to /menu2/, which I do manually atm
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

include("FNDAMM.jl")
# d
show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))
```
\textoutput{ex}

v0.1.3

The figure shows all FLUXNET2015 observations (nighttime NEE, $u_{*}$ filtered, qc = 0) fitted to the [DAMM model] (https://github.com/CUPofTEAproject/DAMMmodel.jl/blob/master/src/DAMM.jl), for each dataset/site.

The following FLUXNET columns are used: TS\_F\_MDS\_1, SWC\_F\_MDS\_1, and NEE\_CUT\_USTAR50, with the following filter: NIGHT = 0 and NEE\_CUT\_USTAR50\_QC = 0. Raw, half-hourly data, are first binned into 5 quantiles of soil temperature, and then into 5 quantiles of soil moisture for each soil temperature quantile. The median of NEE is then calculated, giving the dots shown in the figure.

Four of the DAMM parameters are fitted to these binned data: $\alpha_{sx}$, $Ea_{sx}$, $KM_{sx}$ and $KM_{o2}$. Porosity is set to the maximum soil moisture measured at a given site. $sx_{tot}$ is set to 0.02 $gC$ $cm^{-3}$.

Values of fitted parameters are shown, and a .csv file containing the parameters for all FLUXNET2015 sites can be downloaded (soon).

The figure will be updated each time a new version of FLUXNET2015 becomes available.
[Suggestions] (https://github.com/CUPofTEAproject/www.cupoftea.earth/issues) to improve the figure or data are welcome.

The same analysis and figures will be created with the COSORE database and CMIP6 outputs (soon). You can always [suggest other database] (https://github.com/CUPofTEAproject/www.cupoftea.earth/issues).

If you think of a more efficient or clearer way to write the analysis and visualisation code, [your help is welcome] (https://github.com/CUPofTEAproject/www.cupoftea.earth/tree/master/functions). The goal is to continuously improve as a community effort.

A boxplot figure will show the distribution of the parameter values per biome, at ecosystem and soil scale, for measurements and models (soon).

This analysis allows to compare the apparent response of respiration to temperature and moisture at different scales, and between measurements and models. It allows to better understand emergent properties, and identify where and when measurements are needed, or models needs improvement. It also allows to tracks the progress being made as measurements and models evolve.

This effort attempt to continuously reconcile disciplines and scales as a community effort.  
