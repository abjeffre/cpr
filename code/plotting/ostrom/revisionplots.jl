using Plots.PlotMeasures

out = []
ngroups =2
for i in 0.5:.5:15
    c = cpr_abm(degrade = 1, n=100*ngroups, ngroups = ngroups, lattice = [1,2],
        max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 1000, leak = false,
        punish_seed = [0,3], learn_group_policy =false, invasion = false, nsim = 1, experiment_punish2 =1, experiment_limit = i,
        experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = .0,
        full_save = true, genetic_evolution = false, glearn_strat = "income"
        )
    push!(out, c)
end


pay=[out[i][:payoffR][end,1,1] for i in 1:length(out)]
limit=[out[i][:limit][end,1,1] for i in 1:length(out)]

Threshold=plot(limit, pay, xlab = "Limit", ylab = "Payoff", c =:black)
vline!([3.25, 3.25])
#
Trajedy=scatter(out[15][:harvestfull][500:1000,:,1], out[15][:payoffRfull][500:1000,:,1], label = "", c = :black, alpha = .2, xlab = "Harvest", ylab = "Payoff")


plot(out[1][:stock][:,:,1])
plot(out[15][:effort][:,:,1])


# plot(plot(c[:stock][:,:,1]), plot(c[:payoffR][:,:,1]))
p1 = plot(out[1][:stock][:,1,1], color = cgrad(:thermal, 15, rev = true, categorical = true)[1], xlab = "Time", ylab = "Resource Stock")
for i in 2:15 plot!(out[i][:stock][:,1,1],  color = cgrad(:thermal, 15, rev = true, categorical = true)[i]) end


p2 = plot(out[1][:payoffR][:,1,1], color = cgrad(:thermal, 15, rev = true, categorical = true)[1], xlab = "Time", ylab = "Payoff", ylim = (0,30))
for i in 2:15 plot!(out[i][:payoffR][:,1,1],  color = cgrad(:thermal, 15, rev = true, categorical = true)[i]) end

plot(p1, p2, Threshold, Trajedy, labels = "", width = 3, height  = 2, size = (2000, 650), bottom_margin = 40px, left_margin = 40px)


####################################################################
############################ DEMONSTRATE PULL TOWARDS MSY ##########

ngroups = 15
e = cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [1,ngroups], labor = 1,
   max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 6000, leak = false,
   limit_seed = [0.1, 4], learn_group_policy =false, invasion = true, nsim = 1, seized_on = false,
   experiment_group = collect(1:ngroups), control_learning = true, back_leak = true, outgroup = .05,
   full_save = true, genetic_evolution = false, glearn_strat = "income", experiment_punish2 = 1
  )

search=plot(e[:limit][:,:,1], label = "", xlab = "Time", ylab = "Policy", c = :black, alpha = .5)
stock = plot(e[:stock][:,:,1], label = "", c = :black, alpha =.1, xlab = "Time", ylab = "Resource Stock")
payoff = plot(e[:payoffR][:,:,1], label = "", c = :black, alpha =.2, xlab = "Time", ylab = "Resource Stock")

plot(search, stock, payoff)


###########################################################################################
################### GROUP SIZE SWEEP        ###############

@everywhere function g(x)
    ngroups = 40
    cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [1,ngroups],
    max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 20000, leak = false,
    learn_group_policy =false, invasion = true, nsim = 1, 
    experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = x,
    full_save = true, genetic_evolution = false, #glearn_strat = "income",
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))
end

cnt = 1
for i in collect(0:.02:.50)
    S = fill(i, 60)
    out=pmap(g, S)
    save(string("m1_",cnt,".jld2"), "out", out)
    out = nothing
    cnt +=1
end

#####################################################################
################### SAVE DATA #######################################

for i in collect(1:26)
    data=load(string("m1_", i, ".jld2"))
    payoff = []
    stock = []
    punish =[]
    limit = []
    for k in collect(1:60)
        push!(payoff, data["out"][k][:payoffR])
        push!(stock, data["out"][k][:stock])
        push!(punish, data["out"][k][:punish2])
        push!(limit, data["out"][k][:limit])
    end
    save(string("limit_", i, ".jld2"), "dat", limit)
    save(string("stock_", i, ".jld2"), "dat", stock)
    save(string("punish_", i, ".jld2"), "dat", punish)
    save(string("payoff_", i, ".jld2"), "dat", payoff)
end

