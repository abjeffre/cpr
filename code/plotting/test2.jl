
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")

###High LABOR ####
nmodels = 3
using Statistics
using Distributions
using Random
using Dates
using StatsFuns
using StatsBase
  nsim = 1                    # Number of simulations per call
  nrounds = 2000               # Number of rounds per generation
  n = 3000                     # Size of the population
  ngroups = 20                 # Number of Groups in the population
  lattice = (4, 5)             # This controls the dimensions of the lattice that the world exists on
  mortality_rate = 0.03      # The number of deaths per 100 people
  mutation = 0.01            # Rate of mutation on traits
  wages = .1                   # Wage rate in other sectors - opportunity costs
  wage_growth = false          # Do wages grow?
  wgrowth_rate =.0001          # this is a fun parameter we know that the average growth rate for preindustiral societies is 0.2% per year why not let wages grow and see what happens
  labor_market = false         # This controls labor market competition
  market_size = 1              # This controls the demand for labor in the population and is exogenous: Note that when set to 1 the wage rate equilibrates when half the population is in the labor force
  max_forest = 16500               # Average max stock
  var_forest = 1                   # Controls athe heterogeneity in forest size across diffrent groups
  degrade = [1, 1]                # This measures how degradable a resource is(when zero the resource declines linearly with size and as it increase it degrades more quickly if negative it decreases the rate of degredation) degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
  regrow = .01                     # the regrowth rate
  volatility = 0                 #the volatility of the resource each round - set as variance on a normal
  pollution = false
  pol_slope = .1                 # As the slope increases the rate at which pollution increases as the resource declines increase
  pol_C = .1                    # As the constant increases the total amount of polution increases
  ecosys = false
  eco_slope = 1                 # As the slope increases the resource will continue to produce ecosystem servies
  eco_C = .01                    # As the constant increases the total net benifit of the ecosystem services increases
  tech = 1                     # Used for scaling Cobb Douglas production function
  labor = .7                   # The elasticity of labor on harvesting production
  price = 1                    # This sets the price of the resource on the market
  necessity = 0                # This sets the minimum amount of the good the household requires
  inst = true                  # Toggles whether or not punishment is active
  monitor_tech = [1, 1]             # This controls the efficacy of monitnoring higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i 1 x) 0 5) where i is the proportion of monitors in a pop
  defensibility = 1            # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
  def_perc = true              # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
  punish_cost = 0.001           # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs
  fine = 0.0                   # This controls the size of the fine issued when caught note that in a real world situation this could be recouped by the injured parties but it is not
  self_policing = true         # Toggles if Punishers also target members of their own ingroup for harvesting over limit
  harvest_limit = 0.25         # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
  harvest_var = .07
  pun2_on = true
  pun1_on = true
  seized_on = true
  fines1_on = false
  fines2_on = false
  fine_start = .1               #Determine mean fine value for all populations at the beginiing SET TO NOHTING TO TURN OFF
  fine_var = .02                #Determines the group offset for fines at the begining
  distance_adj =0.9            # This affects the proboabilty of sampling a more close group.
  travel_cost = .00            # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
  groups_sampled = 3           # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes
  social_learning = true       # Toggels whether Presitge Biased Tranmission is on
  nmodels = 3                  # The number of models sampled to copy from in social learning
  fidelity = 0.02              # This is the fidelity of social transmission
  learn_type = "income"        # Two Options - "wealth" and "income" indiviudals can choose to copy wealth or income if copy wealth they copy total overall payoffs if copy income they copy payoffs from the previous round
  outgroup = 0.01              # This is the probability that the individual samples from the whole population and not just his group when updating0...
  baseline = .01                # Baseline payoff to be added each round -
  invade = true
  REDD = false                 # This controls whether or not the natural experiment REDD+ is on if REDD is on INST must be on
  REDD_dates = 300             # This can either be an int or vector of dates that development initative try and seed insitutions
  law = .1                     # This controls sustainable harvesting limit when REDD+ is introduced
  num_cofma = 1                # This controls the number of Groups that will be converted to CoFMA
  cofma_agents= nothing          # This allows you to choose the group id - specificy a spatial identity for the ward that becomes protected.
  leak = true                  # This controls whether individuals are able to move into neightboring territory to harvest
  verbose = false              # verbose reporting for debugging
  seed = 1984
  og_on = true                  # THe evolution of listening to outgroup members.
  experiment_leak = false              #THIS SETS THE VALUE OF THE OTHER GROUP LEAKAGE and Punish
  experiment_punish1 = false            #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_punish2 = false            #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_limit = false             #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_effort = false            #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_group = 1                 #determines the set of groups which the experiment will be run on
  cmls = false                          #determines whether cmls will operate
  zero = false
  power = false
  glearn_strat = false









