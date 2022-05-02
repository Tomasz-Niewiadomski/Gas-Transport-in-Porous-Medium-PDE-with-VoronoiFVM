### A Pluto.jl notebook ###
# v0.19.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ bb2682c2-4f42-442d-9c5d-cddda357fbd9
begin
	using Markdown
	using InteractiveUtils
	using HypertextLiteral
	using PlutoUI
	using Plots
end

# ╔═╡ dc011686-f8e1-48ee-8f44-53d1e92cb7a0
begin
	using VoronoiFVM    
	using GridVisualize
	using ExtendableGrids
	using LinearAlgebra
	using DifferentialEquations
end

# ╔═╡ e1d686e2-c60b-11ec-20d1-8f9ce5c08b8e
begin
     
    highlight(mdstring,color)= htl"""<blockquote style="padding: 10px; background-color: $(color);">$(mdstring)</blockquote>"""
	
	macro important_str(s)	:(highlight(Markdown.parse($s),"#ffcccc")) end
	macro proposition_str(s)	:(highlight(Markdown.parse($s),"#ccccff")) end
	macro definition_str(s)	:(highlight(Markdown.parse($s),"#ccffcc")) end
	macro remark_str(s)	:(highlight(Markdown.parse($s),"#fcedd2")) end
	macro example_str(s)	:(highlight(Markdown.parse($s),"#e0fffb")) end
	
		
		
    html"""
    <style>
     h1{background-color:#dddddd;  padding: 10px;}
     h2{background-color:#e7e7e7;  padding: 10px;}
     h3{background-color:#eeeeee;  padding: 10px;}
     h4{background-color:#f7f7f7;  padding: 10px;}
    </style>
"""

	TableOfContents(title="Table of Contents", depth=4)
end

# ╔═╡ 72cc14a8-6f79-4b6d-b7a0-c5e76a6bd711
md"# Report for Scientific Computing
Winter Semester 2021/2022

Group number: 13

Group members:
- Shashank Shetty Kalavara
- Thomas de Paula Barbosa
- Tomasz Niewiadomski
"

# ╔═╡ 87a34f4e-c396-482f-a310-0076d550e840
md"# Porous medium equation
The porous medium equation is the simplest model of a nonlinear diffusion equation. It was initially derived by people interested in describing the oil extraction process in the petroleum industry, and the PDE is used to describe the flow of an ideal gas in a homogeneous porous medium.

----
"

# ╔═╡ 047d17a3-134b-4cdd-b6b1-65c2b43df0fe
md"$\large u_t = \Delta (u^m)$  
---
"

# ╔═╡ 7d61bfcd-cb35-4bac-9bf9-99a66b61809f
md"""
The unknown $u(x,t)$ can be understood as the _density_ of a gas at a point $x$ in time $t$. \


The exponent $m \in \mathbb{R}_{+}$



- If $m>1$ it degenerates at $u=0$, creates free boundaries, and is called a _Slow Diffusion_
- If $m=1$ one obtains the _classical Heat Equation_.
- If $m<1$, the equation experiences singularity at $u=0$ and is called a _Fast Diffusion_

This report focuses on the case where $m>1$.

__Nonlinearity__ of the Porous medium equation is evident after the decomposition into $\frac{\partial u}{\partial t}= \frac{\partial}{\partial x}(mu^{m-1}\frac{\partial u}{\partial x})$, and writing it in the form $\frac{\partial u}{\partial t}= \frac{\partial}{\partial x}(D\frac{\partial u}{\partial x})$. \
From that, one obtains the _diffusion coefficient_ $D=D(u)=mu^{m-1}$, which is **not** a constant.

Taking $m=2$ and looking at region $u=0$ , one obtains 

 $u_t = 2u\Delta u+2|\nabla u|^2 \bigg|_{u=0} \Rightarrow u_t \sim 2|\nabla u|^2$ 

which is not parabolic and admits propagation fronts which means _Free Boundaries_ appear

The fact that the porous medium equation's solution shows degeneracy signifies that the speed of propagation in a vacuum (a space with zero density) is _finite_. This is in contrast to the solution in the classical Heat Equation, which spreads out at an _infinite speed_.
"""

# ╔═╡ e74c7bc4-46c6-4192-a80b-b895344e00fb
md"## Attempt at a Solution
$u_t = \Delta (u^m), \space u = u(x,t)$ 

1) Seperation of variables : $u(x,t) = v(t)\cdot w(x)$

$[v(t)w(x)]_t = \Delta[v^m (t) w^m (x)]$

$v'(t)w(x) = v^m(t) \Delta[w^m (x)]$

$\frac{v'(t)}{v^m(t)}=\frac{\Delta [w^m(x)]}{w(x)} =  \lambda$

2) Compute : $v(t)$

$\frac{v'(t)}{v^m(t)}=\lambda \Rightarrow \bigg(\frac{-\frac{1}{m-1}}{v^{m-1}}\bigg)'=\lambda$

$\bigg(\frac{1}{(1-m)v^{m-1}(t)}\bigg)' = -\lambda \Rightarrow \frac{1}{(1-m)v^{m-1}(t)} = \lambda t + c$

$v(t) = \frac{1}{((1-m)\lambda t + c)^{\frac{1}{m-1}}}$

3) Compute : $w(x)$

$\frac{\Delta[w^m(x)]}{w(x)}=\lambda \Rightarrow \Delta[w^m(x)] = \lambda w(x)$

_Ansatz_ : $w(x) = |x|^\alpha$ for some $\alpha$

$0 = \lambda w(x) - \Delta(w^m(x)) = \lambda |x|^\alpha - \Delta(|x|^{m \alpha})$

$(\dots) = 0 = \lambda |x|^\alpha - m\alpha (m\alpha + d - 2)|x|^{m \alpha - m}$ where $d$ ≝ dimension

$\lambda |x|^\alpha = m\alpha (m\alpha + d - 2)|x|^{m \alpha - 2}$

Equating the exponents and solving for $\alpha$ :

${m \alpha - 2} = \alpha \Rightarrow \alpha = \frac{2}{m-1}$

$w(x) = |x|^{\frac{2}{m-1}}$

Equating the coefficients and solving for $\lambda$ :

$\lambda = m\alpha (m\alpha + d - 2)$

4) Obtain $u(x,t)$

$u(x,t) = v(t)\cdot w(x) = \frac{1}{\big((1-m)\lambda t+ c\big)^{\frac{1}{m-1}}} \cdot |x|^{\frac{2}{m-1}} \space \space \blacksquare$ 

	Notice that the denominator of the solution can be equal to 0 
	in a finite amount of time! 

	This means that the solution blows up at a finite time, which implies that 
	the solution cannot be correct. 

	That is why a different form of a solution was proposed by the 
	Russian mathematician Grigory Barenblatt. 

	The Barenblatt solution is what will be used in this report to model the 
	partial differential equation for a Gas Transport in a Porous Medium. 
"

# ╔═╡ 571bd08a-f493-4a46-b314-d7ab5b2210a0
md" ## Barenblatt Function 
$b(x,t) = max \bigg ( 0,t^{-\alpha}(1-\frac{α(m-1)r^2}{2dmt\frac{2α}{d}})^{\frac{1}{m-1}} \bigg )$ where : \
\
$r = |x|$ ,
 $α = \frac{1}{m-1+\frac{2}{d}}$
"

# ╔═╡ 6de33253-fcea-4e5a-bb2b-9115e0a46ad2
function barenblatt(x, t, M = 2, dims = 1)  # Method for 1D grid
   
	    Γ = 1.
		α = 1. /(M - 1.0 + 2.0/dims)
		r = abs(x)
	
	    z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. *dims*M*t^(2. *α/dims)))^(1. /(M-1.)))
		return z
end;

# ╔═╡ f7d7dfc5-ee9c-4b64-ae96-f58ee410acc1
begin
	X_coordinate = -2.5:.01:2.5
	line_width = 3.
	line_colour = "#ccccff"
	
	plot(X_coordinate,barenblatt.(X_coordinate,0.01), title = "Barenblatt profiles in 1D", legend = false, xticks = false, yticks = false, grid = false, colour = line_colour, lw = line_width, showaxis = :xy, framestyle = :zerolines)

	plot!(X_coordinate,barenblatt.(X_coordinate,0.03), style = :dash,colour = line_colour, lw = line_width, opacity = .5)
	
	plot!(X_coordinate,barenblatt.(X_coordinate,0.08),colour = line_colour, lw = line_width)

	plot!(X_coordinate,barenblatt.(X_coordinate,0.13), style = :dash,colour = line_colour, lw = line_width,opacity = .5)

	plot!(X_coordinate,barenblatt.(X_coordinate,0.2),colour = line_colour, lw = line_width)