######################################################################################
########################### 100 GROUPS ##############################################
@everywhere function g(x)
    ngroups = 100
    cpr_abm(degrade = 1, n=30*ngroups, ngroups = ngroups, lattice = [1,ngroups],
    max_forest = 1333*ngroups, tech = .00002, wages = 1, price = 3, nrounds = 15000, leak = false,
    learn_group_policy =false, invasion = true, nsim = 1, 
    experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = x,
    full_save = true, genetic_evolution = false, #glearn_strat = "income",
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))
end

cnt = 1
for i in [0, .05, .1, .2, .4]
    S = fill(i, 50)
    out=pmap(g, S)
    save(string("m2_",cnt,".jld2"), "out", out)
    out = nothing
    cnt +=1
end

#####################################################################
################### SAVE DATA #######################################

for i in collect(1:26)
    data=load(string("m2_", i, ".jld2"))
    payoff = []
    stock = []
    punish =[]
    limit = []
    for k in collect(1:60)
        push!(payoff, data["out"][k][:payoffR])
        push!(stock, data["out"][k][:stock])
        push!(punish, data["out"][k][:punish2])
        push!(limit, data["out"][k][:limit])
    end
    save(string("limit2_", i, ".jld2"), "dat", limit)
    save(string("stock2_", i, ".jld2"), "dat", stock)
    save(string("punish2_", i, ".jld2"), "dat", punish)
    save(string("payoff2_", i, ".jld2"), "dat", payoff)
end


######################################################################################
########################### 300 GROUPS ##############################################
@everywhere function g(x)
    ngroups = 300
    cpr_abm(degrade = 1, n=10*ngroups, ngroups = ngroups, lattice = [1,ngroups],
    max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 20000, leak = false,
    learn_group_policy =false, invasion = true, nsim = 1, 
    experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = x,
    full_save = true, genetic_evolution = false, #glearn_strat = "income",
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))
end

cnt = 1
for i in collect(0:.02:.50)
    S = fill(i, 60)
    out=pmap(g, S)
    save(string("m3_",cnt,".jld2"), "out", out)
    out = nothing
    cnt +=1
end

#####################################################################
################### SAVE DATA #######################################

for i in collect(1:26)
    data=load(string("m3_", i, ".jld2"))
    payoff = []
    stock = []
    punish =[]
    limit = []
    for k in collect(1:60)
        push!(payoff, data["out"][k][:payoffR])
        push!(stock, data["out"][k][:stock])
        push!(punish, data["out"][k][:punish2])
        push!(limit, data["out"][k][:limit])
    end
    save(string("limit3_", i, ".jld2"), "dat", limit)
    save(string("stock3_", i, ".jld2"), "dat", stock)
    save(string("punish3_", i, ".jld2"), "dat", punish)
    save(string("payoff3_", i, ".jld2"), "dat", payoff)
end



##############################################
########### WHY DOES THIS WORK ###############

# This works because agents parasitize those extracting resources. 

ngroups = 100
ok2=cpr_abm(degrade = 1, n=30*ngroups, ngroups = ngroups, lattice = [1,ngroups],
max_forest = 1333*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 10000, leak = false,
learn_group_policy =false, invasion = true, nsim = 1, 
experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = .01,
full_save = true, genetic_evolution = false, glearn_strat = "income", #socialLearnYear =collect(1:10:5000)
limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))

plot(plot(ok[:limit][:,:,1], label = ""), plot(ok[:stock][:,:,1], label = ""), plot(ok[:payoffR][:,:,1], label = ""), layout = grid(1,3), size = (1000, 300))
plot(plot(ok2[:limit][:,:,1], label = ""), plot(ok2[:stock][:,:,1], label = ""), plot(ok2[:payoffR][:,:,1], label = ""), layout = grid(1,3), size = (1000, 300))


for i in collect(1:26)
    data=load(string("m1_", i, ".jld2"))
    payoff = []
    stock = []
    punish =[]
    limit = []
    for k in collect(1:60)
        push!(payoff, data["out"][k][:payoffR])
        push!(stock, data["out"][k][:stock])
        push!(punish, data["out"][k][:punish2])
        push!(limit, data["out"][k][:limit])
    end
    save(string("limit_", i, ".jld2"), "dat", limit)
    save(string("stock_", i, ".jld2"), "dat", stock)
    save(string("punish_", i, ".jld2"), "dat", punish)
    save(string("payoff_", i, ".jld2"), "dat", payoff)
end


