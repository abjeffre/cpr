#################################################################################
############# Optimal sustainable yeild and Non-cooperative solutions ###########

# This code calculates the optimal sustainable yeild and the non-cooperative solution for diffrent price-wage Combinations
# These values can then be used to find parameter spaces where the OSY and the NCS are drastically diffrent from each other. 
# Using this diffrence we can then evaluate the probability that management insitutions will emerge.


cd("C:\\Users\\jeffr\\Documents\\Work\\")

@everywhere include("C:\\Users\\jeffr\\Documents\\Work\\cpr\\code\\abm\\abm_invpun.jl")
@everywhere include("C:\\Users\\jeffr\\Documents\\Work\\functions\\utility.jl")


#######################################################################
############### VARYING PRICE AND WAGE ################################
@everywhere L = expand_grid(
                       10 .^(collect(range(-3, stop = 1, length = 10))),#wage 
                       10 .^(collect(range(-3, stop = 1, length = 10)))# Price
       )


osy=[]
osyp=[]
for i in 1:size(L)[1]
    S=collect(0.0:0.02:1.0)
    W=fill(L[i,1], length(S))
    P=fill(L[i,2], length(S))
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    @everywhere function test(S, W, P)
        cpr_abm(n = 30, ngroups = 2, lattice = (1,2), max_forest = 1400*30, regrow = 0.025,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = W, price = P, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = S, compress_data = false)
    end
    msy=pmap(test, S, W, P)
    a=[msy[q][:payoffR][700:end,1,1] for q in 1:length(msy)]
    j=findmax(a)[2]
    push!(osyp, mean(findmax(a)[1]))
    push!(osy, msy[j][:harvest][end,1,1])
    println(i)
end
@JLD2.save("osy.jld2", osy, osyp, L) 
 
################ GET NON-COOPERATIVE SOLUTION ####
@everywhere function g(W,P)
    cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 1400*300, regrow = 0.025,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = W, price = P, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, compress_data = false)
end
ncs=pmap(g, L[:,1], L[:,2]) 
ncsh=[mean(ncs[i][:payoffR][700:end,1,1]) for i in 1:length(ncs)]

@JLD2.save("cpr\\data\\abm\\ncs.jld2", ncs, L)
@JLD2.load("cpr\\data\\abm\\osy.jld2")

########## FIND WHERE THE DIFFRENCE IS THE LARGEST
diff = findmax(osyp./ncsh)
par=L[diff[2],:]
lim=osy[diff[2]]

nc=cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 1400*300, regrow = 0.025,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = par[1], price = par[2], fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true)

plot(nc[:effort][:,:,1], ylim = (0, 1))
plot(nc[:stock][:,:,1], ylim = (0, 1))
plot(nc[:harvest][:,:,1], ylim = (0, 20))
plot(nc[:payoffR][:,:,1], ylim = (0, .2))

osy1 = cpr_abm(n = 300, ngroups = 2, lattice = (2,1), max_forest = 1400*300, regrow = 0.025,
leak = false, pun1_on = false, pun2_on = true, learn_type = "income", mortality_rate = 0.01,
wages = par[1], price = par[2], fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_limit = lim, experiment_punish2 = 1, experiment_group = [1,2], punish_cost = 0)

plot(osy1[:effort][:,:,1], ylim = (0, 1))
plot(osy1[:stock][:,:,1], ylim = (0, 1))
plot(osy1[:harvest][:,:,1], ylim = (0, 20))
plot(osy1[:payoffR][:,:,1], ylim = (0, .07))

# Check Evolveability

evolve = cpr_abm(n = 300, ngroups = 2, lattice = (2,1), max_forest = 1400*300, regrow = 0.025,
leak = false, pun1_on = false, pun2_on = true, learn_type = "income", mortality_rate = 0.01,
wages = par[1], price = par[2], fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, harvest_limit = lim, punish_cost = 0.00)

