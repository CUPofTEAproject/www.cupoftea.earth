# update 3 observable, but dimension change

#GLMakie
using GLMakie 

i = Observable(Int64(round(rand()*100+1))) # array dimensions
x = Observable(rand(i.val).*10) # x values
y = Observable(rand(i.val).*10) # y values
c = Observable(rand(i.val).*10) # color
z = Observable(rand(i.val).*100) # markersize

fig = Figure()
ax = Axis(fig[1,1])

sl = Slider(fig[2, 1], range = 1:1:20, startvalue = 1)
slider = sl.value

scatter!(ax, x, y, color = c, markersize = z)

ylims!(ax, (0,10))
xlims!(ax, (0,10))

on(slider) do stuff
  i.val = Int64(round(rand()*100+1))
  x.val = rand(i.val).*10
  y.val = rand(i.val).*10
  c.val = rand(i.val).*10
  z.val = rand(i.val).*100

  i[] = i.val
  x[] = x.val
  y[] = y.val
  c[] = c.val
  z[] = z.val
end
    
#WGLMakie
using WGLMakie, JSServe

app = App() do session::Session    
	slider = JSServe.Slider(1:20)

	i = Observable(Int64(round(rand()*100+1))) # array dimensions
	x = Observable(rand(i.val).*10) # x values
	y = Observable(rand(i.val).*10) # y values
	c = Observable(rand(i.val).*10) # color
	z = Observable(rand(i.val).*100) # markersize

	fig = Figure()
	ax = Axis(fig[1,1])

	scatter!(ax, x, y, color = c, markersize = z)

	ylims!(ax, (0,10))
	xlims!(ax, (0,10))

	on(slider) do stuff
	  i.val = Int64(round(rand()*100+1))
	  x.val = rand(i.val).*10
	  y.val = rand(i.val).*10
	  c.val = rand(i.val).*10
	  z.val = rand(i.val).*100

	  i[] = i.val
	  x[] = x.val
	  y[] = y.val
	  c[] = c.val
	  z[] = z.val
	end 

	sl = DOM.div("data: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, fig))
end