end

# ╔═╡ 9ca00af5-8d50-4bea-9d7b-c9559879ed94
begin
	function makeNormMatrix(x, y) #makes 3D Matrix of each element r(x,y)=Sqrt(x^2 + y^2)
		mat=zeros(length(x), length(y))
	
		for (idx_x, val_x) in enumerate(x)
			for (idx_y, val_y) in enumerate(y) 
				mat[idx_x, idx_y] = sqrt(val_x^2 + val_y^2)
			end
		end
		return mat
	end

	function Barenblatt3D(x, y, t, m, d=1, Γ=1) #uses the regular BB func to evuate each element of matrix r(x,y) and gives a BB func weighted matrix out 
		mat = makeNormMatrix(x,y)
		funcMatrix = map(x->barenblatt(x,0.1,2), mat)
		return funcMatrix
	end
	
	barenblatt_surface = Barenblatt3D(X_coordinate, X_coordinate, 0.1, 2, 1, 1) 

	gradient = cgrad(["#DFAFBC", "#F5C1CF", "#E1C7E7", "#D7CAF3", "#CCCCFF"])
	
	plot(barenblatt_surface, ticks = false, st= :surface, c = gradient, showaxis = false, title = "Barenblatt 2D", legend = :none)
end

# ╔═╡ cf0383b2-292d-4c9a-a375-3b6a86f4b9f2
md"These profiles are the alternative to Gaussian profiles, which are usually seen in diffusion problems

The Barenblatt function is a useful test case for determining the validity of the solution produced by Finite Volume Method solver.
"
#The fact that the profiles are parabolas for $m=2$ indicates that they are a strong solution of the parabolic differential equation problem"

# ╔═╡ cda86f5e-700c-46d5-8fe6-7e05e35c8bd4
md"# Finite Volume Discretisation"

# ╔═╡ 1f644a7e-6bb5-44b2-8b1d-b39a18111ba4
md"## Generating Discretisation Grids"

# ╔═╡ bcdce42b-f6e5-4269-a95e-6e9edfb63d43
proposition"
__Idea__ :
 - Divide the domain into finite number of _finite volumes_ $\omega_k$
 - For each volume $\omega_k$, assign a single value $u_k = u(\vec{x_k})$ - ($u$ at a _collocation point_ $\vec{x_k}$)
 - Approximate $\vec{\nabla} u$
"

# ╔═╡ 560701d1-9ad8-4368-803e-17f72a18b761
md" 
 - Define: 
   - __Domain__ ≝ $\Omega \subset \mathbb{R}^d$
   - __Border of the domain__ ≝ $\partial \Omega$ - composed of union of planar parts $\Rightarrow \partial \Omega =  \cup_{m} \Gamma _m$
   - __Finite volumes__ ≝ $\omega_k$ - non intersecting open sets, $\bar{\omega_k}$ ≝ closure  
   - __Common bounds__ ≝ $\sigma_{kl} = \bar{\omega_k} \cap \bar{\omega_l}$
   $
   \sigma_{kl} \begin{cases} 
         = 0 & \Rightarrow \omega_k, \omega_l ≝ \space 'non\space neighbours' \\
         \neq 0 & \sigma_{kl} ≝ point/line \Rightarrow \omega_k, \omega_l ≝  \space    '\space neighbours'\\
      \end{cases}$

   - __Collocation point__ ≝ $\vec{x_k}\in \bar{\omega_k}$

"

# ╔═╡ 1ce3c86b-23c9-4687-b5c8-28f383eb5a82
md"
 - Collocation point rules :

   - if $\omega_k , \omega_l$ are neighbours $\Rightarrow$ line $\vec{x_k}\vec{x_l}\perp \sigma_{kl}$
   - if $\partial \omega_k \cap \partial \Omega \neq 0 \Rightarrow \vec{x_k} \in \partial \Omega$
"


# ╔═╡ b80011bf-dfe2-4044-b874-418c01398317
md"
- Approximate $\vec{\nabla}u\cdot \vec{n_{kl}} \approx \frac{u(\vec{x_k})-u(\vec{x_l})}{|\vec{x_k}-\vec{x_l}|}$
"

# ╔═╡ f536b466-2783-4099-bb75-ce35945ed71f
md"
For a __1D interval__ $\Omega = (a,b)$, one defines _finite volumes_ by :

$
\omega_{k} = \begin{cases} 
(x_1,\frac{x_1+x_2}{2}), & k = 1 \\
(\frac{x_{k-1}+x_{k}}{2},\frac{x_{k}+x_{k+1}}{2}), & 1<k<n\\
(\frac{x_{n-1}+x_{n}}{2},x_n), & k=n\\
\end{cases}$

where $x_1=a<x2<\dots <x_{n-1} < x_n =b$
"

# ╔═╡ 9606acd1-d1df-4668-81ba-ef8894133ac6
md"For a __generic 2D domain__ one uses the Delunay triangulation method to obtain collocation points $\vec{x_k}$ at the triangle vertices. Using Voronoi cells, one defines the _finite volumes_ with $\vec{x_k} \in \omega_k$"

# ╔═╡ a29532c0-03f3-4daa-8636-ef6c87630558
md"""
- __Forward__ approximation  | Truncation Error 1st order

$\frac{\partial u}{\partial \:x}\:\approx\:\frac{u_{i+1}\:-\:u_i}{\Delta x}$

- __Backward__ approximation | Truncation Error 1st order

$\frac{\partial u}{\partial \:x}\:\approx\:\frac{u_i\:-\:u_{i-1}}{\Delta x}$

- __Central__ approximation  | Truncation Error 2nd order

$\frac{\partial u}{\partial \:x}\:\approx\:\frac{u_{i+1}\:-\:u_{i-1}}{\Delta x}$
"""

# ╔═╡ 7c1b6922-df91-420b-8821-4de2c5fea2ea
md"""##### Accuracy of these approximations :"""

# ╔═╡ 8569a570-01ba-4084-be9b-d87555396e9c
md"""

Example evaluation for the accuracy for _Forward_ approximation.

$\frac{\partial u}{\partial \:x}\:\approx \:\frac{u_{i+1}\:-\:u_i}{\Delta x}\:-\:\left\{\frac{\Delta \:x}{2}\cdot \:\frac{\partial \:^2\:u}{\partial \:\:\:x^2}\right\}^i\:\:-\:\left\{\frac{\Delta \:\:x^2}{3!}\cdot \:\:\frac{\partial \:\:^3\:u}{\partial \:\:\:\:x^3}\right\}^i\: ...$

when $\left(x_{i+1}\:-\:x_i\right)=\Delta x\:\rightarrow 0\:$ one can neglect the 2nd and the higher order term to obtain the forward approximation $\frac{\partial u}{\partial \:x}\:\approx\:\frac{u_{i+1}\:-\:u_i}{\Delta x}$, i.e a decrease in the truncation error $O(\Delta x)$

As $\Delta x\rightarrow 0\:\propto \:Error\:\rightarrow 0.$ 
Hence the convergence of the _Forward_ difference

-----------------------------

These steps can be repeated to show the same for the _backward_ approximation.

-----------------------------

_Central_ approximation is essentially the addition of the _forward_ & the _backward_ approximation

For the _central_ difference approximation, the truncation error is $\:\approx O\left(\Delta x^2\right)$

"""

# ╔═╡ b4c8ddaa-f7b8-481b-99be-678b50af4f55
md"## Time Discretisation"

# ╔═╡ 1a2be55e-a7ad-480c-82e0-744cae76e88d
proposition" __Time discretisation options:__
1) Forward _explicit_ Euler method 
2) Backward _implicit_ Euler method
3) Cranck-Nicolson scheme
"

# ╔═╡ c68a801c-8b4f-4537-94d8-71f52885ece4
md"""
- __Time discretisation procedure__ :

  - Choose $t_0 < t_1 < \dots < t_N = t_{end}$
  - Define $\tau _n ≝ t_n - t_{n-1}$
In this case:

$u_\theta ≝ \theta u_n + (1-\theta)u_{n-1}$

For n = 1...N, solve

$\frac{u_n - u_{n-1}}{\tau_n}-\Delta u_\theta^m = 0 \space \space \space in \space \Omega \times [t_0,t_{end}]$ where $\Omega = [-L,L]$

"""

