using WGLMakie, JSServe

function scatter3D(slider)
  v = [[1,2,3], [1,4,6], [0,5,10]]
  fig = Figure()
  ax3D = Axis3(fig[1, 1])
  s = slider.value
  data = @lift(Vec3f0.(v[$s], v[$s], v[$s]))
  p3D = scatter!(ax3D, data, markersize = 2500)
  #autolimits!(ax3D)
  xlims!(ax3D, 0, 10)
  fig
  return fig
end

app = App() do session::Session    
	slider = JSServe.Slider(1:3)
	fig = scatter3D(slider)
	sl = DOM.div("data: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, fig))
end

