using VoronoiFVM    
using GridVisualize
using ExtendableGrids
using LinearAlgebra
using Plots


function create_grid(nx,dim)
	X=collect(-1:1.0/nx:1)
	if dim==1
      grid=simplexgrid(X)
	else
      grid=simplexgrid(X,X)
	end
end

### 2 methods for the barenblatt function :

function barenblatt(x) # Implementing time into the barenblatt function will be problematic (don't care for now)
    t = 0.01
    m = 2
    d = 1
    Γ = 1
	α = 1/(m - 1.0 + 2.0/d)
	r = abs(x)

    z = max(0.,t^(-α)*(Γ - (α * (m - 1.)*r^2.)/(2. *d*m*t^(2. *α/d)))^(1. /(m-1.)))
	
    return z
end

function barenblatt(x,y)
	
    t = 0.01
    m = 2
    d = 1
    Γ = 1
	α = 1/(m - 1.0 + 2.0/d)
	r = sqrt(x^2+y^2)

    z = max(0.,t^(-α)*(Γ - (α * (m - 1.)*r^2.)/(2. *d*m*t^(2. *α/d)))^(1. /(m-1.)))
	
    return z
end

function solve_system(grid, m; t0 = 0.01, tstep = 0.0001, tend = 0.1, unknown_storage = :sparse)

    physics = VoronoiFVM.Physics(
        
                                flux = function(f, u, edge)
                                    f[1] = u[1, 1]^m - u[1, 2]^m
                                end,

                                storage = function(f, u, node)
                                    f[1] = u[1]
                                 end

                                )

    system = VoronoiFVM.System(grid, physics, unknown_storage = unknown_storage)



    enable_species!(system, 1, [1])

    inival = unknowns(system)
    inival[1, :] .= map(barenblatt, grid)       # Elephant in the room - depending on the grid, barenblatt takes 1d or 2d method

    control = VoronoiFVM.SolverControl()
	control.Δt_min = 0.01*tstep
	control.Δt = tstep
	control.Δt_max = 0.1*tend
	control.Δu_opt = 0.05

    tsol = solve(system, inival = inival, times = [t0, tend]; control=control)
end


grid1d = create_grid(40,1)
grid2d = create_grid(40,2)



tsol1d = solve_system(grid1d,2)
tsol2d = solve_system(grid2d,2)     # WORKS!!!!!!!