### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ ced78960-c791-11ec-161b-1f991bc68368
md"""
# The Mathematical model  - > PDE
"""

# ╔═╡ 3f0722a2-057a-4e66-8789-c8deafcaf187
md"""
# The Discretisation method
"""

# ╔═╡ f2440206-b74f-4510-b177-672f6b0a09a7
md"""
#### The finite Difference method 
"""

# ╔═╡ 7b4a58da-6e43-4fdb-8d47-7616d35ef45d
md"""
###### Approximating derivatives 
"""

# ╔═╡ 4c9349d0-3ced-487b-9029-34e87a927d22
md"""
- Forward approximation 

$$\frac{\partial u}{\partial \:x}\:\approx\:\frac{u_{i+1}\:-\:u_i}{\Delta x}$$

- back wards approximation 

$$\frac{\partial u}{\partial \:x}\:\approx\:\frac{u_i\:-\:u_{i-1}}{\Delta x}$$

- central approximation 

$$\frac{\partial u}{\partial \:x}\:\approx\:\frac{u_{i+1}\:-\:u_{i-1}}{\Delta x}$$
"""

# ╔═╡ 122ae3fe-7016-4dd0-8dd2-45f6709f49c1
md"""
##### Accuracy of these approximations 

"""

# ╔═╡ 652a5dab-aac6-449e-b67a-9cc74a05d5a7
md"""

Evaluating accuracy for, Forward approximation.

$\frac{\partial u}{\partial \:x}\:\approx \:\frac{u_{i+1}\:-\:u_i}{\Delta x}\:-\:\left\{\frac{\Delta \:x}{2}\cdot \:\frac{\partial \:^2\:u}{\partial \:\:\:x^2}\right\}^i\:\:-\:\left\{\frac{\Delta \:\:x^2}{3!}\cdot \:\:\frac{\partial \:\:^3\:u}{\partial \:\:\:\:x^3}\right\}^i\: ...$

when $\left(x_{i+1}\:-\:x_i\right)=\Delta x\:\rightarrow 0\:$ we can neglate 2nd & higer order term to obtain the forward approximation $\frac{\partial u}{\partial \:x}\:\approx\:\frac{u_{i+1}\:-\:u_i}{\Delta x}$, i.e decline in truncation errro $O(\Delta x)$

As $\Delta x\rightarrow 0\:\propto \:Error\:\rightarrow 0.$ 
Hence the convergence of Forward difference

-----------------------------

These steps can be repeated to show the same for backward aprroximation.

-----------------------------

Central approximation is essentially the addition of forward & backward approximation

For central difference approximation (Truncaion) $Error\:\approx O\left(\Delta x^2\right)$

"""

# ╔═╡ 3f151f74-ef4e-4e73-90af-9092fb1db61b
md"""
-----------------------------
Order of Accuracy:

[def. The power of $\Delta x$ with which the truncation error tends to 0]

Forward & Backward approximation are $O(\Delta x)$, 1st order accurate. 



"""

# ╔═╡ 58caa6ec-067c-4067-ac78-b8fc0c43cd7f
md"""
#### 1D - Porus medium Equation

Implicit Euler time step - for stability reasons

$$\frac{\partial \:u}{\partial \:t}\:=\:\frac{\partial ^2\:u^m}{\partial \:x^2}\:\:$$



"""

# ╔═╡ 2f86725e-174e-415f-a14a-acdc751fd5ee
md"""

Implicit Euler time step

[Def. A formulation inclusing more than 1 unknown in a Finite difference eq.]

Using the 'Backward difference' for time steps to rvaluate the equation.

$$\frac{\:u_x^{t+1}-u^t_x}{\Delta t\:}\:=\frac{\left(u^m\right)_{x+1}^{t+1}\:-2\cdot \left(u^m\right)_x^{t+1}+\left(u^m\right)_{x-1}^{t+1}\:\:}{\Delta x^2}$$

Super-scripts represent time steps and sub-script represent spacial steps

### Add 1D-stencil here



Since this equation at one step calculation needs, 2 unknowns from current time step and 1 unknows from previous time step. Hence we couple these unknows with other equations in the grid by writing the formula for all the grid points. Eventually this gives us a tridiagonal coeeficient matrix, with 3 coefficients rows.

$$\begin{pmatrix}\frac{-1}{\Delta \:x^2}&\frac{1}{\Delta \:x^2}&0&0&.&.&\\ \frac{1}{\Delta x^2}&\frac{-2}{\Delta \:x^2}&\frac{1}{\Delta \:x^2}&0&.&&\\ 0&.&\frac{-2}{\Delta \:\:x^2}&.&.&&\\ .&.&.&.&.&&\\ .&.&.&.&.&&\\ &&&&&&\\ &&&&&&\end{pmatrix}$$

Since we are using the implicit time steps, each time step can then be solved lineraly

"""

# ╔═╡ 3f8b0d2a-8385-4346-bb63-ef43aa518e8a
md"""
###### Crank - Nicholson method

Essentially the average of - explicit and implicit methods - useful in Heat eq.s etc.

since we dont need this - fuck this shit
"""

