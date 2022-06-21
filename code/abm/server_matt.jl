##############################################################################
#################### GET FULL OSY FOR PARAMETER SWEEPS #######################


#cd("C:\\Users\\jeffr\\Documents\\Work\\")

# @everywhere include("C:\\Users\\jeffr\\Documents\\Work\\cpr\\code\\abm\\abm_group_policy.jl")
# @everywhere include("C:\\Users\\jeffr\\Documents\\Work\\functions\\utility.jl")
@everywhere include("cpr\\code\\abm\\abm_group_policy.jl")
@everywhere include("functions\\utility.jl")
#######################################################################
############### VARYING PRICE AND WAGE ################################
@everywhere L = expand_grid(
                       10 .^(collect(range(-3, stop = 1, length = 10))),#wage 
                       10 .^(collect(range(-3, stop = 1, length = 10))),
                       (collect(range(500, stop = 3000, length = 10)))# FOREST SIZE
       )


osy=[]
osyp=[]
for i in 1:size(L)[1]
    S=collect(0.001:0.02:1.0)
    W=fill(L[i,1], length(S))
    P=fill(L[i,2], length(S))
    F=fill(L[i,3], length(S))
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    @everywhere function test(S, W, P, F)
        cpr_abm(n = 30, ngroups = 2, lattice = (1,2), max_forest = F*30, regrow = 0.025,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = W, price = P, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = S, compress_data = false)
    end
    msy=pmap(test, S, W, P, F)
    a=[mean(msy[q][:payoffR][700:end,1,1]) for q in 1:length(msy)]
    j=findmax(a)[2]
    push!(osyp, mean(findmax(a)[1]))
    push!(osy, msy[j][:harvest][end,1,1])
    println(i)
end
@JLD2.save("osyMatt.jld2", osy, osyp, L) 
 

##############################################################################
############# NEW MULTI FULL WITH PROPER OSY #################################


S =expand_grid( [150*9],         #Population Size
[9],            #ngroups
[[3, 3]],        #lattice, will be replaced below
[.0001],         #travel cost
[1],             #tech
[.7],            #labor
[1.5],             #limit seed values
10 .^(collect(range(-5, stop =1, length = 6))),       #Punish Cost
(collect(range(500, stop = 3000, length = 10))),      #max forest
[0.0001,.9],     #experiment leakage
[0.5],           #experiment punish
[1],             #experiment_group
[3],             #groups_sampled
[1],             #Defensibility
[0],             #var forest
10 .^(collect(range(-3, stop = 1, length = 10))),          #price
[.025],          #regrowth
[[1, 1]],        #degrade
10 .^(collect(range(-3, stop = 1, length = 10))),       #wages,
[.5] # outgroup punishment experiment 
)

@JLD2.load("cpr\\data\\abm\\osyMatt.jld2")
new = zeros(size(S)[1])
for i in 1:size(S)[1]
    price = findall(x->x ≈ S[i, 16], L[:,2])
    wage = findall(x->x ≈ S[i, 19], L[:,1])
    forest = findall(x->x ≈ S[i, 9], L[:,3])
    tinds=price[findall.(x->x ∈ wage, Ref(price))]
    inds=tinds[findall(x->x ∈ forest, tinds)] 
    new[i] = convert.(Float64, osy[inds][1])
end
S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,20] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,7]= new



# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 1,
            fines1_on = false,
            fines2_on = false,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            full_save = true,
            control_learning = false,
            experiment_limit = ls,
            harvest_var = 1,
            experiment_effort = 1,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            max_forest = mf*9*150,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_punish2 = ep,
            experiment_group = eg,
            groups_sampled =gs,
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg
            )
end


S = S[1:3, :]

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])
 
 @JLD2.save("abmDatFullosy.jld2", abm_dat, S)


#############################################
############ TESTING ##########################

S=collect(0.0:0.02:1.0)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function test(S)
        cpr_abm(n = 30, ngroups = 2, lattice = (1,2), max_forest = (180000/150)*30, regrow = 0.025,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = 0.007742636826811269, price = 0.0027825594022071257, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = S, compress_data = false)
    end
