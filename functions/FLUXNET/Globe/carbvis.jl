using CSV, DataFrames
using WGLMakie, Colors, ColorSchemes
using FileIO, Downloads
using GeometryBasics

# Manually downloaded the image
# https://visibleearth.nasa.gov/collection/1484/blue-marble
earth_img = load("input/eo_base_2020_clean_3600x1800.png")

# Converting spherical cordinates to x, y, z

function sphere(; r = 1.0, n=32)
    theta = LinRange(0, pi, n)
    phi = LinRange(-pi, pi, 2*n)
    x = [r * cos(phi) * sin(theta) for theta in theta, phi in phi]
    y = [r * sin(phi) * sin(theta) for theta in theta, phi in phi]
    z = [r * cos(theta) for theta in theta, phi in phi]
    return (x, y, z)
end 

# Read the site data 
# Compiled from two different files: Checked on 11/02/2022
# Location file https://fluxnet.org/sites/site-list-and-pages/
# TimePeriod Available https://fluxnet.org/data/data-availability/

site_data = DataFrame(CSV.File("input/site_data.csv"))

# Function to convert lat lon to the x,y,z coordinate

function toCartesian(lon , lat ; r = 1.02, cxyz = (0,0,0))
    x = cxyz[1] + (r + 1500_000)*cosd(lat)*cosd(lon)
    y = cxyz[2] + (r + 1500_000)*cosd(lat)*sind(lon)
    z = cxyz[3] + (r + 1500_000)*sind(lat)

    return (x, y, z) ./ 1500_000

end

# cylinderMesh = Sphere(Point3f(0.0), 1.0)

lons , lats = site_data.LOCATION_LONG, site_data.LOCATION_LAT

# Magnitude of markers depedning on years available
mag =  site_data.END_YEAR - site_data.STRT_YEAR 

toPoints3D = [Point3f([toCartesian(lons[i], lats[i]; r = 0)...]) for i in 1:length(lons)]


# rectMesh = Rect3D(Vec3f(-0.5), Vec3f(2))

# set_theme!(theme_minimal())

function fluxnetglobe()

	fig =  Figure(resolution = (800,800), fontsize = 24)

	ax = LScene(fig[1,1], show_axis = false)

	surface!(ax, sphere(; r = 1.0)..., 
		color = tuple.(earth_img, 0.9),
		shading = false, 
		transparency = true         
		)

	pltobj = meshscatter!(ax, toPoints3D;
		markersize = mag/1000,
		color =mag
		)
		#colormap = to_colormap(:tab10), 
		#shading = true, 
		#ambient = Vec3f(1.0,1.0,1.0)
		#)

	Colorbar(fig[1,2], pltobj, label="Number of Years", height = Relative(1/2))
	Label(fig[1, 1, Bottom()], "Visualization by @mohitanand")
	Label(fig[1, 1, Top()], "Fluxnet data availablity : 211 sites")
	fig
	return fig
end

#zoom!(ax.scene, cameracontrols(ax.scene), 0.65)
#rotate!(ax.scene, 3.0)
    ## display(fig)
#record(fig, joinpath(@__DIR__, "cflux_white_fast_small.mp4"), framerate = 24) do io
#    for i in 3.0:0.015:9.5
#        rotate!(ax.scene, i)
#        recordframe!(io)  # record a new frame
#    end
#end
# set_theme!()


app = JSServe.App() do
    return DOM.div(
		   fluxnetglobe()
    )
end