# ╔═╡ 5089e81d-97e8-4512-b9e3-b147638f7bf4
md" ### Methods comparison:

| Method :| $\theta :$ | Accuracy : | Stability condition :
|:---------- | ---------- |------------|:------------:|
| __Backward__ `implicit` Euler  | $1$ |$\mathscr{O}(t)$|_unconditional_|
| __Forward__ `explicit` Euler   | $0$ | $\mathscr{O}(t^2)$ |$\tau \leq Ch^2$|
| __Crank-Nicolson__    | $\frac{1}{2}$| $\mathscr{O}(t)$ |$\tau \leq 2Ch^2$|
"

# ╔═╡ c938c461-5005-449e-a1e7-0067bb4421b2
md"
      	Implicit (backward) Euler method can be applied in unstable 
	  systems (resulting in stiff matrices) due to unconditional stability
      of the method. In order to maintain time-accuracy one needs to choose
      the time steps sufficiently small enough due to first order time accuracy.
      Time accuracy as a result of this method suffers more.
"

# ╔═╡ 036054a9-57e3-4b32-9f82-b3db93734bfe
md"
      	Explicit (forward) Euler method can be used when time accuracy is
	  of high importance, as for a small timestep we obtain a very time 
      accurate system. One should be wary of the stability conditon having
      to be fullflied. A tight control of this condition is computatioanlly 
      costly thus it requires a fast system.
"

# ╔═╡ dba97448-0a74-45fe-acf5-2c9f0dccbcac
md"

	  	Different PDE problems/systems are characterised by different
      stability conditions, and on top of that come computer sysetm 
      limitations thus a time-discretisation choice is of high importance.
"

# ╔═╡ e17731ae-984a-443a-b377-50301e01c3e3
md"## Implicit Euler for Porous Medium"

# ╔═╡ 4dd861a4-18df-43d3-8227-2df87fc03bac
md"### 1 Dimensional Case"

# ╔═╡ ae8cdb91-dbff-4b0a-98ba-24608adf1b14
md"""
_Implicit_ Euler time step - for stability reasons

$\frac{\partial \:u}{\partial \:t}\:=\:\frac{\partial ^2\:u^m}{\partial \:x^2}\:\:$
"""

# ╔═╡ 2e40c901-eec0-49e6-a961-3a95866f2c8d
md"""

Using the _Backward_ difference for the time steps and the _Central_ difference for space to evaluate the equation:

Simplistic representation




$$\frac{\:u_x^{t+1}-u^t_x}{\Delta t\:}\:=\frac{\left(u^m\right)_{x+1}^{t+1}\:-2\cdot \left(u^m\right)_x^{t+1}+\left(u^m\right)_{x-1}^{t+1}\:\:}{\Delta x^2}$$

Super-scripts ≝ time-steps 

Sub-scripts ≝ spatial-steps

→ This formulation has more than 1 unknown in the Finite difference equation
"""

# ╔═╡ 21dd4a3a-dd1c-40e5-8b5b-9a6c3fc3ae99
md"Implicit Euler method stencil diagram  1D"

# ╔═╡ d5d00a19-f23e-4444-9554-6dc530743fa7
begin
	stencil_pic_1d = "https://i.postimg.cc/KYpsSkLT/1-D-implicit-Stencil.png"
	Resource(stencil_pic_1d, :width=>400)
end

# ╔═╡ 6f2e916d-f270-4e1a-9d9f-f13f17051fdd
md"
At one step, the calculation needs 2 unknowns from current time-step and 1 unknown from the previous time-step. Hence these unknows are coupled with other equations in the grid by writing the formula for all the grid points. Eventually this results in a tridiagonal coefficient matrix.

$$\begin{pmatrix}\frac{-1}{\Delta \:x^2}&\frac{1}{\Delta \:x^2}&0&0&.&.&\\ \frac{1}{\Delta x^2}&\frac{-2}{\Delta \:x^2}&\frac{1}{\Delta \:x^2}&0&.&&\\ 0&.&\frac{-2}{\Delta \:\:x^2}&.&.&&\\ .&.&.&.&.&&\\ .&.&.&.&.&&\\ &&&&&&\\ &&&&&&\end{pmatrix}$$

Since implicit time-steps are being used, each time-step can then be solved lineraly.
"

# ╔═╡ def425b2-4624-4161-9491-f5b2e625fa83
md"### 2 Dimensional Case"

# ╔═╡ 70e1196a-5280-4c19-a5e6-f675bc2de23c
md"""

$\frac{\partial u}{\partial \:t}=\left(\frac{\partial ^2\:u^m}{\partial \:\:x^2}\:+\:\frac{\partial ^2\:u^m}{\partial \:\:y^2}\right)$

__Implicit Euler for 2D - Porous Medium discretisation__

Simplistic representation

$\frac{\:u_{i,j}^{t+1}-u^t_{i,j}}{\Delta \:t\:}\: =$
$=
\frac{\left(u^m\right)_{i+1,\:j}^{t+1}\:-2\cdot \:\left(u^m\right)_{i,\:j}^{t+1}+\left(u^m\right)_{i-1,\:j}^{t+1}\:\:}{\Delta \:x^2}\:+\frac{\left(u^m\right)_{i,\:j+1}^{t+1}\:-2\cdot \:\:\left(u^m\right)_{i,\:j}^{t+1}+\left(u^m\right)_{i,\:j-1}^{t+1}\:\:}{\Delta \:\:y^2}\:$
"""

# ╔═╡ 04dfddf3-9a5d-4206-a1df-4521f74e9a49
md"Implicit Euler method 5 point stencil diagram  2D"

# ╔═╡ d3131ff5-efcf-4bf2-85e2-a29e58015227
begin
	stencil_pic_2d = "https://i.postimg.cc/fbjJyhJy/2-D-implicit-Stencil.png"
	Resource(stencil_pic_2d, :width=>500)
end

# ╔═╡ 996dc4a9-2cdf-4e80-9371-e994b1dd58de
md"""

Pentadiagonal matrix


Consequently there is a pentadiagonal matrix that results from the discretisation of the 2D porous medium equation.

$\begin{pmatrix}-\left(\frac{2}{\Delta \:x^2}+\frac{2}{\Delta \:\:y^2}\right)&\frac{1}{\Delta \:x^2}&0&...&\frac{1}{\Delta y^2}&&&&0&0\\ \frac{1}{\Delta x^2}&.&\frac{1}{\Delta \:x^2}&&&\frac{1}{\Delta \:y^2}&&&&0\\ 0&\frac{1}{\Delta \:x^2}&.&\frac{1}{\Delta \:x^2}&&&.&&&\\ ...&&\frac{1}{\Delta \:x^2}&.&.&&&.&&\\ \frac{1}{\Delta \:y^2}&&&.&.&&&&&\\ &\frac{1}{\Delta \:y^2}&&&&.&&&&\\ &&.&&&&&&&\\ &&&.&&&&&&\\ 0&&&&&&&&&\\ 0&0&&&&&&&&\end{pmatrix}$

"""

# ╔═╡ 721be4cd-6130-4a1f-9c7c-303d6b4b6941
md"The matrix above has a sparcity similar to the plot below:"

# ╔═╡ e8a3ad6a-bcd7-4da7-9243-423723704c60
begin
	spar = "https://i.postimg.cc/Gt0M3YNv/sparsity.png"
	Resource(spar, :width=>400)
end

# ╔═╡ 6e833899-da8d-465d-a1f1-4bfc0ca845a4
md"## Stability Analysis"

# ╔═╡ 70d40b13-e1af-4516-9e11-370a295e6a78
md"""
 Truncation errror ≝ $O(x)$ 


Coefficient matrix shown above ≝ $A$

$$O\left(x\right)=\:A\cdot u\:-\frac{\partial u}{\partial t}$$

Error ≝ $e=$  solution error$=$Exact solution $-$Numerical solution

$A\cdot e\:=\:O\left(x\right)$

"""

