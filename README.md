# Gas-Transport-in-Porous-Medium-PDE-with-VoronoiFVM

Main file : Report.jl \
For a quick look : Report.html   <-- Limited to graphs at timestep = t0

Solving the Gas Transport in Porous Medium PDE 🧽 - using the Voronoi Finite Volume Method (VoronoiFVM.jl package)

Simulation results for 1 and 2 dimensions, based on the Barenblatt solution's initial condition.
Comparison with DifferentialEquations.jl solver yealding a marginally better result.
Successful error convergence in both cases - using Implicit & Explicit Euler method.


<img width="300" alt="Screenshot 2022-05-04 at 16 46 24" src="https://user-images.githubusercontent.com/74839077/166707294-d01b3971-54a8-4acc-bd83-33b7d82024ee.png">
<img width="300" alt="Screenshot 2022-05-04 at 16 46 01" src="https://user-images.githubusercontent.com/74839077/166707343-845ef4b2-99cd-4724-8b93-b2be13c3c220.png">

1D space-time solution             |  2D space solution at t = t0
:-------------------------:|:-------------------------:
<img width="300" alt="Screenshot 2022-05-04 at 16 47 40" src="https://user-images.githubusercontent.com/74839077/166707391-9ef392dd-7e60-482c-8abb-e9a1f58ee773.png">  |  <img width="300" alt="Screenshot 2022-05-04 at 16 48 10" src="https://user-images.githubusercontent.com/74839077/166707422-09870eab-b1a9-42da-98c7-53e52e859b50.png">