test=    cpr_abm(
    ngroups = 15,
    n = 150*15,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*15,
    nrounds = 500,
    nsim =10,
    regrow = .01,
    labor = .7,
    lattice =[3,5],
    var_forest = 0,
    pun1_on = true,
    pun2_on =true,
    outgroup = 0.01,
    harvest_var = .14,
    defensibility = 1,
    seized_on = true,
    leak = true,
    zero = true,
    og_on = true,
    power = false,
    fines1_on = true,
    fines2_on = false,
    verbose = false,
    fine_start = 1,
    fine_var = .4,
    glearn_strat = "income",
    monitor_tech = [1,1],
    experiment_limit =.1,
    experiment_punish1 = 1,
    experiment_punish2 = 1,
    social_learning = true,

)

plot(test["stock"][:,2:15,1], legend =false)
plot(test["effort"][:,1,:], legend = true)
plot(test["effort"][:,:,1], legend = false)
plot(test["leakage"][:,1,:], legend = true)
plot(test["leakage"][:,:,1], legend = true)
plot(test["payoffR"][:,2:15,1], legend = false, alpha = .4)
plot(test["punish"][:,:,1], legend = true)
plot(test["fine1"][:,:,1], legend = true)
plot(test["limit"][:,:,1], legend = false)
plot(test["punish2"][:,:,1], legend = false)
plot(test["og"][:,:,1], legend = false)
plot(test["fine2"][:,:,1], legend = true)

test2=    cpr_abm(
    ngroups = 15,
    n = 150*15,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*15,
    nrounds = 500,
    nsim =10,
    regrow = .01,
    labor = .7,
    lattice =[3,5],
    var_forest = 0,
    pun1_on = true,
    pun2_on =true,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    seized_on = true,
    leak = true,
    zero = true,
    og_on = true,
    power = false,
    fines1_on = true,
    fines2_on = false,
    verbose = false,
    fine_start = 1,
    fine_var = .4,
    glearn_strat = false,
    monitor_tech = [1,1],
    experiment_limit =false,
    experiment_punish1 = false,
    experiment_punish2 = false
)


plot(test2["stock"][:,:,6], legend = true)
plot(test2["effort"][:,1,:], legend = true)
plot(test2["effort"][:,2,:], legend = true)
plot(test2["leakage"][:,1,:], legend = true)
plot(test2["leakage"][:,2,:], legend = true)
plot(test2["payoffR"][:,2,:], legend = true)
plot(test2["punish"][:,2,:], legend = true)
plot(test2["fine1"][:,1,:], legend = true)
plot(test2["limit"][:,:,1], legend = true)
plot(test2["punish2"][:,2,:], legend = true)
plot(test2["og"][:,:,1], legend = true)







test3=    cpr_abm(
    ngroups = 5,
    n = 150*15,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*15,
    nrounds = 1000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[1,5],
    var_forest = 0,
    pun1_on = true,
    pun2_on =true,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 150,
    def_perc = false,
    seized_on = true,
    leak = true,
    zero = true,
    og_on = true,
    power = "income",
    fines1_on = true,
    fines2_on = false,
    verbose = false,
    fine_start = .1,
    fine_var = .03,
    glearn_strat = "income",
    monitor_tech = [1,1],
    experiment_limit =false,
    experiment_punish1 = false,
    experiment_punish2 = false,
    cmls = false

)


