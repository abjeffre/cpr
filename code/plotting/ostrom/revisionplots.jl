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

##################################################################################################
########################### DEMONSTRATE THAT GROUP SELECTION DOES NOT SAVE GROUPS ################



###########################################################################################
################### DEMONSTRATE HOW THE FOLK THEORM SAVES GROUPS AND THE SYSTEM ###########

@everywhere function g(x)
    ngroups = 20
    cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [1,ngroups],
    max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 10000, leak = false,
    learn_group_policy =false, invasion = true, nsim = 1, 
    experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = x,
    full_save = true, genetic_evolution = false, #glearn_strat = "income",
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))
end

cnt = 1
for i in collect(0:.02:.20)
    S = fill(i, 20)
    out=pmap(g, S)
    save(string("m1_",cnt,".jld2"), "out", out)
    out = nothing
    cnt +=1
end

    



############################################################################################
#########################


@everywhere function g(x)
    ngroups = 20
    cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [1,ngroups],
    max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 10000, leak = false,
    learn_group_policy =false, invasion = true, nsim = 1, 
    experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = x,
    full_save = true, genetic_evolution = false, glearn_strat = "income",
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))
end

cnt = 1
for i in collect(0:.02:.20)
    S = fill(i, 20)
    out=pmap(g, S)
    save(string("C:/Users/jeffr/OneDrive/Documents/CPR/data/m2_",cnt,".jld2"), "out", out)
    out = nothing
    cnt +=1
end

    










S=collect(0:.02:.20)
out=pmap(g, S)
using JLD2
save("test.jld2", "S", S)
load("test.jld2")

sa
i=10
plot(plot(out[i][:stock][:,:,1], c = :black), plot(out[i][:limit][:,:,1], c = :black),
 plot(out[i][:payoffR][:,:,1], c = :black), layout=grid(1,3), label = "", size = (1000, 300))

out2 = []
for i in 0:.2:.20
    ngroups = 20
    test = cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [1,ngroups],
    max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 10000, leak = false,
    learn_group_policy =false, invasion = true, nsim = 10, 
    experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = i,
    full_save = true, genetic_evolution = false, glearn_strat = "income",
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))
    push!(test, out2)
end



p4=plot(test[:stock][:,:,1], label = "", xlab = "Time", ylab = "Resource Stock", c = :black, alpha = .5)
p5=plot(test[:limit][:,:,1], label = "", xlab = "Time", ylab = "Policy", c = :black, alpha = .5)
p6=plot(test[:payoffR][:,:,1], label = "", xlab = "Time", ylab = "Payoff", c = :black, alpha = .5)

plot(p4, p5, p6)


##############################################
########### WHY DOES THIS WORK ###############

# This works because agents parasitize those extracting resources. 