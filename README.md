# Gas-Transport-in-Porous-Medium-PDE-with-VoronoiFVM

Main file : Report.jl \
For a quick look : Report.html   <-- Limited to graphs at timestep = t0

Solving the Gas Transport in Porous Medium PDE 🧽 - using the Voronoi Finite Volume Method (VoronoiFVM.jl package)

Simulation results for 1 and 2 dimensions, based on the Barenblatt solution's initial condition.
Comparison with DifferentialEquations.jl solver yealding a marginally better result.
Successful error convergence in both cases - using Implicit & Explicit Euler method.


<img width="716" alt="Screenshot 2022-05-04 at 16 46 24" src="https://user-images.githubusercontent.com/74839077/166706913-1d835c46-f03f-4066-8f8d-12d7feb512f4.png">

<img width="563" alt="Screenshot 2022-05-04 at 16 46 13" src="https://user-images.githubusercontent.com/74839077/166706938-0f2bb087-c6e5-4c5b-94b1-dd65c581d357.png">

<img width="561" alt="Screenshot 2022-05-04 at 16 46 01" src="https://user-images.githubusercontent.com/74839077/166706948-a341777d-a04c-438f-a89d-c2bab23ad903.png">
