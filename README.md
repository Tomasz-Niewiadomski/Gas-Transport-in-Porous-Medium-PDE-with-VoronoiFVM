# Gas-Transport-in-Porous-Medium-PDE-with-VoronoiFVM

Main file : Report.jl \
For a quick look : Report.html   <-- Limited to graphs at timestep = t0

<h1> $'\frac{\partial u(x,t)}{\partial t} = \Delta u(x,t)^m'$ </h1>

Solving the Gas Transport in Porous Medium PDE 🧽 - using the Voronoi Finite Volume Method (VoronoiFVM.jl package)

Simulation results for 1 and 2 dimensions, based on the Barenblatt solution's initial condition.
Comparison with DifferentialEquations.jl solver yealding a marginally better result.
Successful error convergence in both cases - using Implicit & Explicit Euler method.

<p align="center">
<img align="center" alt="Screenshot 2022-05-04 at 16 46 24" src="https://user-images.githubusercontent.com/74839077/166707294-d01b3971-54a8-4acc-bd83-33b7d82024ee.png">
</p>

1D space-time solution             |  2D space solution at t = t0 |  2D space-time solution 
:-------------------------:|:-------------------------:|:-------------------------:
 <img width="300" alt="Screenshot 2022-05-04 at 16 55 08" src="https://user-images.githubusercontent.com/74839077/166708807-ad06b6a7-2962-40ef-b996-4fdeb917b91c.png"> |   <img width="300" alt="Screenshot 2022-05-04 at 16 54 52" src="https://user-images.githubusercontent.com/74839077/166708854-9a567253-0401-4e6f-b83f-6e33eda14cad.png"> |  <img width="300" alt="Screenshot 2022-05-04 at 16 46 01" src="https://user-images.githubusercontent.com/74839077/166707343-845ef4b2-99cd-4724-8b93-b2be13c3c220.png">