#############################################################
############ CHECKING #######################################
using JLD2
using Plots
using StatsBase
ms = []
for k in 1:26
    out=load("C:/user/jeffr/Documents/Work/cpr/data/stock_$k.jld2")
    dat = out["dat"]
    p1=plot(dat[1][1:10:10000,:,1], label = "", c = :black, alpha = .01)
    for i in 2:60 plot!(dat[i][1:10:10000,:,1], label = "", c = :black, alpha = .01) end
    p1
    a1=[mean(Float64.(dat[i][9900:end,:,1])) for i in 1:60]
    push!(ms, mean(a1))
end

plot(ms)



##################################################
################# CONTEXTUAL ANALYSIS #############

ngroups = 100
ntemp = 30
ok2=cpr_abm(degrade = 1, n=ntemp*ngroups, ngroups = ngroups, lattice = [10,10], distance_adj = .01, inspect_timing = "before",
max_forest = 1333*ntemp*ngroups, tech = .00002, wages = 1, price = 3, nrounds = 2000, leak = true, punish_cost = 0.0001,
learn_group_policy =false, invasion = true, nsim = 1, experiment_punish2 = 1, seized_on = true, experiment_limit = 2,
experiment_group = collect(1:ngroups), control_learning = true, back_leak = true, outgroup = .1, density_alpha = 0, fidelity = .1,
full_save = true, genetic_evolution = false, socialLearnYear =collect(1:10:5000),
limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))


# Loop over every year and run two regression
# 1.  Decomposition of fitness.
# 2.  The strength of selection.

# Do this for both contextual analysis and price equations
# Contextual analysis
# 1. fitness = c1*x + c2*X   
# 2. selection δx = c1*var(x) + c2*var(X)

# Price equation
# 1. fitness = c1(x-X) + (c1+c2)*X   
# 2. selection δx = c1(var(x)-var(X)) + (c1+c2)*var(X)

using GLM
using Plots

plot(ok2[:stock][:,:,1], label = "")
plot(ok2[:payoffR][:,:,1], label = "")
plot(ok2[:effort][:,:,1], label = "")
plot(ok2[:limit][:,:,1], label = "")
plot(ok2[:punish][:,:,1], label = "")
plot(mean(ok2[:leakage][:,:,1], dims =2), label = "")

Inv_coefs = []
G_coefs = []
for i in 1:3000
    dat = DataFrame(Y = Float64.(ok2[:payoffRfull][i,:,1]),
                    X = Float64.(ok2[:limit][i,Int.(ok2[:gid][:,1,1]),1]),
                    x = Float64.(ok2[:limitfull][i,:,1]))
    a=lm(@formula(Y ~ x + X), dat)
    push!(G_coefs, coef(a)[3])
    push!(Inv_coefs, coef(a)[2])
end

plot(Inv_coefs)
plot!(G_coefs)
hline!([0,0])
#######################
########## PRICE ######

using GLM
using Plots
Inv_coefs = []
G_coefs = []
for i in 1:3000
    dat = DataFrame(Y = Float64.(ok2[:payoffRfull][i,:,1]),
                    X = Float64.(ok2[:limit][i,Int.(ok2[:gid][:,1,1]),1]),
                    x = Float64.(ok2[:limitfull][i,:,1]))
    dat.x = dat.x .-dat.X
    a=lm(@formula(Y ~ x + X), dat)
    push!(G_coefs, coef(a)[3])
    push!(Inv_coefs, coef(a)[2])
end

plot(Inv_coefs)
plot!(G_coefs)
hline!([0,0])





##########################################
########### CONTEXTUAL SELECTION #########
dat = DataFrame(p = mean(Float64.(ok2[:limitfull][2,:,1].-ok2[:limitfull][1,:,1])),
                X = var(Float64.(ok2[:limit][1,:,1])),
                x = mean([var(Float64.(ok2[:limitfull][1,Int.(ok2[:gid][:,1,1]) .== j,1])) for j in 1:100])
)

for i in 2:1999
    temp = DataFrame(p = mean(Float64.(ok2[:limitfull][i+1,:,1].-ok2[:limitfull][i,:,1])),
                X = var(Float64.(ok2[:limit][i,:,1])),
                x = mean([var(Float64.(ok2[:limitfull][i,Int.(ok2[:gid][:,1,1]) .== j,1])) for j in 1:100])    )

    append!(dat, temp)
end


plot(dat.x)
plot!(dat.X)
plot!(dat.p)

dat = dat
lm(@formula(p ~ x + X), dat)

dat2 = dat[900:1999,:]
lm(@formula(p ~ x + X), dat2)


##################################
######### PRICE ##################