plot(evolve[:effort][:,:,1], ylim = (0, 1))
plot(evolve[:stock][:,:,1], ylim = (0, 1))
plot(evolve[:harvest][:,:,1], ylim = (0, 20))
plot(evolve[:payoffR][:,:,1], ylim = (0, .2))
plot(evolve[:punish2][:,:,1], ylim = (0, 1))

#check CMLS
evolve2 = cpr_abm(n = 150*36, ngroups = 36, lattice = (6,6), max_forest = 1400*(150*36), regrow = 0.025,
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, harvest_var_ind=.5, harvest_var=2,
wages = par[1], price = par[2], fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, full_save = true,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, harvest_limit = lim+1, punish_cost = 0.00001, outgroup = .02, travel_cost = 0.00001, glearn_strat = "income") 

plot(evolve2[:effort][:,:,1], ylim = (0, 1), label = false)
plot(evolve2[:stock][:,:,1], ylim = (0, 1), label = false, ylab = "trees")
plot(evolve2[:harvest][:,:,1], ylim = (0, 20), label = false)
plot(evolve2[:payoffR][:,:,1], ylim = (0, .07), label = false)
plot(evolve2[:punish2][:,:,1], ylim = (0, 1), label = false)
plot(evolve2[:limit][1:end,:,1], ylim = (0, 15), label = false)
hline!([lim], lw =3, c=:red)
plot(evolve2[:leakage][:,:,1], ylim = (0, 1), label = false)
plot(evolve2[:punish][:,:,1], ylim = (0, 1), label = false)


plot(bad[:effort][:,:,1], ylim = (0, 1))
plot(bad[:stock][:,:,1], ylim = (0, 1))
plot(bad[:harvest][:,:,1], ylim = (0, 20))
plot(bad[:payoffR][:,:,1], ylim = (0, 0.1))
plot(bad[:punish2][:,:,1], ylim = (0, 1))


########## FIND WHERE THE DIFFRENCE IS THE LARGEST
diff = findmin(osyp./ncsh)
par=L[diff[2],:]
lim=osy[diff[2]]

nc=cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 1400*300, regrow = 0.025,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = par[1], price = par[2], fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true)

plot(nc[:effort][:,:,1], ylim = (0, 1))
plot(nc[:stock][:,:,1], ylim = (0, 1))
plot(nc[:harvest][:,:,1], ylim = (0, 20))
plot(nc[:payoffR][:,:,1], ylim = (0, .2))

osy1 = cpr_abm(n = 300, ngroups = 2, lattice = (2,1), max_forest = 1400*300, regrow = 0.025,
leak = false, pun1_on = false, pun2_on = true, learn_type = "income", mortality_rate = 0.01,
wages = par[1], price = par[2], fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_limit = lim, experiment_punish2 = 1, experiment_group = [1,2], punish_cost = 0)

plot(osy1[:effort][:,:,1], ylim = (0, 1))
plot(osy1[:stock][:,:,1], ylim = (0, 1))
plot(osy1[:harvest][:,:,1], ylim = (0, 20))
plot(osy1[:payoffR][:,:,1], ylim = (0, .07))

# Check Evolveability

evolve = cpr_abm(n = 300, ngroups = 2, lattice = (2,1), max_forest = 1400*300, regrow = 0.025,
leak = false, pun1_on = false, pun2_on = true, learn_type = "income", mortality_rate = 0.01,
wages = par[1], price = par[2], fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, harvest_limit = lim, punish_cost = 0.00)

plot(evolve[:effort][:,:,1], ylim = (0, 1))
plot(evolve[:stock][:,:,1], ylim = (0, 1))
plot(evolve[:harvest][:,:,1], ylim = (0, 20))
plot(evolve[:payoffR][:,:,1], ylim = (0, .2))
plot(evolve[:punish2][:,:,1], ylim = (0, 1))

