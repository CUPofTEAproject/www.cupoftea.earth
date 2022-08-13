using CSV, DataFrames
using WGLMakie, JSServe
using Colors, ColorSchemes
using FileIO, Downloads
using GeometryBasics




# Converting spherical cordinates to x, y, z

function sphere(; r = 1.0, n=32)
    theta = LinRange(0, pi, n)
    phi = LinRange(-pi, pi, 2*n)
    x = [r * cos(phi) * sin(theta) for theta in theta, phi in phi]
    y = [r * sin(phi) * sin(theta) for theta in theta, phi in phi]
    z = [r * cos(theta) for theta in theta, phi in phi]
    return (x, y, z)
end 




# Function to convert lat lon to the x,y,z coordinate

function toCartesian(lon , lat ; r = 1.02, cxyz = (0,0,0))
    x = cxyz[1] + (r + 1500_000)*cosd(lat)*cosd(lon)
    y = cxyz[2] + (r + 1500_000)*cosd(lat)*sind(lon)
    z = cxyz[3] + (r + 1500_000)*sind(lat)

    return (x, y, z) ./ 1500_000

end

# Read the site data 
# Compiled from two different files: Checked on 11/02/2022
# Location file https://fluxnet.org/sites/site-list-and-pages/
# TimePeriod Available https://fluxnet.org/data/data-availability/

site_data = DataFrame(CSV.File("input/site_data.csv"))

# Manually downloaded the image
# https://visibleearth.nasa.gov/collection/1484/blue-marble
earth_img = load("input/eo_base_2020_clean_3600x1800_small.png")

mag =  site_data.END_YEAR - site_data.STRT_YEAR 
lon , lat = site_data.LOCATION_LONG, site_data.LOCATION_LAT




app = App() do session::Session
  slider = JSServe.Slider(1:1:21)
  
  fig =  Figure(resolution = (1000,1000), fontsize = 24)
  ax = LScene(fig[1,1], show_axis = false)

  surface!(ax, sphere(; r = 1.0)..., 
	color = earth_img,
	shading = false, 
	transparency = false         
	)

  Label(fig[1, 1, Bottom()], "Visualization by @mohitanand")

  toPoints3D = [Point3f([toCartesian(lon[i], lat[i]; r = 0)...]) for i in eachindex(lon)];

  #s = slider.value

  #index = @lift(mag.>$s)

  #num_site = @lift((sum($index)))

  #Points3D = Observable(repeat([Point3f(NaN, NaN, NaN)], 211))
  #Points3D.val[index.val] = toPoints3D[index.val]

  #Mag = Observable(repeat([NaN], 211))
  #Mag.val[index.val] = mag[index.val]

  #dotsize = Observable(repeat([NaN], 211))
  #dotsize.val[index.val] = Mag.val[index.val]/1000

  #label_site = @lift("Fluxnet data availablity : $($num_site) sites")

  index = Observable(mag.>1)
  Points3D = Observable(repeat([Point3f(NaN, NaN, NaN)], 211))
  NaNsPoints3D = repeat([Point3f(NaN, NaN, NaN)], 211)
  Mag = Observable(repeat([NaN], 211))
  NaNsMag = repeat([NaN], 211)
  dotsize = Observable(repeat([NaN], 211))
  NaNsdotsize = repeat([NaN], 211)

  Points3D.val[index.val] = toPoints3D[index.val]
  Points3D.val[(!).(index.val)] = NaNsPoints3D[(!).(index.val)] 
  Mag.val[index.val] = mag[index.val]
  Mag.val[(!).(index.val)] = NaNsMag[(!).(index.val)]
  dotsize.val[index.val] = Mag.val[index.val]/1000
  dotsize.val[(!).(index.val)] = NaNsMag[(!).(index.val)]

  #function plt()
    pltobj = meshscatter!(ax, Points3D;
    markersize = dotsize,
    color = Mag,
    #colormap = (:linear_worb_100_25_c53_n256, 0.8), 
    shading = true, 
    ambient = Vec3f(1.0,1.0,1.0)
    )
    #return pltobj
  #end

  Colorbar(fig[1,2], limits = (0, 22), label="Number of Years", height = Relative(1/2))

  #pltobj = Observable(plt())

  on(slider) do sval
    index.val = mag.>sval
    Points3D.val[index.val] = toPoints3D[index.val]
    Points3D.val[(!).(index.val)] = NaNsPoints3D[(!).(index.val)] 
    Mag.val[index.val] = mag[index.val]
    Mag.val[(!).(index.val)] = NaNsMag[(!).(index.val)]
    dotsize.val[index.val] = Mag.val[index.val]/1000
    dotsize.val[(!).(index.val)] = NaNsMag[(!).(index.val)]

    Mag[] = Mag.val
    dotsize[] = dotsize.val
    Points3D[] = Points3D.val

    #delete!(ax, pltobj.val)
    #pltobj.val = plt()  
  end
 
  #siten = fluxglobe(slider)[2]
  sl = DOM.div("NumYear: ", slider, slider.value)	
  return JSServe.record_states(session, DOM.div(sl, fig))
end

