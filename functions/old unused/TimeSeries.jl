using GLMakie, UnicodeFun, Dates
using PlotUtils: optimize_ticks

# test
#timesteps = collect(DateTime(2020, 1, 1, 00, 00, 00):Hour(1):DateTime(2020, 1, 1, 04, 00, 00))
#Rsoil = [2, 3, 4, 2, 1]
#Tsoil = [12, 13, 15, 12, 10]
#Msoil = [0.1, 0.11, 0.11, 0.12, 0.1]

function timeserie(timesteps, Rsoil, Tsoil, Msoil)
	fig = Figure()
	
	Xticks = (datetime2unix.(optimize_ticks(timesteps[1], timesteps[end])[1]),
		  Dates.format.(optimize_ticks(timesteps[1], timesteps[end])[1], "mm/dd/yyyy"))

	ax1 = Axis(fig[1,1], ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"), xticks = Xticks)
	ax2 = Axis(fig[2,1], ylabel = to_latex("T_{soil} (°C)"), xticks = Xticks)
	ax3 = Axis(fig[3,1], ylabel = to_latex("\\theta (m^3 m^{-3})"), xticks = Xticks)
	
	xyRsoil = @. Point2f0(datetime2unix(timesteps), Rsoil)
	xyTsoil = @. Point2f0(datetime2unix(timesteps), Tsoil)
	xyMsoil = @. Point2f0(datetime2unix(timesteps), Msoil)

	p1 = scatter!(ax1, xyRsoil, markersize = 3, color = :black)
	p2 = scatter!(ax2, xyTsoil, markersize = 3, color = :red)
	p3 = scatter!(ax3, xyMsoil, markersize = 3, color = :blue)
	fig
end

