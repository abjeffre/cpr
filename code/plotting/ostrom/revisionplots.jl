using Plots.PlotMeasures

out = []
ngroups =2
for i in 0.5:.5:15
    c = cpr_abm(degrade = 1, n=100*ngroups, ngroups = ngroups, lattice = [1,2],
        max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 1000, leak = false,
        limit_seed = [0,3], learn_group_policy =false, invasion = false, nsim = 1, experiment_punish2 =1, experiment_limit = i,
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
max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 10000, leak = false,
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
    out=load("Y:/eco_andrews/Projects/CPR/data/stock_$k.jld2")
    dat = out["dat"]
    p1=plot(dat[1][1:10:10000,:,1], label = "", c = :black, alpha = .01)
    for i in 2:60 plot!(dat[i][1:10:10000,:,1], label = "", c = :black, alpha = .01) end
    p1
    a1=[mean(Float64.(dat[i][9900:end,:,1])) for i in 1:60]
    push!(ms, mean(a1))
end

plot(ms)