plot(test3["stock"][:,:,1], legend = true)
plot(test3["effort"][:,1,:], legend = true)
plot(test3["effort"][:,2,:], legend = true)
plot(test3["leakage"][:,1,:], legend = true)
plot(test3["leakage"][:,2,:], legend = true)
plot(test3["payoffR"][:,2,:], legend = true)
plot(test3["punish"][:,2,:], legend = true)
plot(test3["fine2"][:,:,1], legend = true)
plot(test3["limit"][:,:,1], legend = true)
plot(test3["punish2"][:,2,:], legend = true)
plot(test3["og"][:,:,1], legend = true)
plot(test3["influence"][:,:,1], legend = true)











l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
q=findall(x->x==0.1, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]


low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2)-
    mean(low[i]["effort"][:,2,:], dims =2) )
    end


using Plots
gr()
p=heatmap( m,
    c=:thermal, axis = nothing
    )


for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) )
    end


using Plots
gr()
p=heatmap( m,
    c=:thermal, clim= (0, 1), axis = nothing
    )



l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x== 0.00, S[:,4])

l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["leakage"][:,16,:], dims =2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (0, 1)
    )



test1 =cpr_abm(ngroups = 2, n = 300, experiment_leak = false,
experiment_effort =false,
experiment_group =1, tech = 2, groups_sampled = 3, wages = .20,
price = .5,
max_forest=15000, nrounds = 1000, nsim =15, experiment_punish1 = false,
 regrow = .025,
labor = .7, lattice =[1,2],
var_forest = 0, pun1_on = false, pun2_on = true, outgroup = 0.01,
 harvest_var = .07, defensibility = 1,
seized_on = true, leak = false)

plot(test1["stock"][:,:,1], legend = false)
plot!(test1["stock"][:,:,2] , legend = false)
plot!(test1["stock"][:,:,3] , legend = false)
plot!(test1["stock"][:,:,4] , legend = false)
plot!(test1["stock"][:,:,5] , legend = false)
plot!(test1["stock"][:,:,6] , legend = false)
plot!(test1["stock"][:,:,7] , legend = false)
plot!(test1["stock"][:,:,8] , legend = false)
plot!(test1["stock"][:,:,9] , legend = false)
plot!(test1["stock"][:,:,10] , legend = false)
plot!(test1["stock"][:,:,11] , legend = false)
plot!(test1["stock"][:,:,12] , legend = false)
plot!(test1["stock"][:,:,13] , legend = false)
plot!(test1["stock"][:,:,14] , legend = false)



test2 =cpr_abm(ngroups = 5, n = 150*5, experiment_leak = false,
experiment_effort =false,
experiment_group =1, tech = 2, groups_sampled = 3, wages = .2,
price = 1,
max_forest=15000*2.5, nrounds = 1000, nsim =6, experiment_punish1 = false,
 regrow = .025,
labor = .7, lattice =[1,5],
var_forest = 0, pun1_on = false, pun2_on = true, outgroup = 0.01,
 harvest_var = .07, defensibility = 1,
seized_on = true, leak = false)


 plot(test2["stock"][:,:,1], legend = false)
 plot!(test2["stock"][:,:,2] , legend = false)
plot!(test2["stock"][:,:,3] , legend = false)
plot!(test2["stock"][:,:,4] , legend = false)
plot!(test2["stock"][:,:,5] , legend = false)
plot!(test2["stock"][:,:,6] , legend = false)



test =cpr_abm(
    ngroups = 10,
    n = 150*10,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*10,
    nrounds = 1000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[5,2],
    var_forest = 0,
    pun1_on = true,
    pun2_on =true,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 10,
    seized_on = true,
    leak = false,
    zero = true,
    og_on = true,
    power = false,
    fines1_on = true,
    fines2_on = true,
    verbose = false,
    fine_start = 1,
    fine_var = .2,
    group_learn = false,
    monitor_tech = [1,1]
)