# ╔═╡ 75257aa1-537d-46e6-8885-ddd88baa6f17
md"""
Error analysis for unsteady PDEs

__Stability:__  

$\frac{\left|e\right|}{\left|O\right|}<Bound\left(Independent\:of\:grid\:resolution\right)$


$u^{n+1}\:=\:M\:\cdot u^n\:+O^n$

__M:__ is the evolution matrix, a coefficient matrix that gives the next time step evolution. 

__O:__ is the truncation error from time and space discretisation.

Similarly, an error equation for the evolution of the error can be written as:

$e^{n+1}\:=\:M\:\cdot e^n\:+O^n\:=\:M\left(M\:\cdot \:e^{n-1}\:+O^{n-1}\:\right)+O^{n-1} \: ...$
_Error accumulates and evolves over time for an unsteady PDE._ 

As one multiplies the matrix __M__ by the error many times over the time steps, __it is the 'eigen values' of M__ that determine if this operation results in values that continually increase or decrease over time steps.

$\left|Eigenvalues\left(M\right)\right|\le \:1$
Hence for the the solution to be "stable", eigen values of the evolution matrix "M" __have to be bounded within the unit circle__ in a complex plane (spectral radius $$< 1$$). Otherwise even small error values would accumulate and grow over time steps, giving unacceptably large final error values. 

Assuming non-chaotic PDEs, one can write a generalisation for the above error evolution equation for linearised non-linear PDE's as:

__N :__ Non-linear time evolution operator 

$\left|u^{t+1}\right|=N\left(\left|u^t\right|\right)\:\:\rightarrow \:Numerical\:solution$

$u^{t+1}=N\left(u^t\right)\:\:\rightarrow \:Exact\:solution$

$e^{t+1}=N\left(u^t\right)\:-\:N\left(\left|u^t\right|\right)\:+O^n\:\approx \:\frac{\partial N}{\partial \:\left|u^n\right|}\cdot e^n\:+\:O^n$


Hence, this derivative $\:\frac{\partial N}{\partial \:\left|u^n\right|}$ (a Jacobian of the numerical approximation), should have __eigen values within the unit circle__ in the complex plane for a stable solution of the non-linear PDE.

$\:\left|Eigenvalues\left(\frac{\partial \:\:\:N}{\partial \:\:\:\:\left|u^n\right|}\right)\:\right|\le \:1$



"""

# ╔═╡ c2690a65-5d99-4323-84d6-d90dd75dbd4b
proposition"""
-----------------------

Explicit Euler: forward difference in time steps with central difference in space applied to the porous medium equation, does not have the eigen values of its 'Jacobian of numerical approximation' within the unit circle in the complex plane. Hence it's an unstable method regardless of how small the trunction error is, since it would grow over time steps either way.

However

Implicit Euler: backward difference in time steps with central difference in space applied to the porous medium equation, has the eigen values of its 'Jacobian of numerical approximation' within the unit circle in the complex plane. Hence it produces a stable solution.

For this reason, the implicit Euler method is used in the simulation.

-----------------------
"""

# ╔═╡ 9a8290b8-6df0-414e-b134-19e8b63bd5f5
md"## Solving the Systems of Matrices"

# ╔═╡ 69cd68da-d128-4d69-a3eb-b2e09e9894d4
md"Each linear time step can be solved using Newton's Method. In order to use such a method, one requires the idea of dual numbers (easily implemented in Julia) which allows the usage of automatic differentiation. This method can also be applied to transient problems."

# ╔═╡ c787a29f-177b-4e14-a189-9d2e498dc62a
md"# Simulation Results"

# ╔═╡ 9af48b8b-3697-4769-8629-29b63564acd0
md"## System Preparation with VoronoiFVM"

# ╔═╡ e7d040ad-161b-4aac-977e-0c063245644a
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

# ╔═╡ a9140e98-693a-4d2d-b9df-6e61d7c0bde3
function create_system(grid; m=2, unknown_storage=:sparse)
	
	physics = VoronoiFVM.Physics(
                                flux = function(f, u, edge)
                                          f[1] = u[1, 1]^m - u[1, 2]^m
                                	   end,

                                storage = function(f, u, node)
                                    	     f[1] = u[1]
                                          end
                                )

    system = VoronoiFVM.System(grid, physics, unknown_storage=unknown_storage)

	return system
end

# ╔═╡ d6fb079e-7154-4c64-9aba-6e02d6723878
function solve_system_vFVM(grid, system; t0=0.001, tstep=1e-5, tend=0.01)
	
	enable_species!(system, 1, [1])
	
	# inival ---------------------------
	function barenblatt_iniv(coordinates...; t=t0, M=2)
		Γ = 0.2
		dimensions = length(coordinates)
		α = 1.0 /(M - 1.0 + 2.0/dimensions)
		# collect the coordinates tuple to perform operations on it
		r = LinearAlgebra.norm(collect(coordinates)) 
		z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. * dimensions*M*t^(2. *α/dimensions)))^(1. /(M-1.)))
		
		return z
	end

	function barenblatt_endv(coordinates...; t=tend, M=2)
		Γ = 0.2
		dimensions = length(coordinates)
		α = 1.0 /(M - 1.0 + 2.0/dimensions)
		# collect the coordinates tuple to perform operations on it
		r = LinearAlgebra.norm(collect(coordinates)) 
		z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. * dimensions*M*t^(2. *α/dimensions)))^(1. /(M-1.)))
		
		return z
	end
	
	inival = unknowns(system)
    inival[1, :] .= map(barenblatt_iniv, grid) # Map initial conditions onto the grid
	# end inival ---------------------------

	# control ------------------------------
	control = VoronoiFVM.SolverControl()
	control.Δt_min = tstep*0.01 # for larger nx tstep < 0.001 now(tstep=0.0001)
	control.Δt = tstep
	control.Δt_max = 0.1*tend
	control.Δu_opt = 0.005 #0.05
	# end control --------------------------

	
	tsol = VoronoiFVM.solve(
				system, inival = inival, times = [t0, tend];
				control = control, log = true
				)
	
	error = norm(tsol[1, :, end] - map(barenblatt_endv, grid))
	
	return tsol, error
end

# ╔═╡ 02afdb62-a13d-4f7f-a81c-5ef13f43edc0
function create_error_array(method, dim, limit, step=5)
    error_array = []
    for i in collect(10:step:limit)
        grid = create_grid(i, dim)
        system = create_system(grid)
        _, error = method(grid, system)

        push!(error_array, error)
    end
    return error_array
end

# ╔═╡ 5866cbf3-e947-4ac0-92b5-157a076ccfd7
md"## Solving the System"

# ╔═╡ 137ff356-97b7-4659-8c53-e548c0a0cf94
begin
	grid_points = 40
	
	grid_1d = create_grid(grid_points, 1) 
	grid_2d = create_grid(grid_points, 2)

	system_1d = create_system(grid_1d) 
	system_2d = create_system(grid_2d)

	time_sol_1d, error_1d = solve_system_vFVM(grid_1d, system_1d)
	time_sol_2d, error_2d = solve_system_vFVM(grid_2d, system_2d)
	
end;

# ╔═╡ 46e24870-354f-43df-b576-c4539574dc78
error_array_1d = create_error_array(solve_system_vFVM, 1, 200);

# ╔═╡ 9ff628f6-c931-4ae5-bfdf-7dda8e935fa6
# error_array_2d = create_error_array(solve_system_vFVM, 2, grid_points);  # computationally heavy

# ╔═╡ 98447850-b6a3-4839-b9cf-857e8c9b7685
md"## Analysis of the Results"

# ╔═╡ d6c9722f-757f-4a48-80da-dbff60137a8c
begin
	error_plot_vfvm_1d = scatter(
		10:5:200, error_array_1d, 
		title = "Error : 1D VoronoiFVM.jl",
		xlabel = "Number of gridpoints", ylabel = "Error value", 
		legend = false, color = "#ccccff", 
		xrotation = 30, guidefontsize = 7
	)
	error_plot_vfvm_1d = plot!(10:5:200, error_array_1d, color="#ccccff")

	# uncomment the following lines to see the 2D plot
	#warning: computationally heavy
	#=
	error_plot_vfvm_2d = scatter(
		10:5:40, error_array_2d, title = "Error: 2D VoronoiFVM.jl", 
		xlabel = "Number of gridpoints", ylabel = "Error value", 
		legend = false, color = "#ccccff", 
		xrotation = 30, guidefontsize = 7
	)
	error_plot_vfvm_2d = plot!(10:5:40, error_array_2d, color = "#ccccff")

	p3 = plot(error_plot_vfvm_2d, error_plot_vfvm_12, layout = (2,1), dpi = 500)
=#
	plot(error_plot_vfvm_1d)  # replace with p3 if plotting 2D
end

# ╔═╡ 0b4d64a0-b950-479a-8652-3c3a4edf9dc9
md"### 1D System"

# ╔═╡ 58a6576a-45d1-47c6-ab0b-ee9f8e753ef9
timestep = @bind timestep Slider(1:length(time_sol_1d), show_value = true)