msy=pmap(test, S)
a=[mean(msy[q][:payoffR][700:end,1,1]) for q in 1:length(msy)]
j=findmax(a)[2]
mean(msy[j][:harvest][700:end, 1, 1])





# set up a smaller call function that allows for only a sub-set of pars to be manipulated
f1=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5, nrounds = 1000,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.01, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)

f2=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5, nrounds = 1000,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.9, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)


f3=cpr_abm(n = 150*9, max_forest = 9*410000, ngroups =9, nsim = 5, nrounds = 1000,
    lattice = [3,3], harvest_limit = 16.168, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.01, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)

f4=cpr_abm(n = 150*9, max_forest = 9*410000, ngroups =9, nsim = 5, nrounds = 1000,
    lattice = [3,3], harvest_limit = 16.168, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.9, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)


f5=cpr_abm(n = 150*9, max_forest = 9*180000, ngroups =9, nsim = 5, nrounds = 1000,
    lattice = [3,3], harvest_limit = 6.94, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.01, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)



f6=cpr_abm(n = 150*9, max_forest = 9*180000, ngroups =9, nsim = 5, nrounds = 1000,
    lattice = [3,3], harvest_limit = 6.94, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.9, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)


f7=cpr_abm(n = 150*9, max_forest = 9*510000, ngroups =9, nsim = 5, nrounds = 1000,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.9, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)


f8=cpr_abm(n = 150*9, max_forest = 9*510000, ngroups =9, nsim = 1, nrounds = 1000,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun2_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.01, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)
##################################################################
############# PREDICTIONS #########################################

a=cpr_abm(n = 150*9, max_forest = 9*410000, ngroups =9, nsim = 1, nrounds = 1000,
    lattice = [3,3], harvest_limit = 16.168, regrow = .025, pun1_on = false, pun2_on = false, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.01, experiment_effort =1,
    travel_cost = 0.003,experiment_group = [1], back_leak = true, control_learning = false, full_save = true, 
    learn_group_policy = true)


plot(a[:stock][:,:,1])


