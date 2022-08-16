using GLMakie
args = (rand(3), rand(3)) # Tuple containing all plotting args 
fig = Figure()
ax = Axis(fig[1,1])
plt = scatter!(args...)

# All args in 1 Observable
args = Observable((rand(3), rand(3)));
fig = Figure()
ax = Axis(fig[1,1])
plt = scatter!(args...)

args[] = (rand(3), rand(3))



f(a,b) = a+b
ab = (2, 3)
f(ab...)

