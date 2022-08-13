# update 3 observable

#GLMakie
using GLMakie 

x = Observable(rand(3).*10) # dots
y = Observable(rand(3).*10) # color
z = Observable(rand(3).*100) # markersize

fig = Figure()

ax = Axis(fig[1,1])

sl = Slider(fig[2, 1], range = 1:1:20, startvalue = 1)
s = sl.value

scatter!(ax, [1,2,3], x, color = y, markersize = z)

ylims!(ax, (0,10))

on(s) do stuff
x.val = rand(3).*10
y.val = rand(3).*10
z.val = rand(3).*100

x[] = x.val
y[] = y.val
z[] = z.val
end

#WGLMakie
using WGLMakie, JSServe

app = App() do session::Session
	slider = JSServe.Slider(1:1:20)

	x = Observable(rand(3).*10) # dots
	y = Observable(rand(3).*10) # color
	z = Observable(rand(3).*100) # markersize

	fig = Figure()
	ax = Axis(fig[1,1])
	scatter!(ax, [1,2,3], x, color = y, markersize = z)
	ylims!(ax, (0,10))

	on(slider) do stuff
		x.val = rand(3).*10
		y.val = rand(3).*10
		z.val = rand(3).*100

		x[] = x.val
		y[] = y.val
		z[] = z.val
	end

        sl = DOM.div("Slider: ", slider, slider.value)	
        return JSServe.record_states(session, DOM.div(sl, fig))
end