dat = DataFrame(p = mean(Float64.(ok2[:limitfull][2,:,1].-ok2[:limitfull][1,:,1])),
                X = var(Float64.(ok2[:limit][1,:,1])),
                x = mean([var(Float64.(ok2[:limitfull][1,Int.(ok2[:gid][:,1,1]) .== j,1])) for j in 1:100])
)

for i in 2:1999
    temp = DataFrame(p = mean(Float64.(ok2[:limitfull][i+1,:,1].-ok2[:limitfull][i,:,1])),
                X = var(Float64.(ok2[:limit][i,:,1])),
                x = mean([var(Float64.(ok2[:limitfull][i,Int.(ok2[:gid][:,1,1]) .== j,1])) for j in 1:100])    )
    append!(dat, temp)
end

dat.x = dat.x.-dat.X


plot(dat.x)
plot!(dat.X)
plot!(dat.p)

lm(@formula(p ~ x + X), dat)
dat2 = dat[ 1:999,:]
lm(@formula(p ~ x + X), dat2)





########################################
############ TEST ######################


dat = DataFrame(p = mean(Float64.(ok2[:limitfull][2,:,1].-ok2[:limitfull][1,:,1])),
                X = var(Float64.(ok2[:limit][1,:,1])),
                x = var(Float64.(ok2[:limitfull][1,:,1]))
)

for i in 2:1999
    temp = DataFrame(p = mean(Float64.(ok2[:limitfull][i+1,:,1].-ok2[:limitfull][i,:,1])),
                X = var(Float64.(ok2[:limit][i,:,1])),
                x = var(Float64.(ok2[:limitfull][i,:,1]) ))
    append!(dat, temp)
end

#Contextual
lm(@formula(p ~ x + X), dat)
dat2 = dat[900:1999,:]
lm(@formula(p ~ x + X), dat)

# Price 
dat.x = dat.x-dat.X
lm(@formula(p ~ x + X), dat)
dat2 = dat[900:1999,:]
lm(@formula(p ~ x + X), dat)


plot(dat.x)
plot!(dat.X)
plot!(dat.p)













dat1 = dat[1:500,:]
lm(@formula(p ~ x + X), dat1)

dat2 = dat[2000:2999,:]
lm(@formula(p ~ x + X), dat2)



################################
############# BORDERS ###########



Inv_coefs = []
G_coefs = []
S_coefs = []
for i in 1:3000
    dat = DataFrame(Y = Float64.(ok2[:payoffRfull][i,:,1]),
                    X = Float64.(ok2[:punish][i,Int.(ok2[:gid][:,1,1]),1]),
                    x = Float64.(ok2[:punishfull][i,:,1]),
                    S = Float64.(ok2[:stock][i,Int.(ok2[:gid][:,1,1]),1]))
    a=lm(@formula(Y ~ x + X  ), dat)
    push!(G_coefs, coef(a)[3])
    push!(Inv_coefs, coef(a)[2])
  #  push!(S_coefs, coef(a)[4])
end


plot(Inv_coefs)
plot!(G_coefs)
hline!([0,0])
#######################
########## PRICE ######

using GLM
using Plots
Inv_coefs = []
G_coefs = []
for i in 1:3000
    dat = DataFrame(Y = Float64.(ok2[:payoffRfull][i,:,1]),
                    X = Float64.(ok2[:punish][i,Int.(ok2[:gid][:,1,1]),1]),
                    x = Float64.(ok2[:punishfull][i,:,1]))
    dat.x = dat.x .-dat.X
    a=lm(@formula(Y ~ x + X), dat)
    push!(G_coefs, coef(a)[3])
    push!(Inv_coefs, coef(a)[2])
end

plot(Inv_coefs)
plot!(G_coefs)
hline!([0,0])


plot(Inv_coefs[1:100])
plot!(G_coefs[1:100])

##########################################
########### CONTEXTUAL SELECTION #########
dat = DataFrame(p = mean(Float64.(ok2[:punishfull][2,:,1].-ok2[:punishfull][1,:,1])),
                X = var(Float64.(ok2[:punish][1,:,1])),
                x = mean([var(Float64.(ok2[:punishfull][1,Int.(ok2[:gid][:,1,1]) .== j,1])) for j in 1:100])
)

for i in 2:2999
    temp = DataFrame(p = mean(Float64.(ok2[:punishfull][i+1,:,1].-ok2[:punishfull][i,:,1])),
                X = var(Float64.(ok2[:punish][i,:,1])),
                x = mean([var(Float64.(ok2[:punishfull][i,Int.(ok2[:gid][:,1,1]) .== j,1])) for j in 1:100])    )

    append!(dat, temp)
