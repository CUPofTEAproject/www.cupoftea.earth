@def title = "CUP of TEA"

# CUP of TEA, v0.1

~~~
<table style="width:100%">
 <tr>
    <th style="width:33%"> Open-source</th>
    <th style="width:33%"> Modular</th>
    <th style="width:33%"> Dynamic</th>
 </tr>
 <tr>
    <td><a href="https://github.com/CUPofTEAproject">Contribute!</a></td>
    <td><a href="https://github.com/CUPofTEAproject/www.cupoftea.earth/tree/master/functions">Structured in small scripts</td>
    <td>Up-to-date with databases</td>
 </tr>
</table>

<table style="width:100%">
 <tr>
    <th style="width:33%"> Cross-disciplines</th>
    <th style="width:33%"> Cross-scales</th>
    <th style="width:33%"> ModEx</th>
 </tr>
 <tr>
    <td>Ecology, models, remote sensing</td>
    <td>Microbe and stomate to the globe</td>
    <td>Measurements x modeling</td>
 </tr>
</table>
~~~

Welcome to the Community Understanding Platform of Terrestrial Exchanges with the Atmosphere (CUP of TEA). \
\
This project consists of creating online libraries of interactive figures using global databases of land properties and land-atmosphere exchanges. \
\
In-situ observations: e.g., FLUXNET, COSORE, TRY \
Satellite remote sensing: e.g., MODIS, SIF, GRACE \
Models: e.g., CMIP6 \
\
All contributions are welcome. With or without coding. Just [open an issue here] (https://github.com/CUPofTEAproject/www.cupoftea.earth/issues). \
No code contribution: e.g., interpretation of figures, general ideas \
Code contribution: e.g., tweak existing code, add a new function \
All programming languages can be used, R, Python, Julia, other. \
\
Current work in progress: sensitivity of respiration to soil temperature and moisture, using FLUXNET (ecosystem obs.), COSORE (soil obs.) and CMIP6 (soil and ecosystem modeled). Scripts will bin R (per T and SWC quantiles), normalize R and SWC (max R = 10, SWC from 0 to 100), plot, and retrieve parameter of apparent sensitivity. Then, these parameters will be compared across biomes and climate, and between data and model across scales. \
\
Another future project will look at the optimum temperature of photosynthesis, for ecosystem and leaf scale, using FLUXNET, TRY and CMIP6. \
\
There is a lot of possible inspiration in the literature. For example, [this publication of apparent sensitivity of conductance to VPD and SWC] (https://www.nature.com/articles/nclimate3114), could inspire an interactive figure library using FLUXNET, TRY, and CMIP6.\
\
Students are encouraged to contribute! Instead of doing a stand-alone study, the work shared here will be visible to the broad community, and it will continuously updated with new databases or ideas.\
\
A peer-reviewed manuscript is in progress, and will be submitted in December 2022, along with the first official release (1.0) of the CUP of TEA platform. 