# ╔═╡ 0a338626-a11f-467b-9163-b5053a415f04
begin
	vis1d = GridVisualizer(Plotter=Plots, resolution=(1000, 1000), layout=(3, 1))
	gridplot!(vis1d[1, 1], grid_1d, title="1D grid")
	scalarplot!(vis1d[2, 1], grid_1d, time_sol_1d[1, :, timestep], limits=(0, 2), 
		title="Gas transport 1d at timestep: $timestep"
	)
	
	scalarplot!(vis1d[3, 1], system_1d, time_sol_1d, aspect=61, 
		title="Spacetime 1d gas transport"
	)	

	reveal(vis1d)
end

# ╔═╡ 5c445790-8bdf-41db-a803-91d1e9058c19
begin 
	plotMat = zeros(
					length(time_sol_2d.t), length(time_sol_1d.u[1]),
					length(time_sol_1d.u[1])
					) #(192 , 41 , 41) for n=20
		
	for i in 1:length(time_sol_2d.t) #192   for n=20
			s = 0
		
			for k in 1:length(time_sol_1d.u[1]) # 41
				for j in 1:length(time_sol_1d.u[1]) #41
					s += 1
					plotMat[i, k , j] = time_sol_2d[i][s]			
				end
			end
	
	end
	
	plotMat  #3D Matrix 
end;

# ╔═╡ 2822f1f8-6d96-46ee-a85f-6097dfc5dbee
black = cgrad([:black, :black]); # Gradient to colour surface plot

# ╔═╡ 3082b60d-cc3c-426d-a31a-c0c288641272
md"### 2D System"

# ╔═╡ b663cdbe-00cb-4f20-a497-f2c21562255d
#=
begin
	# WARNING
	# very computationally heavy 
	vis2d_1 = GridVisualizer(Plotter=Plots)	
	gridplot!(vis2d_1, grid_2d, title="2D grid", legend=:rt, show=true)
end
=#

# ╔═╡ 5026fc32-1488-4bc0-8407-c27194adbfb5
begin
	grid_image = "https://i.postimg.cc/gJdxdLVr/Grid-2d.png"
	Resource(grid_image)
end

# ╔═╡ f5289204-f1ee-40b6-ae7c-6af06c26f0fa
time_step = @bind time_step Slider(1:length(time_sol_2d), show_value = true)

# ╔═╡ 534c5a7f-f77c-48ab-961f-89c01f5353bf
begin
	vis2d_2 = GridVisualizer(Plotter = Plots)
	scalarplot!(vis2d_2, grid_2d, time_sol_2d[1, :, time_step], xlabel="x", title="Gas transport 2d at timestep : $time_step", show = true, size = (600,600))
end

# ╔═╡ f372a153-0956-46a9-91d0-dc0feafe5f2f
md"Legend"

# ╔═╡ c3404f7d-365b-417d-8151-e52eb494ffc7
md" $t = t_0$ $\hspace{270px}$ t → $\hspace{270px}$ $t = t_{end}$ "

# ╔═╡ 93ea4cb1-4717-459f-ae5a-d0388d691e25
cgrad([:white, :black])

# ╔═╡ 28307181-6746-426c-baef-b54e94ad2443
begin 

    plot(
        plotMat[1,:,:], alpha = 0.1, st = :surface, 
		c = black, label = "1", 
		xlabel = "x", xticks = false,
		ylabel = "y", yticks = false, 
		zlabel = "z", zticks = false, 
		title = "Space-time 2D gas transport", legend = false, size = (500,500)
    )
    plot!(
        plotMat[Int64(round(length(time_sol_2d.t) - 4(length(time_sol_2d.t)/5))),
            :, :],
        alpha = 0.2, st= :surface, c = black
	)
    plot!(
        plotMat[Int64(round(length(time_sol_2d.t) - 3(length(time_sol_2d.t)/5))),
            :, :],
		alpha = 0.25, st = :surface, c = black
	)
    plot!(
        plotMat[Int64(round(length(time_sol_2d.t) - 2*(length(time_sol_2d.t)/5))),
            :, :], 
		alpha = 0.3, st = :surface, c = black
	)
    plot!(
        plotMat[Int64(round(length(time_sol_2d.t) - (length(time_sol_2d.t)/5))),
            :, :], 
		alpha = 0.4, st = :surface, c = black
	)
    plot!(
        plotMat[Int64(round(length(time_sol_2d.t))),
            :, :], 
		alpha = 0.5, st= :surface, c = black
	)

end

# ╔═╡ 51ea552d-69d3-4fde-8984-0ee6194635bc
md" ## Comparison with DifferentialEquations.jl"

# ╔═╡ f7a8881f-cd8e-416e-8406-2866587839d4
md"### System preparation"

# ╔═╡ ae161e12-1cde-402d-bc74-690d8ff83ae1
function solve_system_diffeq(grid, system; t0=0.001, tend=0.01)

	function barenblatt_iniv(coordinates...; t=t0, M=2)
		Γ = 0.2
		dimensions = length(coordinates)
		α = 1.0 /(M - 1.0 + 2.0/dimensions)
		# collect the coordinates tuple to perform operations on it
		r = LinearAlgebra.norm(collect(coordinates)) 
		z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. * dimensions*M*t^(2. *α/dimensions)))^(1. /(M-1.)))
		
		return z
	end

	function barenblatt_endv(coordinates...; t=tend, M=2)
		Γ = 0.2
		dimensions = length(coordinates)
		α = 1.0 /(M - 1.0 + 2.0/dimensions)
		# collect the coordinates tuple to perform operations on it
		r = LinearAlgebra.norm(collect(coordinates)) 
		z = max(0., t^(-α)*(Γ-(α*(M-1.)*r^2.)/(2. * dimensions*M*t^(2. *α/dimensions)))^(1. /(M-1.)))
		
		return z
	end

    enable_species!(system, 1, [1])

    inival = unknowns(system)
    inival = map(barenblatt_iniv, grid)

    problem = ODEProblem(system, inival, (t0, tend))
    odesol = DifferentialEquations.solve(problem)

    tsol = reshape(odesol, system)
    error = norm(tsol[1, :, end] - map(barenblatt_endv, grid))

    return tsol, error
end

# ╔═╡ 2df84c74-7eb7-4a60-8965-55ce2d84b88d
md"### Solving the System"

# ╔═╡ eeeb6dc2-27bb-4a8b-97aa-b15ebfe7a734
md"#### 1D Case"

# ╔═╡ d3033645-5f12-4f86-b0b5-866ee702396b
error_array_diffeq_1d = create_error_array(solve_system_diffeq, 1, 200);

# ╔═╡ 2a7e29c8-44a7-4121-882b-f7a4d603197c
begin
	error_plot_diffeq_1d = scatter(10:5:200, error_array_diffeq_1d, 
		title = "Error : 1D DifferentialEquations.jl", 
		xlabel ="Number of gridpoints", ylabel = "Error value", 
		legend = false, color = "#DFAFBC", 
		xrotation = 30, guidefontsize = 7, dpi = 500
	)
	error_plot_diffeq_1d = plot!(10:5:200, error_array_diffeq_1d, color="#DFAFBC")
end

# ╔═╡ e81ac263-3821-4253-b56a-194d2bb339cc
begin
	scatter(10:5:200, error_array_diffeq_1d, 
		title = "1D Error comparison",
		xlabel ="Number of gridpoints", ylabel = "Error value", 
		color = "#DFAFBC", xrotation = 30, guidefontsize = 7, 
		label = "DifferentialEquations.jl", dpi = 500
	)
	plot!(10:5:200, error_array_diffeq_1d, color="#DFAFBC", label=false)
	
	scatter!(10:5:200, error_array_1d, color="#ccccff", label="VoronoiFVM.jl")
	plot!(10:5:200, error_array_1d, color="#ccccff", label=false)
end
	

# ╔═╡ d07d902e-b7f9-474d-bc4b-ab1fb280cbc3
md"#### 2D Case"

# ╔═╡ 9488a7f3-f356-4d2d-b9f2-a8003e055a80
md"The 2D case is computationally intensive. To avoid having the computer calculate for approximately 15 minutes, the pictures displayed below are embedded. All these pictures have been produced with the uncommented code in the next cells."

# ╔═╡ 8abb6989-e941-4775-a578-ef2b06834afd
# error_array_diffeq_2d = create_error_array(solve_system_diffeq, 2, grid_points);