plot(mean(mean(f1[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f2[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))

a=scatter(mean(mean(f1[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f1[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2), ylim = (0, 1), ylab =" Support for Regulate", label = "Low leak")
scatter!(mean(mean(f2[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f2[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = "High leak")

b=scatter(mean(mean(f3[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f3[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2), xlab = "resource stock level", ylim = (0, 1), label = false)
scatter!(mean(mean(f4[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f4[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = false)

c=scatter(mean(mean(f5[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f5[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2), ylim = (0, 1), label = false)
scatter!(mean(mean(f6[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f6[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = false)

stockPunish=plot(c, a, b, layout = grid(3,1))


a=scatter(mean(mean(f1[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f1[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2), ylim = (0, 1), label = "Low leak")
scatter!(mean(mean(f2[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f2[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = "High leak")

b=scatter(mean(mean(f3[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f3[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2), ylim = (0, 1), label = false)
scatter!(mean(mean(f4[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f4[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = false)

c=scatter(mean(mean(f5[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f5[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2), ylim = (0, 1), label = false)
scatter!(mean(mean(f6[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f6[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = false)

stockPunish=plot(c, a, b, layout = grid(3,1))


a=scatter(mean(mean(f1[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f1[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = "Low leak")
scatter!(mean(mean(f2[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f2[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = "High leak")

b=scatter(mean(mean(f3[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f3[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = false)
scatter!(mean(mean(f4[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f4[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = false)

c=scatter(mean(mean(f5[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f5[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = false)
scatter!(mean(mean(f6[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f6[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2), label = false)

stockregulate=plot(c, a, b, layout = grid(3,1))









plot!(mean(mean(f1[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f2[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))

plot(mean(mean(f3[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f4[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f3[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f4[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(a[:stock][:,:,1])

plot(mean(mean(f3[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f4[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f5[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f6[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f7[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f8[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
##################################################################
############### PREDICTIONS 2 ####################################

plot(mean(mean(f1[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f2[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f3[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f4[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f5[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f6[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))


##################################################################
############### LIMIT 2 ##########################################

plot(mean(mean(f1[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f2[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f3[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f4[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f5[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f6[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))

plot(mean(mean(f1[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f2[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f3[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f4[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f5[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f6[:stock][:,2:9,:], dims = 3)[:,:,1], dims = 2))



plot(mean(mean(f1[:payoffR][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f2[:payoffR][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f3[:payoffR][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f4[:payoffR][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(f5[:payoffR][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f6[:payoffR][:,2:9,:], dims = 3)[:,:,1], dims = 2))




plot(mean(mean(f1[:leakage][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f2[:leakage][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f3[:leakage][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f4[:leakage][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f5[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(f6[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))



##################################################################
################### REGROWTH RATES ###############################


# set up a smaller call function that allows for only a sub-set of pars to be manipulated
t1=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.01, experiment_effort =1,
    travel_cost = 0,experiment_group = [1], back_leak = true, control_learning = false, full_save = true,
     learn_group_policy = true)

t2=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.9, experiment_effort =1,
    travel_cost = 0,experiment_group = [1], back_leak = true, control_learning = false, full_save = true,
    learn_group_policy = true)


t3=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.01, experiment_effort =1,
    travel_cost = 0,experiment_group = [1], back_leak = true, control_learning = false, full_save = true,
    learn_group_policy = true)

t4=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5,
    lattice = [3,3], harvest_limit = 8.259, regrow = .035, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.9, experiment_effort =1,
    travel_cost = 0,experiment_group = [1], back_leak = true, control_learning = false, full_save = true,
    learn_group_policy = true)


t5=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5,
    lattice = [3,3], harvest_limit = 8.259, regrow = .015, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.01, experiment_effort =1,
    travel_cost = 0,experiment_group = [1], back_leak = true, control_learning = false, full_save = true,
    learn_group_policy = true)

t6=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5,
    lattice = [3,3], harvest_limit = 8.259, regrow = .015, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_leak = 0.9, experiment_effort =1,
    travel_cost = 0,experiment_group = [1], back_leak = true, control_learning = false, full_save = true,
    learn_group_policy = true)





##################################################################
############# PREDICTIONS #########################################

plot(mean(mean(t1[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t2[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(t3[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t4[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(t5[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t6[:punish2][:,2:9,:], dims = 3)[:,:,1], dims = 2))

##################################################################
############### PREDICTIONS 2 ####################################

plot(mean(mean(t1[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t2[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(t3[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t4[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(t5[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t6[:punish][:,2:9,:], dims = 3)[:,:,1], dims = 2))


##################################################################
############## PREDICTIONS LIMITS ################################

plot(mean(mean(t1[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t2[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(t3[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t4[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot(mean(mean(t5[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))
plot!(mean(mean(t6[:limit][:,2:9,:], dims = 3)[:,:,1], dims = 2))

#@JLD2.save("brute2.jld2", dat)

plot(t1[:stock][:,2:9,1], lear)





# set up a smaller call function that allows for only a sub-set of pars to be manipulated
t1=cpr_abm(n = 150*2, max_forest = 2*210000, ngroups =2, nsim = 5,
    lattice = [2,1], harvest_limit = 9.259, regrow = .025, pun1_on = true, wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00450525196229018395, labor = .7, zero = true, 
    travel_cost = 0,experiment_group = [1], full_save = true, learn_group_policy =true)

p1=scatter(mean(mean(t1[:leakage][:,1,:], dims = 3)[1:499,:,1], dims = 2).*mean(mean(t1[:harvest][1:499,1,:], dims = 3)[:,:,1], dims = 2), mean(mean(t1[:punish][2:500,2,:], dims = 3)[:,:,1], dims = 2), ylim = (0, 1), ylab =" Support for Borders", xlab = "Intensity of Roving Bandits")
a=mean(mean(t1[:stock][:,1:2,:], dims = 3)[:,:,1], dims = 2)
b=-[a[i].-a[i-1] for i in 2:500]
p2=scatter(b, mean(mean(t1[:punish][2:500,2,:], dims = 3)[:,:,1], dims = 2), ylim = (0, 1), ylab =" Support for borders", xlab = "Δ Stock", label = false)
p1=scatter(mean(mean(t1[:leakage][:,1,:], dims = 3)[1:499,:,1], dims = 2).*mean(mean(t1[:harvest][1:499,1,:], dims = 3)[:,:,1], dims = 2),
 mean(mean(t1[:limit][2:500,2,:], dims = 3)[:,:,1], dims = 2), ylim = (8, 11), ylab =" Support for Borders", xlab = "Intensity of Roving Bandits")
 plot(t1[:limit][:,1:2,3], ylim = (0,15), label = false)


function table(df, x)
    combine(groupby(df, Symbol(x)), nrow => :Freq) 
end 
m = zeros(500, 2, 5)
for j in 1:5
    for i in 1:500 
        df=DataFrame(A = t1[:loc][i,:,j][t1[:gid][:,j] .!=  t1[:loc][i,:,j]])
        a=table(df, :A)
        u=unique(a[:,1])
        for k in u
            ind=findall(x->x==k, a[:,1])
            m[i,Int(k),j]= a[ind,2][1]
        end
    end
end

y=vec(t1[:limitfull][:,:,1])

b = []
for i in 1:500
    a=m[i,:,1][Int.(t1[:gid][:,1])]
    push!(b, a)
end

x=reduce(vcat,b)

scatter(x, y)


scatter(t1[:limit][:,1,1], m[:,1,1])
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
f1=cpr_abm(n = 150*16, max_forest = 16*210000, ngroups =16, nsim = 5,
    lattice = [4,4], harvest_limit = 9.259, regrow = .025, pun1_on = true,
     wages = 0.007742636826811269,
     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00450525196229018395, labor = .7, zero = true, 
    travel_cost = 0,experiment_group = collect(1:16), back_leak = true, control_learning = true, 
    full_save = true, learn_group_policy = true, experiment_punish2 = 1)

 a=mean(mean(f1[:stock][:,1:9,:], dims = 3)[:,:,1], dims = 2)
 b=-[a[i].-a[i-1] for i in 2:500]
p3=scatter(b, mean(mean(f1[:limit][2:500,1:9,:], dims = 3)[:,:,1], dims = 2), ylim = (10, 11), ylab ="Maximum Allowable Harvest", label = false, xlab = "ΔStock")
p4=scatter(mean(mean(f1[:leakage][200:500,1:16,:], dims = 3)[:,:,1], dims = 2).*mean(mean(f1[:harvest][200:500,1:16,:], dims = 3)[:,:,1], dims = 2),
 mean(mean(f1[:limit][200:500,1:16,:], dims = 3)[:,:,1], dims = 2),  ylab ="Maximum Allowable Harvest", xlab = "Intensity of Roving Bandits", label = false)

p4=scatter(1:500, mean(mean(f1[:leakage][:,1:9,:], dims = 3)[:,:,1], dims = 2).*mean(mean(f1[:harvest][:,1:9,:], dims = 3)[:,:,1], dims = 2), ylab ="Time", xlab = "Intensity of Roving Bandits", label = false, xlim =(0, 500))
p4=scatter(mean(mean(f1[:leakage][:,1:9,:], dims = 3)[:,:,1], dims = 2).*mean(mean(f1[:harvest][:,1:9,:], dims = 3)[:,:,1], dims = 2), mean(mean(f1[:punish][:,1:9,:], dims = 3)[:,:,1], dims = 2), ylim = (0, 1), ylab ="Maximum Allowable Harvest", xlab = "Intensity of Roving Bandits", label = false, xlim =(2, 15))
plot(f1[:leakage][:,:,1], label = false)
plot(mean(mean(f1[:punish2][:,1:9,:], dims = 3)[:,:,1], dims = 2), ylim = (0,1))
plot(mean(mean(f1[:limit][:,1:9,:], dims = 3)[:,:,1], dims = 2), ylim = (0,25))
png(p1,"Documents/matt_pred_roving_border.png")
png(p2, "Documents/matt_stock_border.png")
png(p3, "Documents/matt_roving_limit.png")
png(p4, "Documents/matt_stock_limit.png")

