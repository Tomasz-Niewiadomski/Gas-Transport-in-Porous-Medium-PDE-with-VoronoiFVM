# Gas-Transport-in-Porous-Medium-PDE-with-VoronoiFVM

Main file : Report.jl \
For a quick look : Report.html   <-- Limited to graphs at timestep = t0

Solving the Gas Transport in Porous Medium PDE 🧽 - using the Voronoi Finite Volume Method (VoronoiFVM.jl package)

Simulation results for 1 and 2 dimensions, based on the Barenblatt solution's initial condition.
Comparison with DifferentialEquations.jl solver yealding a marginally better result.
Successful error convergence in both cases - using Implicit & Explicit Euler method.


<img width="300" alt="Screenshot 2022-05-04 at 16 46 24" src="https://user-images.githubusercontent.com/74839077/166707294-d01b3971-54a8-4acc-bd83-33b7d82024ee.png">

1D space-time solution             |  2D space solution at t = t0 |  2D space-time solution 
:-------------------------:|:-------------------------:|:-------------------------:
 <img width="300" alt="Screenshot 2022-05-04 at 16 52 41" src="https://user-images.githubusercontent.com/74839077/166708360-7cd69d41-e2ba-40fa-b29a-b301ce5d8af8.png">
 |   <img width="300" alt="Screenshot 2022-05-04 at 16 53 06" src="https://user-images.githubusercontent.com/74839077/166708386-864aaa53-4489-4d34-8cfe-eb4109fb7f7e.png">
 |  <img width="300" alt="Screenshot 2022-05-04 at 16 46 01" src="https://user-images.githubusercontent.com/74839077/166707343-845ef4b2-99cd-4724-8b93-b2be13c3c220.png">