# ╔═╡ 8d6a8d1c-b8b6-439b-8e8a-a40d07f6be7b
md"""
#### Stability 

$O(x)"$ Truncation errro 
$A$ is the coefficient matrix shown above

$$O\left(x\right)=\:A\cdot u\:-\frac{\partial u}{\partial t}$$

$e\::\:sol.\:error\:=Exact\:sol.\:-\:Numerical\:sol.$

$A\cdot e\:=\:O\left(x\right)$

$\left|e\right|\le \:\left|A^{-1}\right|\cdot \:\left|O\left(x\right)\right|$

Hence the stability condition here is if Norm of Matrix 'A' is indpendent or decreses with $\Delta x$ error should dicrease with increasing grid resolution.

"""

# ╔═╡ 7ac1c018-6554-42be-b0bb-8bd733c0f149
md"""
### Everything below is useless
"""

# ╔═╡ 7faff9e6-e2c9-46bc-a619-d24562a77f6c
md"""
---------------------------


Numerical discritization should be adequate for the physical process.


###### 1D Linear convection
$\frac{\partial u}{\partial \:t}+c\cdot \frac{\partial \:u}{\partial \:\:x}\:=0\:$

Wave propogation solution 

$$u_0\left(x-c\cdot t\right)$$

Space-time discritization 

i - index in grid space x

n - index in grid time t

###### Numerical Scheme
Discritizing the equation , with forward differencein time and Backward difference in space

Discrete equation 

$$\frac{u^{n+1}_i-u^n_i}{\Delta t}\:+\:c\cdot \:\frac{\:u^n_i-u^n_{i-1}}{\Delta \:x}\:=0$$

Time marching sol. of $'u'$ at (t+1) from current time and part spacial values.

$$u^{n+1}_i=u_i^n\:-\:c\cdot \frac{\Delta t}{\Delta x}\cdot \left(u^n_i-u_{i-1}^n\right)$$

If we give this equation and initial conditon at $u(x_0 , t_0)$ we can obesrve a 1D diffusion.
"""

# ╔═╡ 53c875da-2213-4352-aecd-33885215e34f
md"""
###### 1D Linear nonlinear convection
$$\frac{\partial \:u}{\partial \:\:t}+u\cdot \:\frac{\partial \:\:u}{\partial \:\:\:x}\:=0\:$$
###### Numerical Scheme
Discritizing the equation 

Space - BD
time  - FD

(forward difference method = forward euler method)

$$\frac{u^{n+1}_i-u^n_i}{\Delta \:t}\:+\:u_i^n\cdot \:\:\frac{\:u^n_i-u^n_{i-1}}{\Delta \:\:x}\:=0$$

$$u^{n+1}_i=u_i^n\:-\:u^n_i\cdot \frac{\Delta t}{\Delta x}\cdot \left(u^n_i-u_{i-1}^n\right)$$



"""

# ╔═╡ 303d54da-39ab-43a9-a6ca-1bb516f6c20d
md"""
###### 2nd order derivatives

Central difference - 2nd order

$$u_{i+1}=u_i\:+\:\left\{\Delta \:x\cdot \:\frac{\partial \:u}{\partial \:x}\right\}^i+\left\{\frac{\Delta \:\:x^2}{2}\cdot \:\frac{\partial ^2\:u}{\partial \:x^2}\right\}^i+\left\{\frac{\Delta \:\:\:x^3}{3!}\cdot \:\:\frac{\partial \:^3\:u}{\partial \:\:x^3}\right\}^i+...$$

$$u_{i-1}=u_i\:-\:\left\{\Delta \:x\cdot \:\frac{\partial \:u}{\partial \:x}\right\}^i-\left\{\frac{\Delta \:\:x^2}{2}\cdot \:\frac{\partial ^2\:u}{\partial \:x^2}\right\}^i-\left\{\frac{\Delta \:\:\:x^3}{3!}\cdot \:\:\frac{\partial \:^3\:u}{\partial \:\:x^3}\right\}^i+...$$

adding both from above

$$\left\{\frac{\partial ^2u}{\partial \:x^2}\right\}^i=\frac{u_{i+1}\:-2\cdot \:u_i+u_{i-1}}{\:\Delta x^2}\:-\:O\left(\Delta x^2\right)$$


1-D Diffusion 
Heat Equation if u=Temprature 

$$\frac{\partial \:u}{\partial \:\:t}=v\cdot \frac{\partial ^2u}{\partial \:x^2}$$

Physics of difffusion is Isotropic.
This is Phenomina that is Isotropic in Time and hence usage central difference is the most aprpriate. Since Central difference itself isotropic, does not differentiate between upstream and downstream.  


###### Numerical Scheme

FD in Time 

CD in space - (instead of BD like the last few times)

Discretize

$$\frac{u^{n+1}_i-u^n_i}{\Delta \:\:t}\:=v\cdot \frac{\:u^n_{i+1}-2\cdot u_i^n+u^n_{i-1}}{\Delta \:\:\:x^2}\:$$

Ultimatley the Finite difference scheme for this equation is 

$$u^{n+1}_i=u_i^n\:+\:v\cdot \:\frac{\Delta \:t}{\Delta \:x^2}\cdot \:\left(u_{i+1}^n-2\cdot u^n_i+u_{i-1}^n\right)$$

--------------------

1D Burgers Equation 

$$\frac{\partial \:\:u}{\partial \:\:\:t}+u\cdot \frac{\partial \:u}{\partial \:x}=v\cdot \:\frac{\partial \:^2u}{\partial \:\:x^2}$$


$$\frac{u^{n+1}_i-u^n_i}{\Delta \:\:\:t}\:+u^n_i\cdot \frac{u^n_i-u^n_{i-1}}{\Delta \:\:\:\:x}\:=v\cdot \:\frac{\:u^n_{i+1}-2\cdot \:u_i^n+u^n_{i-1}}{\Delta \:\:\:\:x^2}\:$$

$$u^{n+1}_i=u_i^n\:-u_i^n\cdot \frac{\Delta \:\:\:t}{\Delta \:\:\:x}\cdot \left(u_i^n-u_{i-1}^n\right)+\:v\cdot \:\:\frac{\Delta \:\:t}{\Delta \:\:x^2}\cdot \:\:\left(u_{i+1}^n-2\cdot \:u^n_i+u_{i-1}^n\right)$$


"""