S =expand_grid([false, true],                   #pun2_on
                [false, true],                  #seized
                [false, true],                  #leak
                [false, true],                  #zeros
                [false, true],                  #og
                ["wealth", "poor", false],      #power
                [false, true],                  #fine2
                [false, true],                  #group_learn
                ["wealth", "income"]            #glearn_strat
)



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(p1, s, l, z, p, f2, gl, gs)
    cpr_abm(
    ngroups = 10,
    n = 150*10,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*10,
    nrounds = 1000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[5,2],
    var_forest = 0,
    pun1_on = true,
    pun2_on =p1,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 10,
    seized_on = s,
    leak = l,
    zero = z,
    og_on = og,
    power = false,
    fines1_on = true,
    fines2_on = f2,
    verbose = false,
    fine_start = 1,
    fine_var = .2,
    group_learn = gl,
    glearn_strat = gs,
    monitor_tech = [1,1]
)
end



plot(test["stock"][:,:,1], legend = false, ylim=(0,1), color = :forestgreen)
plot!(test["effort"][:,:,1] , legend = false, color=:goldenrod, alpha =.1)
plot!(test["punish2"][:,:,1] , legend = false, color=:pink, alpha =.1)
plot!(test["payoffR"][:,:,1] , legend = false, color=:firebrick, alpha =.1)

# FOR WHEN YOU GET BACK = JUST ADDED OG

##
plot(test["roi"][:,:,1] , legend = false, color=:blue, alpha =.4)

plot(test["leakage"][:,:,1] , legend = false, color=:firebrick, alpha =.4)


plot(test["harvest"][:,:,1], legend = false, color=:purple, alpha =.6)
plot!(test["limit"][:,:,1] , legend = false, color=:orange, alpha =.6)
plot!(test["og"][:,:,1] , legend = false, color=:green, alpha =.4)


plot(test["fine1"][:,:,1] , legend = false, color=:blue, alpha =.4)
plot!(test["fine2"][:,:,1] , legend = false, color=:green3, alpha =.4)


test5 =cpr_abm(ngroups = 30, n = 150*30, experiment_leak = false,
experiment_effort =false,
experiment_group =1, tech = 2, groups_sampled = 3, wages = .2,
price = 1,
max_forest=15000*15, nrounds = 500, nsim =1, experiment_punish1 = false,
 regrow = .025,
labor = .7, lattice =[6,5],
var_forest = 0, pun1_on = false, pun2_on = true, outgroup = 0.01,
 harvest_var = .07, defensibility = 1,
seized_on = true, leak = false)

plot(test5["stock"][:,:,1], legend = false)





###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end
using Plots
gr()
 pl1=heatmap(m,
    c=:greenpink, clim= (-1, 1), xlab = "Wages", ylab= "Prices",
     yguidefontsize=9, xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["Low","High"])
    )

    title!(" ", titlefontsize = 9)




#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
pl2=heatmap(m,
    c=:greenpink, clim= (-1, 1), xlab = "Wages", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,
      xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
        title!(" ", titlefontsize = 9)




###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
pl3=heatmap( m,
    c=:greenpink, clim= (-1, 1), xlab = "Wages", ylab= "",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
    title!(" ", titlefontsize = 9)





###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["seized2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl1=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["seized2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["seized2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl3=heatmap(m,
    c=:thermal, clim= (0, 1)
    )



###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["seized2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph1=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["seized2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph2=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["seized2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph3=heatmap(m,
    c=:thermal, clim= (0, 1)
    )



plot(pl1, pl2, pl3, ph1, ph2, ph3)


print(keys(high[1]))

