# Gas-Transport-in-Porous-Medium-PDE-with-VoronoiFVM

Main file : Report.jl \
For a quick look : Report.html   <-- Limited to graphs at timestep = t0

<h1> <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
  <msub>
    <mi>u</mi>
    <mi>t</mi>
  </msub>
  <mo>=</mo>
  <mi mathvariant="normal">&#x394;</mi>
  <mo stretchy="false">(</mo>
  <msup>
    <mi>u</mi>
    <mi>m</mi>
  </msup>
  <mo stretchy="false">)</mo>
  <mo>,</mo>
  <mtext>&#xA0;</mtext>
  <mi>u</mi>
  <mo>=</mo>
  <mi>u</mi>
  <mo stretchy="false">(</mo>
  <mi>x</mi>
  <mo>,</mo>
  <mi>t</mi>
  <mo stretchy="false">)</mo>
</math>
</h1>

\begin{displaymath}
r = \frac{\sum_{i=1}^{n}(x_i - \bar{x})(y_i - \bar{y})}{\sqrt[]{\sum_{i=1}^{n}(x_i - \bar{x})^2 \sum_{i=1}^{n}(y_i - \bar{y})^2}}
\end{displaymath}


Simulation results for 1 and 2 dimensions, based on the Barenblatt solution's initial condition.
Comparison with DifferentialEquations.jl solver yealding a marginally better result.
Successful error convergence in both cases - using Implicit & Explicit Euler method.

```math
SE = \frac{\sigma}{\sqrt{n}}
```

1D space-time solution             |  2D space solution at t = t0 |  2D space-time solution 
:-------------------------:|:-------------------------:|:-------------------------:
 <img width="300" alt="Screenshot 2022-05-04 at 16 55 08" src="https://user-images.githubusercontent.com/74839077/166708807-ad06b6a7-2962-40ef-b996-4fdeb917b91c.png"> |   <img width="300" alt="Screenshot 2022-05-04 at 16 54 52" src="https://user-images.githubusercontent.com/74839077/166708854-9a567253-0401-4e6f-b83f-6e33eda14cad.png"> |  <img width="300" alt="Screenshot 2022-05-04 at 16 46 01" src="https://user-images.githubusercontent.com/74839077/166707343-845ef4b2-99cd-4724-8b93-b2be13c3c220.png">