end


plot(dat.x)
plot!(dat.X)
plot!(dat.p)

dat = dat
lm(@formula(p ~ x + X), dat)

dat2 = dat[2000:2500,:]
lm(@formula(p ~ x + X), dat2)


##################################
######### PRICE ##################

dat = DataFrame(p = mean(Float64.(ok2[:punishfull][1+1,:,1].-ok2[:punishfull][1,:,1])),
                X = var(Float64.(ok2[:punish][1,:,1])),
                x = mean([var(Float64.(ok2[:punishfull][1,Int.(ok2[:gid][:,1,1]) .== j,1])) for j in 1:100])
)

for i in 2:2999
    temp = DataFrame(p = mean(Float64.(ok2[:punishfull][i+1,:,1].-ok2[:punishfull][i,:,1])),
                X = var(Float64.(ok2[:punish][i,:,1])),
                x = mean([var(Float64.(ok2[:punishfull][i,Int.(ok2[:gid][:,1,1]) .== j,1])) for j in 1:100])    )
    append!(dat, temp)
end

dat.x = dat.x.-dat.X

dat2 = dat[2000:2500,:]
lm(@formula(p ~ x + X), dat2)


plot(dat.x)
plot!(dat.X)
plot!(dat.p)

lm(@formula(p ~ x + X), dat)


















ngroups = 30
ntemp = 10
a= cpr_abm(degrade =  1, n=ntemp*ngroups, ngroups = ngroups, lattice = [5,6], labor = 1, inspect_timing = "before", 
    max_forest = 1333*ntemp*ngroups, tech = .000012, wages = 1, price = 3, nrounds = 2500, leak = true,
    learn_group_policy =false, invasion = true, nsim = 1, travel_cost = .01, seized_on = false, regrow =.025,
    experiment_group = collect(1:15), control_learning = false, back_leak = true, outgroup = .1, experiment_punish1 = 1,
    full_save = true, genetic_evolution = false, #glearn_strat = "income", 
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))

ngroups = 1000
ntemp = 3
b= cpr_abm(degrade = 1, n=ntemp*ngroups, ngroups = ngroups, lattice = [100,10], labor = 1, inspect_timing = "before", 
    max_forest = 1333*ntemp*ngroups, tech = .00004, wages = 1, price = 3, nrounds = 1000, leak = false, groups_sampled = 3,
    learn_group_policy =false, invasion = true, nsim = 1, travel_cost = .01, seized_on = true, regrow =.01,
    control_learning = false, back_leak = true, outgroup = .06, nmodels = 2,
    full_save = true, genetic_evolution = false,
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))

plot(b[:stock][:,:,1], label = "")
plot(b[:punish][:,:,1])
plot(b[:payoffR][:,:,1], label = "")
plot(b[:limit][:,:,1], label = "")
plot(b[:punish2][:,:,1], label = "")



c= cpr_abm(degrade = 1, n=ntemp*ngroups, ngroups = ngroups, lattice = [1,30], labor = 1, inspect_timing = "before", 
    max_forest = 1333*ntemp*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 2500, leak = false, groups_sampled = 2,
    learn_group_policy =false, invasion = true, nsim = 1, travel_cost = .01, seized_on = false, regrow =.025,
    experiment_group = collect(1:2:30), experiment_effort = 1, control_learning = false, back_leak = true, outgroup = .1, experiment_punish1 = 0,
    full_save = true, genetic_evolution = false, #glearn_strat = "income", 
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))



plot(a[:stock][:,:,1])
plot(b[:punish][:,:,1])
plot(b[:leakage][:,:,1])


plot!(c[:stock][:,:,1])
plot!(c[:effort][:,:,1])
plot(b[:leakage][:,:,1])

b[:loc]
plot(b[:harvest][:,:,1])
plot(b[:payoffR][:,1:2:30,1], ylim = (0, 50), label = "")
plot!(b[:payoffR][:,2:2:30,1], ylim = (0, 50), label = "")
plot(mean(a[:payoffR][:,1:15,1],dims =2) .-mean(a[:payoffR][:,16:30,1],dims =2), ylim = (-5, 5), label = "")
hline!([0,0])


plot!(mean(a[:payoffR][:,16:30,1],dims =2), ylim = (0, 28), label = "")


plot(a[:limit][:,:,1])

plot(a[:punish][:,:,1])
plot(a[:punish2][:,:,1])
plot((a[:punish][:,:,1]).-(a[:leakage][:,:,1]))