# ╔═╡ 258a8715-3aee-4fca-85fa-411a39028019
#=begin
	error_plot_diffeq_2d = scatter(10:5:200, error_array_diffeq_2d, 
		title = "2D DifferentialEquations.jl", 
		xlabel ="Number of gridpoints", ylabel = "Error value", 
		legend = false, color = "#DFAFBC", 
		xrotation = 30, guidefontsize = 7, dpi = 500
	)
	error_plot_diffeq_2d = plot!(10:5:200, error_array_diffeq_2d, color="#DFAFBC")
end=#

# ╔═╡ 1541286c-573f-476e-a950-f691d03e4d23
begin
	diff_equation_2d = "https://i.postimg.cc/RVczm0hb/error-diffeq-2d-fine.png"
	Resource(diff_equation_2d, :width=>800)
end

# ╔═╡ 322b4403-7f62-4173-bf79-1a1113ea43bb
#=begin
	comparison = scatter(10:5:40, error_array_2d, label="VoronoiFVM", color="#DFAFBC")
	comparison = plot!(10:5:40, error_array_2d, label=false, color="#DFAFBC")
	comparison = scatter!(10:5:40, error_array_diffeq_2d, label="Differential Eq.", color="#ccccff")
	comparison = plot!(10:5:40, error_array_diffeq_2d, label=false, color="#ccccff")
	comparison = plot!(title="Comparison Between Error Values", dpi=500)
end=#

# ╔═╡ 6f1a07b0-35c1-4784-9f61-b1ed13ea9cdd
begin
	comparison_img = "https://i.postimg.cc/ry4qgwxP/Error-comparison.png"
	Resource(comparison_img)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
ExtendableGrids = "cfc395e8-590f-11e8-1f13-43a2532b2fa8"
GridVisualize = "5eed8a63-0fb0-45eb-886d-8d5a387d12b8"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
VoronoiFVM = "82b139dc-5afc-11e9-35da-9b9bdfd336f3"

[compat]
DifferentialEquations = "~7.1.0"
ExtendableGrids = "~0.9.5"
GridVisualize = "~0.5.1"
HypertextLiteral = "~0.9.3"
Plots = "~1.27.6"
PlutoUI = "~0.7.38"
VoronoiFVM = "~0.16.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractAlgebra]]
deps = ["GroupsCore", "InteractiveUtils", "LinearAlgebra", "MacroTools", "Markdown", "Random", "RandomExtensions", "SparseArrays", "Test"]
git-tree-sha1 = "f4a6ecff7407a29d5d15503508144b7cc81bdc63"
uuid = "c3fe647b-3220-5bb0-a1ea-a7954cac585d"
version = "0.25.3"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "c933ce606f6535a7c7b98e1d86d5d1014f730596"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.7"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c23473c60476e62579c077534b9643ec400f792b"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "0.8.6"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AutoHashEquals]]
git-tree-sha1 = "45bb6705d93be619b81451bb2006b7ee5d4e4453"
uuid = "15f4f7f2-30c1-5605-9d31-71845cf9641f"
version = "0.2.0"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "019aa88766e2493c59cbd0a9955e1bac683ffbcd"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.16.13"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "Future", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables", "ZygoteRules"]
git-tree-sha1 = "b15a6bc52594f5e4a3b825858d1089618871bf9d"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.36"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.Bijections]]
git-tree-sha1 = "705e7822597b432ebe152baa844b49f8026df090"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.3"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "28bbdbf0354959db89358d1d79d421ff31ef0b5e"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.3"

[[deps.BoundaryValueDiffEq]]
deps = ["BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NLsolve", "Reexport", "SparseArrays"]
git-tree-sha1 = "fe34902ac0c3a35d016617ab7032742865756d7d"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "2.7.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "Static"]
git-tree-sha1 = "baaac45b4462b3b0be16726f38b789bf330fcb7a"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.21"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "f576084239e6bdf801007c80e27e2cc2cd963fe0"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.6"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.CompositeTypes]]
git-tree-sha1 = "d5b014b216dc891e81fea299638e4c10c657b582"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.2"

[[deps.CompositionsBase]]
git-tree-sha1 = "455419f7e328a1a2493cabc6428d79e951349769"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DEDataArrays]]
deps = ["ArrayInterface", "DocStringExtensions", "LinearAlgebra", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "5e5f8f363c8c9a2415ef9185c4e0ff6966c87d52"
uuid = "754358af-613d-5f8d-9788-280bf1605d4c"
version = "0.2.2"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "UnPack"]
git-tree-sha1 = "52f54bd7f7bc1ce794add0ccf08f8fa21acfaed9"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.35.1"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "ChainRulesCore", "DEDataArrays", "DataStructures", "Distributions", "DocStringExtensions", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "IterativeSolvers", "LabelledArrays", "LinearAlgebra", "Logging", "MuladdMacro", "NonlinearSolve", "Parameters", "PreallocationTools", "Printf", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "StaticArrays", "Statistics", "SuiteSparse", "ZygoteRules"]
git-tree-sha1 = "3c55535145325e0e3fa7a397e3a50e5f220d1edc"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.83.2"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "LinearAlgebra", "NLsolve", "OrdinaryDiffEq", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "c4b99e3a199e293e7290eea94ba89364d47ee557"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.22.0"

[[deps.DiffEqJump]]
deps = ["ArrayInterface", "Compat", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "546fa9cc998bcd31bf9e3c928df757106cbf72b3"
uuid = "c894b116-72e5-5b58-be3c-e6d8d4ac2b12"
version = "8.3.1"

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "LinearAlgebra", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "Requires", "ResettableStacks", "SciMLBase", "StaticArrays", "Statistics"]
git-tree-sha1 = "d6839a44a268c69ef0ed927b22a6f43c8a4c2e73"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.9.0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqJump", "DiffEqNoiseProcess", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "3f3db9365fedd5fdbecebc3cce86dfdfe5c43c50"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.1.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "221ff6c6c9ede484e9f8be4974697187c06eb06b"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.55"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "StaticArrays", "Statistics"]
git-tree-sha1 = "5f5f0b750ac576bcf2ab1d7782959894b304923e"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.5.9"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DynamicPolynomials]]
deps = ["DataStructures", "Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "d0fa82f39c2a5cdb3ee385ad52bc05c42cb4b9f0"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.4.5"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.ElasticArrays]]
deps = ["Adapt"]
git-tree-sha1 = "a0fcc1bb3c9ceaf07e1d0529c9806ce94be6adf9"
uuid = "fdbdab4c-e67f-52f5-8c3f-e7b388dad3d4"
version = "1.2.9"

[[deps.EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "d064b0340db45d48893e7604ec95e7a2dc9da904"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.5.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExponentialUtilities]]
deps = ["ArrayInterface", "GenericSchur", "LinearAlgebra", "Printf", "Requires", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "951c44b4af9d1e061d5cf789a30881471604c14c"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.14.0"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.ExtendableGrids]]
deps = ["AbstractTrees", "Dates", "DocStringExtensions", "ElasticArrays", "InteractiveUtils", "LinearAlgebra", "Printf", "Random", "SparseArrays", "StaticArrays", "Test", "WriteVTK"]
git-tree-sha1 = "cec19e62fc126df338de88585f45a763f7601bd3"
uuid = "cfc395e8-590f-11e8-1f13-43a2532b2fa8"
version = "0.9.5"

[[deps.ExtendableSparse]]
deps = ["DocStringExtensions", "LinearAlgebra", "Printf", "Requires", "SparseArrays", "SuiteSparse", "Test"]
git-tree-sha1 = "eb3393e4de326349a4b5bccd9b17ed1029a2d0ca"
uuid = "95c220a8-a1cf-11e9-0c77-dbfce5f500b3"
version = "0.6.7"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FastBroadcast]]
deps = ["LinearAlgebra", "Polyester", "Static"]
git-tree-sha1 = "b6bf57ec7a3f294c97ae46124705a9e6b906a209"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.1.15"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "80ced645013a5dbdc52cf70329399c35ce007fae"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.13.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "56956d1e4c1221000b7781104c58c34019792951"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "34e6147e7686a101c245f12dba43b743c7afda96"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.27"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "241552bc2209f0fa068b6415b1942cc0aa486bcc"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "57c021de207e234108a6f1454003120a1bf350c4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.6.0"