plot(layout=(2,2))
sp=1
 for i in 1:length(names)
    c = get(ColorSchemes.rainbow,i./length(names))
    plot!(subplot=sp,x,y[i,:],linewidth=2,label=names[i],color=c)
  end

  plot!(xlabel=L"\textrm{\sffamily Contact Distance Threshold / \AA}",subplot=sp)












  using Distributed
  @everywhere using(Distributions)
  @everywhere using(DataFrames)
  @everywhere using(JLD2)
  @everywhere using(Random)
  @everywhere using(Dates)

  @everywhere cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm")
  @everywhere include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\setup_utilies.jl")
  @everywhere include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_fine.jl")



  S =expand_grid( [300],           #Population Size
                  [2],             #ngroups
                  [[1, 2]],        #lattice, will be replaced below
                  [0.0001],        #travel cost
                  [1],             #tech
                  [.1,.5,.9],      #labor
                  [0.1],           #limit seed values
                  [.0015],         #Punish Cost
                  [15000],         #max forest
                  [0.001,.9],      #experiment leakage
                  [0.5],           #experiment punish
                  [1],             #experiment_group
                  [1],             #groups_sampled
                  [1],          #Defensibility
                  [1],             #var forest
                  10 .^(collect(range(-2, stop = 1, length = 20))),          #price
                  [.025],        #regrowth
                  [[1, 1]], #degrade
                  10 .^(collect(range(-4, stop = 0, length = 20)))       #wages
                  )

  #set up a smaller call function that allows for only a sub-set of pars to be manipulated
  @everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
      cpr_abm(nrounds = 500,
              nsim = 1,
              fine_start = nothing,
              leak = false,
              experiment_effort = 1,
              pun1_on = false,
              pun2_on = true,
              n = n,
              ngroups = ng,
              lattice = l,
              travel_cost = tc,
              tech = te,
              labor = la,
              harvest_limit = ls,
              punish_cost = pc,
              max_forest = mf,
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


  abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
   S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
   S[:,16], S[:,17], S[:,18], S[:,19])

  @JLD2.save("test", abm_dat, S)

p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, 3)

elast=[.1, .5, .9]
for j in 1:length(elast)

        l=findall(x->x==0.001, S[:,10])
        h=findall(x->x==0.9, S[:,10])
        #Choose Labor Elasticity
        q=findall(x->x==elast[j], S[:,6])
        v=findall(x->x==1, S[:,14])
        l=l[l.∈ Ref(q)]
        l=l[l.∈ Ref(v)]
        h=h[h.∈ Ref(q)]
        h=h[h.∈ Ref(v)]
        low = abm_dat[l]
        high =abm_dat[h]
        m = zeros(10,10)

        for i = 1:length(high)
            m[i]  = nanmean(mean(low[i]["cel"][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
            end
        using Plots
        gr()
         p_arr[j]=p1=heatmap(m,
            c=:thermal, clim= (-1, 1), xlab = "", ylab= "Prices",
             yguidefontsize=9,  xguidefontsize=9, legend = false,
               xticks = ([2,0],["",""]), yticks = ([2,9],["Low","High"])
            )
        title!(string("Labor = ", elast[j]), titlefontsize = 9)

end
ps = [p_arr[1] p_arr[2] p_arr[3]]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta Cor[E, L]", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly


plot(eff, size = (1000, 400))


for j in 1:length(elast)

        l=findall(x->x==0.001, S[:,10])
        h=findall(x->x==0.9, S[:,10])
        #Choose Labor Elasticity
        q=findall(x->x==elast[j], S[:,6])
        v=findall(x->x==1, S[:,14])
        l=l[l.∈ Ref(q)]
        l=l[l.∈ Ref(v)]
        h=h[h.∈ Ref(q)]
        h=h[h.∈ Ref(v)]
        low = abm_dat[l]
        high =abm_dat[h]
        m = zeros(10,10)
        for i = 1:length(high)
        m[i]  = nanmean(mean(low[i]["clp2"][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
            end
        using Plots
        gr()
         p_arr[j]=p1=heatmap(m,
            c=:thermal, clim= (-1, 1), xlab = "", ylab= "Prices",
             yguidefontsize=9,  xguidefontsize=9, legend = false,
               xticks = ([2,19],["",""]), yticks = ([2,19],["Low","High"])
            )
        title!("Labor = 0.1", titlefontsize = 9)

end

ps = [p_arr[1] p_arr[2] p_arr[3]]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(0:0.1:1)), title ="\\Delta Cor[E, R]", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

plot(eff, size = (1000, 400))
