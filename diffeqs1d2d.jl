
using DifferentialEquations
using VoronoiFVM    
using GridVisualize
using ExtendableGrids
using Plots
using LinearAlgebra


function barenblatt_iniv(x; t = 0.01, M = 2 , dims = 1) # Method for 1D grid

    Γ = .2
    α = 1. /(M - 1.0 + 2.0/dims)
    r = abs(x)

    z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. *dims*M*t^(2. *α/dims)))^(1. /(M-1.)))
    return z
end

function barenblatt_iniv(x, y; t = 0.01, M = 2 , dims = 2) # Method for 2D grid

    Γ = .2
    α = 1. /(M - 1.0 + 2.0/dims)
    r = sqrt(x^2. + y^2.)

    z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. *dims*M*t^(2. *α/dims)))^(1. /(M-1.)))
    return z
end

function barenblatt_endv(x; t = 0.1 , M = 2 , dims = 1) # Method for 1D grid

    Γ = .2
    α = 1. /(M - 1.0 + 2.0/dims)
    r = abs(x)

    z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. *dims*M*t^(2. *α/dims)))^(1. /(M-1.)))
    return z
end

function barenblatt_endv(x, y; t = 0.1, M = 2 , dims = 2) # Method for 2D grid

    Γ = .2
    α = 1. /(M - 1.0 + 2.0/dims)
    r = sqrt(x^2. + y^2.)

    z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. *dims*M*t^(2. *α/dims)))^(1. /(M-1.)))
    return z
end

function create_grid(grid_points, dimensions)
	
    X = -1:1/grid_points:1
	
    if dimensions == 1
      grid = simplexgrid(X)
	elseif dimensions == 2
      grid = simplexgrid(X, X)
	else
		throw(ArgumentError("Only 1D and 2D are implemented"))
	end
	return grid
end

function create_system(grid; m = 2, unknown_storage = :sparse)
	
	physics = VoronoiFVM.Physics(
                                flux = function(f, u, edge)
                                          f[1] = u[1, 1]^m - u[1, 2]^m
                                	   end,

                                storage = function(f, u, node)
                                    	     f[1] = u[1]
                                          end
                                )

    system = VoronoiFVM.System(grid, physics, unknown_storage = unknown_storage)

	return system
end

function solve_system_diffeq(grid, system; t0 = 0.01, tend = 0.1)

    enable_species!(system, 1, [1])

    inival = unknowns(system)
    inival = map(barenblatt_iniv, grid)

    problem = ODEProblem(system, inival, (t0, tend))
    odesol = DifferentialEquations.solve(problem)

    solution = reshape(odesol, system)
    error = norm(solution[1, :, end] - map(barenblatt_endv, grid))

    return solution, system, error
end

function create_error_array(dim, limit, step = 10)
    error_array = []
    for i in collect(10:step:limit)
        grid = create_grid(i,dim)
        system = create_system(grid)
        _, _, error = solve_system_diffeq(grid,system)

        push!(error_array,error)
    end
    return error_array
end

#################### testing \/

""" err2d = create_error_array(2,40)     # Big boi - handle with care ! 

p1 = scatter(collect(10:10:40), err2d, title = "2D - DifferentialEquations.jl" , xlabel ="Number of gridpoints", ylabel = "Error value", legend = false) 
p1 = plot!(collect(10:10:40), err2d)
savefig(p1, "error_diffeq_2d.png") """