[[deps.GridVisualize]]
deps = ["ColorSchemes", "Colors", "DocStringExtensions", "ElasticArrays", "ExtendableGrids", "GeometryBasics", "HypertextLiteral", "LinearAlgebra", "Observables", "OrderedCollections", "PkgVersion", "Printf", "StaticArrays"]
git-tree-sha1 = "5d845bccf5d690879f4f5f01c7112e428b1fa543"
uuid = "5eed8a63-0fb0-45eb-886d-8d5a387d12b8"
version = "0.5.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.Groebner]]
deps = ["AbstractAlgebra", "Combinatorics", "Logging", "MultivariatePolynomials", "Primes", "Random"]
git-tree-sha1 = "8d5455230991c22a64f99afd3c36c476b7b8be4d"
uuid = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
version = "0.2.4"

[[deps.GroupsCore]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9e1a5e9f3b81ad6a5c613d181664a0efc6fe6dd7"
uuid = "d5909c97-4eac-4ecc-a3dc-fdd0858a4120"
version = "0.4.0"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "18be5268cf415b5e27f34980ed25a7d34261aa83"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.7"

[[deps.Hwloc]]
deps = ["Hwloc_jll"]
git-tree-sha1 = "92d99146066c5c6888d5a3abc871e6a214388b91"
uuid = "0e44f5e4-bd66-52a0-8798-143a42290a1d"
version = "2.0.0"

[[deps.Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "303d70c961317c4c20fafaf5dbe0e6d610c38542"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.7.1+0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "f366daebdfb079fd1fe4e3d560f99a0c892e15bc"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "bcf640979ee55b652f3b01650444eb7bbe3ea837"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.4"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "81b9477b49402b47fbe7f7ae0b252077f53e4a08"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.22"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "cae5e3dfd89b209e01bcd65b3a25e74462c67ee0"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.3.0"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "82f5afb342a5624dc4651981584a841f6088166b"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.8.0"

[[deps.KrylovKit]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "49b0c1dd5c292870577b8f58c51072bd558febb9"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.5.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LabelledArrays]]
deps = ["ArrayInterface", "ChainRulesCore", "LinearAlgebra", "MacroTools", "StaticArrays"]
git-tree-sha1 = "fbd884a02f8bf98fd90c53c1c9d2b21f9f30f42a"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.8.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "b651f573812d6c36c22c944dd66ef3ab2283dfa1"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.6"

[[deps.LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LightXML]]
deps = ["Libdl", "XML2_jll"]
git-tree-sha1 = "e129d9391168c677cd4800f5c0abb1ed8cb3794f"
uuid = "9c8b4983-aa76-5018-a973-4c85ecc9e179"
version = "0.9.0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "DocStringExtensions", "IterativeSolvers", "KLU", "Krylov", "KrylovKit", "LinearAlgebra", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "SuiteSparse", "UnPack"]
git-tree-sha1 = "6eb8e10ed29b85673495c29bd77ee0dfa8929977"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "1.15.0"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "44a7b7bb7dd1afe12bac119df6a7e540fa2c96bc"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.13"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SLEEFPirates", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "4acc35e95bf18de5e9562d27735bef0950f2ed74"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.108"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Metatheory]]
deps = ["AutoHashEquals", "DataStructures", "Dates", "DocStringExtensions", "Parameters", "Reexport", "TermInterface", "ThreadsX", "TimerOutputs"]
git-tree-sha1 = "0886d229caaa09e9f56bcf1991470bd49758a69f"
uuid = "e9d8d322-4543-424a-9be4-0cc815abe26c"
version = "1.3.3"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "6bb7786e4f24d44b4e29df03c69add1b63d88f01"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MuladdMacro]]
git-tree-sha1 = "c6190f9a7fc5d9d5915ab29f2134421b12d24a68"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.2"

[[deps.MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "393fc4d82a73c6fe0e2963dd7c882b09257be537"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.4.6"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "ba8c0f8732a24facba709388c74ba99dcbfdda1e"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.0"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.NonlinearSolve]]
deps = ["ArrayInterface", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "aeebff6a2a23506e5029fd2248a26aca98e477b3"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.16"

[[deps.Observables]]
git-tree-sha1 = "fe29afdef3d0c4a8286128d4e45cc50621b1e43d"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.4.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "bc0a748740e8bc5eeb9ea6031e6f050de1fc0ba2"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.6.2"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.OrdinaryDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastClosures", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "NonlinearSolve", "Polyester", "PreallocationTools", "RecursiveArrayTools", "Reexport", "SciMLBase", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "8031a288c9b418664a3dfbac36e464a3f61ace73"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.10.0"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "3114946c67ef9925204cc024a73c9e679cebe0d7"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.8"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "6f2dd1cf7a4bbf4f305a0d8750e351cb46dfbe80"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.PoissonRandom]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "44d018211a56626288b5d3f8c6497d28c26dc850"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.0"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "8d95a735921204f5d551ac300b20d802a150433a"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.6.8"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "7e597df97e46ffb1c8adbaddfa56908a7a20194b"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.5"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff", "LabelledArrays"]
git-tree-sha1 = "6c138c8510111fa47b5d2ed8ada482d97e279bee"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.2.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "747f4261ebe38a2bc6abf0850ea8c6d9027ccd07"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "afeacaecf4ed1649555a19cb2cad3c141bbc9474"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.5.0"

[[deps.RandomExtensions]]
deps = ["Random", "SparseArrays"]
git-tree-sha1 = "062986376ce6d394b23d5d90f01d81426113a3c9"
uuid = "fb686558-2515-59ef-acaa-46db3789a887"
version = "0.4.3"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "ChainRulesCore", "DocStringExtensions", "FillArrays", "LinearAlgebra", "RecipesBase", "Requires", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "bfe14f127f3e7def02a6c2b1940b39d0dabaa3ef"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.26.3"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "a9a852c7ebb08e2a40e8c0ab9830a744fa283690"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.10"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Referenceables]]
deps = ["Adapt"]
git-tree-sha1 = "e681d3bfa49cd46c3c161505caddf20f0e62aaa9"
uuid = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"
version = "0.1.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "cdc1e4278e91a6ad530770ebb327f9ed83cf10c4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "62c2da6eb66de8bb88081d20528647140d4daa0e"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "ac399b5b163b9140f9c310dfe9e9aaa225617ff6"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.32"

[[deps.SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "a5305dca1b3ebf83d9c92e2fa244424f1bdb1627"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.31.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SparseDiffTools]]
deps = ["Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays", "VertexSafeGraphs"]
git-tree-sha1 = "314a07e191ea4a5ea5a2f9d6b39f03833bde5e08"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "1.21.0"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "39c9f91521de844bad65049efd4f9223e7ed43f9"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.14"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "91181e5820a400d1171db4382aa36e7fd19bee27"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.3"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5950925ff997ed6fb3e985dcce8eb1ba42a0bbe7"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.18"