# ╔═╡ 6e8dd660-5b0e-4562-9b9a-1389dea81e41
md"""
-------------------------

Will write the 2D stuff 

"""

# ╔═╡ b28d9277-1adf-4186-ad2c-8bf8c9319369
md"""
#### Explicit/Implicit Euler

Explicit. 

[def. A formulation of a continum eq. into a FD eq. that expresses one unknown in terms of the already known values ]

Stencil for 1-D Explicit 

Need draw the stuff here

also draw 2D Explicit stencil 

-------------------------

Implicit 


Ditto for implicit

"""

# ╔═╡ a1e6984d-97f5-4214-b152-688aaacbbc72


# ╔═╡ d72ad90d-c0f6-41f9-ba5a-f3c93ddaa17e
md"""
### Grid & Stencil Diagrams 
"""

# ╔═╡ 781b160b-74c0-4655-9403-9cf0a03074cf


# ╔═╡ 9d0f79b7-683a-4434-bb64-d41c0fc798b0
md"""
### PDE to > algebra converstion
"""

# ╔═╡ 18f5eb29-f1f5-43cc-88e7-8061428ae1bb
md"""
# 3. Analysing the Numerical scheme
"""

# ╔═╡ eb5f23e2-9579-4b17-aaba-75af37054102
md"""
### Consistency, Statbility , Convergence 
"""

# ╔═╡ 792981cf-c29e-4ded-8ef3-0f90067a5f00
md"""
### Acuracy analysis 
"""

# ╔═╡ efdc4683-8592-453f-8a2d-a13916555686
md"""
# Solution & Visualization
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╟─ced78960-c791-11ec-161b-1f991bc68368
# ╟─3f0722a2-057a-4e66-8789-c8deafcaf187
# ╟─f2440206-b74f-4510-b177-672f6b0a09a7
# ╟─7b4a58da-6e43-4fdb-8d47-7616d35ef45d
# ╟─4c9349d0-3ced-487b-9029-34e87a927d22
# ╟─122ae3fe-7016-4dd0-8dd2-45f6709f49c1
# ╟─652a5dab-aac6-449e-b67a-9cc74a05d5a7
# ╟─3f151f74-ef4e-4e73-90af-9092fb1db61b
# ╠═58caa6ec-067c-4067-ac78-b8fc0c43cd7f
# ╠═2f86725e-174e-415f-a14a-acdc751fd5ee
# ╟─3f8b0d2a-8385-4346-bb63-ef43aa518e8a
# ╠═8d6a8d1c-b8b6-439b-8e8a-a40d07f6be7b
# ╠═7ac1c018-6554-42be-b0bb-8bd733c0f149
# ╟─7faff9e6-e2c9-46bc-a619-d24562a77f6c
# ╟─53c875da-2213-4352-aecd-33885215e34f
# ╟─303d54da-39ab-43a9-a6ca-1bb516f6c20d
# ╟─6e8dd660-5b0e-4562-9b9a-1389dea81e41
# ╠═b28d9277-1adf-4186-ad2c-8bf8c9319369
# ╠═a1e6984d-97f5-4214-b152-688aaacbbc72
# ╟─d72ad90d-c0f6-41f9-ba5a-f3c93ddaa17e
# ╠═781b160b-74c0-4655-9403-9cf0a03074cf
# ╟─9d0f79b7-683a-4434-bb64-d41c0fc798b0
# ╠═18f5eb29-f1f5-43cc-88e7-8061428ae1bb
# ╠═eb5f23e2-9579-4b17-aaba-75af37054102
# ╠═792981cf-c29e-4ded-8ef3-0f90067a5f00
# ╟─efdc4683-8592-453f-8a2d-a13916555686
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
