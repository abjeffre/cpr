include("Y:/eco_andrews/Projects/CPR/code/analyitic/analyitic.jl")
using LaTeXStrings
using Plots

a=cpr_abm(tech = 1, n=150, max_forest = 1000, price = .01, genetic_evolution = false, inspect_timing = "after", learn_type = "income", nrounds = 1000, leak = false, mortality_rate = .5, pun1_on = false, nmodels = 40, fidelity = .25, regrow =.01,
 pun2_on = false, mutation = .2)

b=cpr_abm(tech = 1, n = 150*9, lattice = [1,9], ngroups = 9, max_forest = 1000*4.5, price = .01, genetic_evolution = false, inspect_timing = "after", learn_type = "income", nrounds = 1000, leak = false, pun1_on = false, mortality_rate = .5, nmodels = 40, fidelity = .25, regrow =.01,
 pun2_on = false, mutation = .2)

 plot(a[:stock][:,:,:1], ylim = (0,1), w = 4)
 plot!(b[:stock][:,:,:1], w = 4)

 plot(a[:payoffR][:,:,:1], w = 4)
 plot!(b[:payoffR][:,:,:1], w = 4)

 plot(a[:effort][:,:,:1], w = 4)
 plot!(b[:effort][:,:,:1], w = 4)


a[:harvest][42,:,1]
b[:harvest][20,:,1]
a[:payoffR][42,:,1]
b[:payoffR][20,:,1]
a[:effort][42,:,1]
b[:effort][20,:,1]
a[:stock][42,:,1]
b[:stock][20,:,1]


using Plots


effort=plot(b[:effort][:,2,:1], label = latexstring("E_U"), w = 4)
plot!(a[:effort][:,2,:1], label = latexstring("E_C"), w = 4 )
vline!([2000, 2000], c = :red, ls = :dash, w = 3, label = latexstring("T_L"))

plot(b[:payoffR][:,2,:1], label = latexstring("E_U"), w = 4)
plot!(a[:payoffR][:,2,:1], label = latexstring("E_C"), w = 4 )

plot(b[:harvest][:,2,:1], label = latexstring("E_U"), w = 4)
plot!(a[:harvest][:,2,:1], label = latexstring("E_C"), w = 4 )

vline!([2000, 2000], c = :red, ls = :dash, w = 3, label = latexstring("T_L"))



payoff=plot(b[:effort][:,2,:1], label = latexstring("E"), w = 4)
plot!(a[:effort][:,2,:1], label = latexstring("E_U"), w = 4 )
vline!([2000, 2000], c = :red, ls = :dash, w = 3)


# ########################################################
# ################# CONSTRAINED LABOR SUPPLY #############

q = .006
p = [250, 250]
# Without leakage
B, R, E₁, E₂, H₁, H₂ = cpr_adaptive_updating(q = q, c=.5, p=p, r = .02, ρ = 1, T = 2000, eRange = [0.01:0.01:.5, 0.01:0.01:.01])
# With  leakage
bB, bR, bE₁, bE₂, bH₁, bH₂ = cpr_adaptive_updating(q = q, c=.5, p=p, r = .02, ρ = 1, T = 2000, eRange = [0.01:0.01:.5, 0.01:0.01:1])

#Plot
stockC=plot(B, ylim = (0, 1), label = latexstring("B"), title = latexstring("max(e_r = .5)"), w =4)
plot!(bB, ylim = (0, 1), label = latexstring("B_{L}"), w =4)
plot!(fill(bB[2000], 2000), ylim = (0, 1), w = 3, ls =:dash, c = "red", label = latexstring("B_{GBE}") )

plot(R, ylim = (0, 1), label = latexstring("E_{R}"))


# ########################################################
# ############ UNCONSTRAINED LABOR SUPPLY ################


B, R, E₁, E₂, H₁, H₂ = cpr_adaptive_updating( q = q, c=.5, p=p, r = .020, ρ = 1, T = 2000, eRange = [0.01:0.01:1, 0.01:0.01:1])
bB, bR, bE₁, bE₂, bH₁, bH₂ = cpr_adaptive_updating( q = q, c=.5, p=p, r = .020, ρ = 1, T = 2000, eRange = [0.01:0.01:1, 0.01:0.01:1])

#Plot
stockU=plot(B, ylim = (0, 1), label = latexstring("B"), title = latexstring("max(e_r = 1)"), w =4)
plot!(bB, ylim = (0, 1), label = latexstring("B_{L}"), w =4)
plot!(fill(bB[2000], 2000), ylim = (0, 1), w = 3, ls =:dash, c = "red", label = latexstring("B_{GBE}") )


plot(E₁, ylim = (0, 1), label = latexstring("E_{R}"))
plot!(bE₁, ylim = (0, 1), label = latexstring("E_{R, L}"))

plot(stockC, stockU)

savefig("temp")