[[deps.SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "3e057e1f9f12d18cac32011aed9e61eef6c1c0ce"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.6.6"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqJump", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "4d428684218ac7a3dc54aaeb3f76e03bf892c33c"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.46.0"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "Requires", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "70d9007ff05440058c0301985b2275edc2b2ce25"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.3.3"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "Reexport", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "e0805213754f0d871f9333eacd77862a44acb46d"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.9.3"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "04777432d74ec5bc91ca047c9e0e0fd7f81acdb6"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.1+0"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "Metatheory", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "TermInterface", "TimerOutputs"]
git-tree-sha1 = "bfa211c9543f8c062143f2a48e5bcbb226fd790b"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "0.19.7"

[[deps.Symbolics]]
deps = ["ArrayInterface", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "Groebner", "IfElse", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "Metatheory", "NaNMath", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TermInterface", "TreeViews"]
git-tree-sha1 = "31f8130b2ee33985f10d7999ece5ed7d72c1be70"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "4.4.2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TermInterface]]
git-tree-sha1 = "7aa601f12708243987b88d1b453541a75e3d8c7a"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "0.2.3"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "f8629df51cab659d70d2e5618a430b4d3f37f2c3"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.0"

[[deps.ThreadsX]]
deps = ["ArgCheck", "BangBang", "ConstructionBase", "InitialValues", "MicroCollections", "Referenceables", "Setfield", "SplittablesBase", "Transducers"]
git-tree-sha1 = "d223de97c948636a4f34d1f84d92fd7602dc555b"
uuid = "ac1d9e8a-700a-412c-b207-f0111f4b6c0d"
version = "0.1.10"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "11db03dd5bbc0d2b57a570d228a0f34538c586b1"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.17"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "c76399a3bbe6f5a88faa33c8f8a65aa631d95013"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.73"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "b8d08f55b02625770c09615d96927b3a8396925e"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.11"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "Hwloc", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "858e541ffc21873e45aeaf744e0d015966e0328e"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.30"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[deps.VoronoiFVM]]
deps = ["DiffResults", "DocStringExtensions", "ExtendableGrids", "ExtendableSparse", "ForwardDiff", "GridVisualize", "IterativeSolvers", "JLD2", "LinearAlgebra", "Parameters", "Printf", "RecursiveArrayTools", "Requires", "SparseArrays", "SparseDiffTools", "StaticArrays", "Statistics", "SuiteSparse", "Symbolics", "Test"]
git-tree-sha1 = "254b5472a9f3ec970a08b24b76cba4bf1d79f3e6"
uuid = "82b139dc-5afc-11e9-35da-9b9bdfd336f3"
version = "0.16.3"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WriteVTK]]
deps = ["Base64", "CodecZlib", "FillArrays", "LightXML", "TranscodingStreams"]
git-tree-sha1 = "bff2f6b5ff1e60d89ae2deba51500ce80014f8f6"
uuid = "64499a7a-5c06-52f2-abe2-ccb03c286192"
version = "1.14.2"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─bb2682c2-4f42-442d-9c5d-cddda357fbd9
# ╟─e1d686e2-c60b-11ec-20d1-8f9ce5c08b8e
# ╟─72cc14a8-6f79-4b6d-b7a0-c5e76a6bd711
# ╟─87a34f4e-c396-482f-a310-0076d550e840
# ╟─047d17a3-134b-4cdd-b6b1-65c2b43df0fe
# ╟─7d61bfcd-cb35-4bac-9bf9-99a66b61809f
# ╟─e74c7bc4-46c6-4192-a80b-b895344e00fb
# ╟─571bd08a-f493-4a46-b314-d7ab5b2210a0
# ╟─6de33253-fcea-4e5a-bb2b-9115e0a46ad2
# ╟─f7d7dfc5-ee9c-4b64-ae96-f58ee410acc1
# ╟─9ca00af5-8d50-4bea-9d7b-c9559879ed94
# ╟─cf0383b2-292d-4c9a-a375-3b6a86f4b9f2
# ╟─cda86f5e-700c-46d5-8fe6-7e05e35c8bd4
# ╟─1f644a7e-6bb5-44b2-8b1d-b39a18111ba4
# ╟─bcdce42b-f6e5-4269-a95e-6e9edfb63d43
# ╟─560701d1-9ad8-4368-803e-17f72a18b761
# ╟─1ce3c86b-23c9-4687-b5c8-28f383eb5a82
# ╟─b80011bf-dfe2-4044-b874-418c01398317
# ╟─f536b466-2783-4099-bb75-ce35945ed71f
# ╟─9606acd1-d1df-4668-81ba-ef8894133ac6
# ╟─a29532c0-03f3-4daa-8636-ef6c87630558
# ╟─7c1b6922-df91-420b-8821-4de2c5fea2ea
# ╟─8569a570-01ba-4084-be9b-d87555396e9c
# ╟─b4c8ddaa-f7b8-481b-99be-678b50af4f55
# ╟─1a2be55e-a7ad-480c-82e0-744cae76e88d
# ╟─c68a801c-8b4f-4537-94d8-71f52885ece4
# ╟─5089e81d-97e8-4512-b9e3-b147638f7bf4
# ╟─c938c461-5005-449e-a1e7-0067bb4421b2
# ╟─036054a9-57e3-4b32-9f82-b3db93734bfe
# ╟─dba97448-0a74-45fe-acf5-2c9f0dccbcac
# ╟─e17731ae-984a-443a-b377-50301e01c3e3
# ╟─4dd861a4-18df-43d3-8227-2df87fc03bac
# ╟─ae8cdb91-dbff-4b0a-98ba-24608adf1b14
# ╟─2e40c901-eec0-49e6-a961-3a95866f2c8d
# ╟─21dd4a3a-dd1c-40e5-8b5b-9a6c3fc3ae99
# ╟─d5d00a19-f23e-4444-9554-6dc530743fa7
# ╟─6f2e916d-f270-4e1a-9d9f-f13f17051fdd
# ╟─def425b2-4624-4161-9491-f5b2e625fa83
# ╟─70e1196a-5280-4c19-a5e6-f675bc2de23c
# ╟─04dfddf3-9a5d-4206-a1df-4521f74e9a49
# ╟─d3131ff5-efcf-4bf2-85e2-a29e58015227
# ╟─996dc4a9-2cdf-4e80-9371-e994b1dd58de
# ╟─721be4cd-6130-4a1f-9c7c-303d6b4b6941
# ╟─e8a3ad6a-bcd7-4da7-9243-423723704c60
# ╟─6e833899-da8d-465d-a1f1-4bfc0ca845a4
# ╟─70d40b13-e1af-4516-9e11-370a295e6a78
# ╟─75257aa1-537d-46e6-8885-ddd88baa6f17
# ╟─c2690a65-5d99-4323-84d6-d90dd75dbd4b
# ╟─9a8290b8-6df0-414e-b134-19e8b63bd5f5
# ╟─69cd68da-d128-4d69-a3eb-b2e09e9894d4
# ╟─c787a29f-177b-4e14-a189-9d2e498dc62a
# ╟─dc011686-f8e1-48ee-8f44-53d1e92cb7a0
# ╟─9af48b8b-3697-4769-8629-29b63564acd0
# ╠═e7d040ad-161b-4aac-977e-0c063245644a
# ╠═a9140e98-693a-4d2d-b9df-6e61d7c0bde3
# ╠═d6fb079e-7154-4c64-9aba-6e02d6723878
# ╠═02afdb62-a13d-4f7f-a81c-5ef13f43edc0
# ╟─5866cbf3-e947-4ac0-92b5-157a076ccfd7
# ╠═137ff356-97b7-4659-8c53-e548c0a0cf94
# ╠═46e24870-354f-43df-b576-c4539574dc78
# ╠═9ff628f6-c931-4ae5-bfdf-7dda8e935fa6
# ╟─98447850-b6a3-4839-b9cf-857e8c9b7685
# ╟─d6c9722f-757f-4a48-80da-dbff60137a8c
# ╟─0b4d64a0-b950-479a-8652-3c3a4edf9dc9
# ╟─58a6576a-45d1-47c6-ab0b-ee9f8e753ef9
# ╟─0a338626-a11f-467b-9163-b5053a415f04
# ╟─5c445790-8bdf-41db-a803-91d1e9058c19
# ╟─2822f1f8-6d96-46ee-a85f-6097dfc5dbee
# ╟─3082b60d-cc3c-426d-a31a-c0c288641272
# ╠═b663cdbe-00cb-4f20-a497-f2c21562255d
# ╟─5026fc32-1488-4bc0-8407-c27194adbfb5
# ╟─f5289204-f1ee-40b6-ae7c-6af06c26f0fa
# ╟─534c5a7f-f77c-48ab-961f-89c01f5353bf
# ╟─f372a153-0956-46a9-91d0-dc0feafe5f2f
# ╟─c3404f7d-365b-417d-8151-e52eb494ffc7
# ╟─93ea4cb1-4717-459f-ae5a-d0388d691e25
# ╟─28307181-6746-426c-baef-b54e94ad2443
# ╟─51ea552d-69d3-4fde-8984-0ee6194635bc
# ╟─f7a8881f-cd8e-416e-8406-2866587839d4
# ╠═ae161e12-1cde-402d-bc74-690d8ff83ae1
# ╟─2df84c74-7eb7-4a60-8965-55ce2d84b88d
# ╟─eeeb6dc2-27bb-4a8b-97aa-b15ebfe7a734
# ╠═d3033645-5f12-4f86-b0b5-866ee702396b
# ╟─2a7e29c8-44a7-4121-882b-f7a4d603197c
# ╟─e81ac263-3821-4253-b56a-194d2bb339cc
# ╟─d07d902e-b7f9-474d-bc4b-ab1fb280cbc3
# ╟─9488a7f3-f356-4d2d-b9f2-a8003e055a80
# ╠═8abb6989-e941-4775-a578-ef2b06834afd
# ╠═258a8715-3aee-4fca-85fa-411a39028019
# ╠═1541286c-573f-476e-a950-f691d03e4d23
# ╠═322b4403-7f62-4173-bf79-1a1113ea43bb
# ╟─6f1a07b0-35c1-4784-9f61-b1ed13ea9cdd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
