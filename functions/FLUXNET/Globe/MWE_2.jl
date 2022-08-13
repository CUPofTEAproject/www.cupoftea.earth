# update 3 observable, but dimension change

#GLMakie
using GLMakie 

i = Observable(Int64(round(rand().*10))) # array dimensions
x = Observable(rand(i.val).*10) # dots
y = Observable(rand(i.val).*10) # color
z = Observable(rand(i.val).*100) # markersize
xv = Observable(collect(1:1:i.val)) # x values

fig = Figure()
ax = Axis(fig[1,1])
sl = Slider(fig[2, 1], range = 1:1:20, startvalue = 1)
s = sl.value

scatter!(ax, xv, x, color = y, markersize = z)

ylims!(ax, (0,10))
xlims!(ax, (0,10))

on(s) do stuff
i.val = Int64(round(rand().*10))
xv.val = collect(1:1:i.val)
x.val = rand(i.val).*10
y.val = rand(i.val).*10
z.val = rand(i.val).*100

i[] = i.val
xv[] = xv.val
x[] = x.val
y[] = y.val
z[] = z.val
end

#WGLMakie
using WGLMakie, JSServe

app = App() do session::Session
	slider = JSServe.Slider(1:1:20)

	i = Observable(Int64(round(rand().*10))) # array dimension
	x = Observable(rand(i.val).*10) # dots
	y = Observable(rand(i.val).*10) # color
	z = Observable(rand(i.val).*100) # markersize
	xv = Observable(collect(1:1:i.val)) # x values 

	fig = Figure()
	ax = Axis(fig[1,1])
	scatter!(ax, xv, x, color = y, markersize = z)
	#scatter(xv, x, color = y, markersize = z)

	ylims!(ax, (0,10))
	xlims!(ax, (0,10))

	on(slider) do stuff
	  i.val = Int64(round(rand().*10))
	  xv.val = collect(1:1:i.val)
	  x.val = rand(i.val).*10
	  y.val = rand(i.val).*10
	  z.val = rand(i.val).*100

	  i[] = i.val
	  xv[] = xv.val
	  x[] = x.val 
	  y[] = y.val
	  z[] = z.val
	end

        sl = DOM.div("Slider: ", slider, slider.value)	
        return JSServe.record_states(session, DOM.div(sl, fig))
end
 