#check CMLS
evolve2 = cpr_abm(n = 150*36, ngroups = 36, lattice = (6,6), max_forest = 1400*(150*36), regrow = 0.025,
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, harvest_var_ind=.5, harvest_var=2,
wages = par[1], price = par[2], fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, full_save = true,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, harvest_limit = lim+1, punish_cost = 0.00001, outgroup = .02, travel_cost = 0.00001, glearn_strat = "income") 

plot(evolve2[:effort][:,:,1], ylim = (0, 1), label = false)
plot(evolve2[:stock][:,:,1], ylim = (0, 1), label = false, ylab = "trees")
plot(evolve2[:harvest][:,:,1], ylim = (0, 20), label = false)
plot(evolve2[:payoffR][:,:,1], ylim = (0, .07), label = false)
plot(evolve2[:punish2][:,:,1], ylim = (0, 1), label = false)
plot(evolve2[:limit][1:end,:,1], ylim = (0, 15), label = false)
hline!([lim], lw =3, c=:red)
plot(evolve2[:leakage][:,:,1], ylim = (0, 1), label = false)
plot(evolve2[:punish][:,:,1], ylim = (0, 1), label = false)




########################################################################
##################### ADJUSTING REGROWTH RATES #########################
osy1=[]
osyp1=[]
    for i in 1:size(L)[1]
        S=collect(0.0:0.01:1.0)
        W=fill(L[i,1], length(S))
        P=fill(L[i,2], length(S))
        # set up a smaller call function that allows for only a sub-set of pars to be manipulated
        @everywhere function test(S,W,P)
            cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 1400*300, regrow = 0.01,
            leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
            wages = W, price = P, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
            nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = S, compress_data = false)
        end
        msy=pmap(test, S, W, P)
        a=[msy[q][:payoffR][700:end,1,1] for q in 1:length(msy)]
        j=findmax(a)[2]
        push!(osyp1, findmax(a)[1])
        push!(osy1, msy[j][:harvest][end,1,1])
    end
@JLD2.save("osy1.jld2", osy1, osyp1, L) 
 
################ GET NON-COOPERATIVE SOLUTION ####
@everywhere function g(W,P)
    cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 1400*300, regrow = 0.01,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = W, price = P, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, compress_data = false)
end
ncs1=pmap(g, L[:,1], L[:,2]) 
ncsh1=[mean(ncs1[i][:payoffR][700:end,1,1]) for i in 1:length(ncs)]

@JLD2.save("cpr\\data\\abm\\ncs1.jld2", ncs1, L)
@JLD2.load("cpr\\data\\abm\\osy1.jld2")




diff = findmax(osyp./ncsh)
par=L[diff[2],:]
lim=osy[diff[2]]
















S =expand_grid( [150*9],         #Population Size
[9],            #ngroups
[[3, 3]],        #lattice, will be replaced below
[.0001],         #travel cost
[1],             #tech
[.7],            #labor
[1.5],             #limit seed values
10 .^(collect(range(-5, stop =1, length = 6))),       #Punish Cost
[210000*9],      #max forest
[0.0001,.9],     #experiment leakage
[0.5],           #experiment punish
[1],             #experiment_group
[3],             #groups_sampled
[1],             #Defensibility
[0],             #var forest
10 .^(collect(range(-3, stop = 1, length = 20))),          #price
[.025],          #regrowth
[[1, 1]],        #degrade
10 .^(collect(range(-3, stop = 1, length = 20))),       #wages,
[.5] # outgroup punishment experiment 
)

@JLD2.load("cpr\\data\\abm\\osy.jld2")
new = zeros(size(S)[1])
for i in 1:size(S)[1]
    println(i)
    price = findall(x->x ≈ S[i, 16], L[:,2])
    wage = findall(x->x ≈ S[i, 19], L[:,1])
    tinds=findall.(x->x ∈ wage, price)
    inds=price[findall(x->x == [1], tinds)] 
    new[i] = convert.(Float64, osy[inds][1])
end
S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,20] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,7]= new




