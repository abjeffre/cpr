
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")

 for i = 1:2400
   i = 118
       println(i)
       abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8],
        S[i,9], S[i,10], S[i,11], S[i,12], S[i,13], S[i,14], S[i,15], S[i,16],
         S[i,17], S[i,18], S[i,19])
   end


mortality_rate =.1

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




l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(10,10)
for i = 1:length(high)
    m[i]  = mean(mean(high[i][:effort][:,2,:], dims =2))
    end

#Price is on the y axis and wage is on the x

using Plots
gr()

 p1=heatmap(m,
    c=:thermal, clim= (0, 1), xlab = "Wages", ylab = "Price",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
    yticks = ([2,19],["Low","High"]),
    xticks = ([2,19],["Low","High"]),
    )
title!("Labor = 0.1", titlefontsize = 9)


 for i = 1:2400
   i = 118
       println(i)
       abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8],
        S[i,9], S[i,10], S[i,11], S[i,12], S[i,13], S[i,14], S[i,15], S[i,16],
         S[i,17], S[i,18], S[i,19])
   end
   plot(abm_dat[:effort][:,2,:], dims =2)


test1=cpr_abm(n = 150*10, max_forest = 7500*10, ngroups = 10, lattice = [2,5], tech = 1, wages = .15,
 fines1_on = false, fines2_on = false, pun1_on = false, pun2_on = false )

test2=cpr_abm(n = 150*10, max_forest = 7500*10, ngroups = 10, lattice = [2,5], tech = 1, wages = .15,
 fines1_on = false, fines2_on = false, pun1_on = false, pun2_on = false,  experiment_leak = 1, experiment_effort = 1)

plot(test1[:fstEffort][:,:,1])
plot!(test2[:fstEffort][:,:,1], legend = false)

plot(test1[:stock][:,:,1], legend = false)
plot(test2[:stock][:,:,1], legend = false)

plot(test1[:effort][:,:,1], legend = false)
plot(test2[:effort][:,:,1], legend = false)



mean(test2[:harvest][:,2:10,1]./test2[:effort][:,2:10,1])
mean(test1[:harvest][:,2:10,1]./test2[:effort][:,2:10,1])

mean(test1[:payoffR][:,2:10,1])
mean(test2[:payoffR][:,2:10,1])



l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(10,10)
for i = 1:length(high)
    m[i]  = mean(mean(high[i][:effort][:,2,:], dims =2) - mean(low[i][:effort][:,2,:], dims = 2))
    end

#Price is on the y axis and wage is on the x

using Plots
gr()

 p1=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "Wages", ylab = "Price",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
    yticks = ([2,19],["Low","High"]),
    xticks = ([2,19],["Low","High"]),
    )
title!("Labor = 0.1", titlefontsize = 9)




S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0],             #travel cost
                [1],             #tech
                [.5],     #labor
                [0.1],           #limit seed values
                [.0015],         #Punish Cost
                [15000],          #max forest
                [0.001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],           #var forest
                10 .^(collect(range(-2, stop = 1, length = 10))),          #price
                [.025],        #regrowth
                [[1, 1]], #degrade
                10 .^(collect(range(-4, stop = 0, length = 10)))       #wages
                )



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 1,
            fine_start = nothing,
            leak = false,
            pun1_on = false,
            pun2_on = false,
            necessity  = .05,
            experiment_effort = 1,
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


test = cpr_abm(n = 150*3, ngroups = 15, lattice = [1,15], var_forest=0, travel_cost = .0000001, max_forest = 7500*3, tech = 4, nrounds = 2000,
 leak = true, pun1_on = true, pun2_on = true, og_on = false, regrow = .01,
  glearn_strat = "income", zero = true, outgroup =.01, cmls = false, back_leak = true)



test2 = cpr_abm(n = 150*12, ngroups = 12, lattice = [1,12], var_forest=0, travel_cost = .0000001, max_forest = 7500*12, tech = 4,
experiment_effort = 1, experiment_leak = 1, nrounds = 1000, leak = true, pun1_on = true, pun2_on = true, og_on = true, regrow = .01, glearn_strat = "income", zero = true)


test = cpr_abm(nsim = 5, n = 150*2, ngroups = 2, lattice = [1,2], var_forest=0, travel_cost = .0000001,
 max_forest = 7500, tech = 1, nrounds = 500,
 leak = false, pun1_on = false, pun2_on = false, og_on = false,
  regrow = .01, glearn_strat = "income", wages = .1, back_leak = false, fidelity = .02, nmodels = 10)


  
test2 = cpr_abm(nsim = 1, n = 150*2, ngroups = 2, lattice = [1,2], var_forest=0,
travel_cost = .0000001, max_forest = 5000, tech = 1,
experiment_effort = 1, experiment_leak = .0001, nrounds = 500, leak = true, pun1_on = false, 
pun2_on = false,
og_on = false, regrow = .01, glearn_strat = "income", wages = .01, experiment_punish1 = 0,
back_leak = true, kmax_data = [10000, 5000], labor =.1)



test3 = cpr_abm(nsim = 1, n = 150*2, ngroups = 2, lattice = [1,2], var_forest=0,
travel_cost = .0000001, max_forest = 5000, tech = 1,
experiment_effort = 1, experiment_leak = .9, nrounds = 500, leak = true, pun1_on = false,
 pun2_on = false,
og_on = false, regrow = .01, glearn_strat = "income", wages = .01, experiment_punish1 = 0,
back_leak = true, kmax_data = [10000, 5000], labor =.9)


using(Plots)
plot(test2[:effort][:,2,:], legend = true, ylim = (0,1), color = "goldenrod")
plot!(test3[:effort][:,2,:], legend = true, ylim = (0,1), color = "blue")

plot(test2[:vl][:,2,:], legend = true)

plot(test2[:leakage][:,2,:], legend = false, ylim = (0,1))
plot!(test3[:leakage][:,2,:], legend = false, ylim = (0,1))

plot(test2[:stock][:,2,:], legend = false, ylim = (0,1))
plot!(test3[:stock][:,2,:], legend = false, ylim = (0,1))

plot(test[:payoffR][:,2,:], legend = false, ylim = (0,1))
plot(test2[:payoffR][:,2,:], legend = false, ylim = (0,1))




mean(test[:effort][1:500,2,:])
mean(test2[:effort][1:500,2,:])
mean(test3[:effort][1:500,2,:])


plot(test[:stock][:,:,:1], legend = false, ylim = (0,1))
plot(test[:effort][:,:,1], legend = false, ylim = (0,1))
plot(test2[:stock][:,:,1], legend = false, ylim = (0,1))
plot(test2[:effort][:,:,1], legend = false, ylim = (0,1))
plot(test2[:punish2][:,:,1], legend = false, ylim = (0,1))
plot(test[:punish2][:,:,1], legend = false, ylim = (0,1))
plot(test[:limit][:,:,1], legend = false, ylim = (0,1))
plot(test2[:limit][:,:,1], legend = false, ylim = (0,1))


plot(test[:leakage][:,2,:], legend = false, ylim = (0,1))
plot(test2[:leakage][:,2,:], legend = false, ylim = (0,1))

plot(test[:payoffR][:,:,1], legend = false, ylim = (0,1))
plot(test2[:payoffR][:,:,1], legend = false, ylim = (0,1))


Hi all, I have a conceptual question.  Suppose we have the following sampling problem
where we want to sample some random variable such that increase (beyond normal frequencies)
the probabily of sampling from a high probability density region.   How  would one go about this?

For example suppose we have:
x=rand(Normal(), 100000)
w = abs.(x.-mean(x))
w=AnalyticWeights((findmax(w)[1].-w).^10)
y=sample(x, w, 1000)

var(y)
var(x)



l = @layout [
             [grid(3,3)
             b{0.2h}  ]
]

l = @layout [grid(3,3)
             b{0.2h}  ]

l = @layout [[a{0.41h};b;c;d{0.41h}] grid(3,3)]
Plots.GridLayout(1, 2)

plot(
           rand(10, 13),
           layout = l, legend = false, seriestype = [:bar :scatter :path],
           title = ["($i)" for j in 1:1, i in 1:13], titleloc = :right, titlefont = font(8)
           )





           
S =expand_grid( [300],           #Population Size
[2],             #ngroups
[[1, 2]],        #lattice, will be replaced below
[.0001],           #travel cost
[1],             #tech
[.1, .5, .9],           #labor
[0.1],           #limit seed values
10 .^(collect(range(-5, stop =-1, length = 10))),     #Punish Cost
[15000],          #max forest
[0.001,.9],      #experiment leakage
[0.5],           #experiment punish
[1],             #experiment_group
[1],             #groups_sampled
[1],             #Defensibility
[1],           #var forest
10 .^(collect(range(-2, stop = 1, length = 20))),          #price
[.025],        #regrowth
[[1, 1]], #degrade
10 .^(collect(range(-4, stop = 0, length = 20)))       #wages
)




#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
cpr_abm(nrounds = 500,
nsim = 5,
fine_start = nothing,
leak = false,
pun1_on = true,
pun2_on = false,
experiment_effort = 1,
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

test1=cpr_abm(labor = .9, travel_cost = .0001, punish_cost =.000001, wages = 0.001, price = .01,
experiment_effort = 1, experiment_leak =.0001,
leak = true, back_leak = true, pun2_on =false, pun1_on = false, max_forest = 5000, regrow = .01,
fines1_on = true, nrounds = 500,  inspect_timing = "after")

test2=cpr_abm(labor = .9, travel_cost = .0001, punish_cost =.000001, wages = 0.001, price = .01,
experiment_effort = 1, experiment_leak =.9,
leak = true, pun2_on =false, back_leak = true, pun1_on = false, max_forest = 5000, regrow = .01, fines1_on = true, nrounds = 500, 
fine =10, fines_on = true, inspect_timing = "before")

using(Plots)
plot(test1[:effort][:,2,:], legend = true, ylim = (0,1), color = "goldenrod")
plot!(test2[:effort][:,2,:], legend = true, ylim = (0,1), color = "blue")

plot(test1[:stock][:,2,:], legend = true, ylim = (0,1), color = "goldenrod")
plot!(test2[:stock][:,2,:], legend = true, ylim = (0,1), color = "blue")

plot(test1[:punish][:,2,:], legend = true, ylim = (0,1), color = "goldenrod")
plot!(test2[:punish][:,2,:], legend = true, ylim = (0,1), color = "blue")

plot(test1[:seized][:,2,:], legend = true, ylim = (0,1), color = "goldenrod")
plot!(test2[:seized][:,2,:], legend = true, ylim = (0,1), color = "blue")




using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_p1contG.jld2")

punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)
pars = [:effort, :punish]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))
cols = [:RdBu_9, :lighttemperaturemap]


for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==punishcost[j], S[:,8])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2)-mean(low[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-.1,.1), (-1,1)),
                             xlab = ifelse(r==2, "Wages", " "),
                             ylab = ifelse(k==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 2, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==1, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end
#
# for  r in 1:length(pars)
#         for j in 1:length(labor)
#                 fps = 3
#                 anim = @animate for i = 1:10
#                 #Define line settings
#                 plot(p_arr[i, j, r])
#                 end
#                 gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_pc1_", pars[r], "l", labor[j], ".gif")
#                 , fps = fps)
#         end
# end




fps = 2
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))


test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b;c{.05h}]
Plots.GridLayout(3, 1)
plot(set1, set2, test, size = (1000, 700), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
 layout = l)
end
gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\test.gif")
, fps = fps)



######################################################
################ Check group Size ####################

using Plots

ng =2
test =cpr_abm(labor = .7, max_forest = 105000*ng, n = ng*75, ngroups = ng, 
lattice = [1,2], harvest_limit = 2, harvest_var = .5, nrounds = 75000,
harvest_var_ind = 0.1, experiment_group = collect(1:1:ng), zero = true, nsim = 20,
experiment_punish2 = 1, leak = false, control_learning = true, back_leak= true)


# Multicore
ng = fill(2, 80)
@everywhere function g2(ng) 
    cpr_abm(labor = .7, max_forest = 105000*ng, n = ng*75, ngroups = ng, 
        lattice = [1,ng], harvest_limit = 2, harvest_var = .5, nrounds = 75000,
        harvest_var_ind = 0.1, experiment_group = collect(1:1:ng), zero = true, nsim = 1,
        experiment_punish2 = 1, leak = false, control_learning = true, back_leak= true)
end

test=pmap(g2, ng)

#
i=1
a= plot(plot(test[:limit][:,:,i], label = "", alpha = .3))
[plot!(test[:limit][:,:,i], label = "", alpha = .3) for i in 1:20]

i=1
b= plot(plot(test[:stock][:,:,i], label = "", alpha = .5))
[plot!(test[:stock][:,:,i], label = "", alpha = .5) for i in 1:20]

i=1
c= plot(plot(test[:payoffR][:,:,i], label = "", alpha = .05))
[plot!(test[:payoffR][:,:,i], label = "", alpha = .05) for i in 1:20]

plot(a, b, c, layout = grid(1,3), size = (900, 300))


# Increase group size

using Plots

ng =9
test =cpr_abm(labor = .7, max_forest = 105000*ng, n = ng*75, ngroups = ng, 
lattice = [1,ng], harvest_limit = 2, harvest_var = .5, nrounds = 6000,
harvest_var_ind = 0.1, experiment_group = collect(1:1:ng), zero = true, nsim = 20,
experiment_punish2 = 1, leak = false, control_learning = true, back_leak= true)


# For multicore please used

ng = fill(9, 20)
pmap(g2, ng)

using Serialization
test9=deserialize("Y:/eco_andrews/Projects/CPR/data/abm/test9.dat")
#
i=1
a= plot(plot(test9[:limit][:,:,i], label = "", alpha = .2))
[plot!(test9[:limit][:,:,i], label = "", alpha = .2) for i in 1:20]

i=1
b= plot(plot(test9[:stock][:,:,i], label = "", alpha = .2))
[plot!(test9[:stock][:,:,i], label = "", alpha = .2) for i in 1:20]

i=1
c= plot(plot(test9[:payoffR][:,:,i], label = "", alpha = .2))
[plot!(test9[:payoffR][:,:,i], label = "", alpha = .2) for i in 1:20]

plot(a, b, c, layout = grid(1,3), size = (900, 300))

# Multicore
using Plots.PlotMeasures

testlong=deserialize("Y:/eco_andrews/Projects/CPR/data/abm/testlong.dat")
using Plots
timmer = collect(1:99:75000)
i=1
a= plot(testlong[i][:limit][timmer,:,1], label = "", alpha = .1, c = :black, ylab = "MAY", ylim = (0, 25))
[plot!(testlong[i][:limit][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:80]
hline!([3.5, 3.5], lw = 3, c = :red, label = "MSY")

i=1
b= plot(testlong[i][:stock][timmer,:,1], label = "", alpha = .1, c = :black, xlab = "Time", ylab = "Stock", title = "2 groups")
[plot!(testlong[i][:stock][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:80]

i=1
c= plot(testlong[i][:payoffR][timmer,:,1], label = "", alpha = .1, c = :black, ylab = "Payoffs")
[plot!(testlong[i][:payoffR][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:80]

MSYsearch2groups=plot(a, b, c, layout = grid(1,3), size = (975, 300), left_margin = 25px, bottom_margin = 25px)
savefig(MSYsearch2groups, "MSYsearch2groups.pdf")


testlong9=deserialize("Y:/eco_andrews/Projects/CPR/data/abm/testlong9.dat")
i=1
timmer = collect(1:99:75000)
a= plot(testlong9[i][:limit][timmer,:,1], label = "", alpha = .1, c = :black, ylab = "MAY")
[plot!(testlong9[i][:limit][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:20]
hline!([3.5, 3.5], lw = 3, c = :red, label = "MSY")

i=1
b= plot(testlong9[i][:stock][timmer,:,1], label = "", alpha = .1, c = :black, xlab = "Time", ylab = "Stock", title = "9 groups")
[plot!(testlong9[i][:stock][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:20]

i=1
c= plot(testlong9[i][:payoffR][timmer,:,1], label = "", alpha = .1, c = :black, ylab = "Payoffs")
[plot!(testlong9[i][:payoffR][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:20]

MSYsearch9groups=plot(a, b, c, layout = grid(1,3), size = (975, 300), left_margin = 25px, bottom_margin = 25px)
savefig(MSYsearch9groups, "MSYsearch9groups.pdf")
plot(MSYsearch2groups, MSYsearch9groups, layout = grid(2,1), size = (975, 700))




[testlong9[i][:limit][75000,:,1] for i in 1:20]

final_limit=reduce(vcat, [testlong9[i][:limit][75000,:,1] for i in 1:20])
histogram(final_limit)

regrow = 0.01
forest = 105000
n = 75
msy = ((forest*regrow)/4)/n

a=cpr_abm(labor = .7, max_forest = 105000*9, n = 9*75, ngroups = 9, 
lattice = [3,3], harvest_limit = 2, harvest_var = .2, nrounds = 5000, travel_cost = 0,
harvest_var_ind = 0.5, experiment_group = collect(1:1:9), zero = true, nsim = 1, regrow = 0.01,
experiment_punish2 = 1, experiment_punish1 = 0.5,  experiment_leak = 1, special_leakage_group = 5,
leak=false, control_learning = true, back_leak= true, pun1_on = true, groups_sampled = 8, genetic_evolution = true,
seed = 2, seized_on = false)

plot(a[:stock][:,:,1])
plot(a[:limit][:,:,1])
plot(a[:harvest][:,:,1])
plot(a[:leakage][:,:,1])
plot(a[:effort][:,:,1])
plot(a[:payoffR][:,:,1])




S=collect(0.1:.05:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 75*2, max_forest = 2*105000, ngroups =2, nsim = 100,
    lattice = [1,2], harvest_limit = 1, harvest_var = .1, harvest_var_ind = .1,
    regrow = .01, pun2_on = true, leak=false,
    wages = 0.1, price = 1, defensibility = 1, experiment_leak = L, experiment_effort =.5, experiment_punish2=1,
     fines1_on = false, punish_cost = 0.1, labor = .7, zero = true, begin_leakage_experiment = 1)
end
dat=pmap(g, S)
serialize("brutetest.dat", dat)

dat = deserialize("cpr\\data\\abm\\brutetest.dat")

y = [mean(dat[i][:punish][400:500,2,:], dims =1) for i in 1:length(dat)]
a=reduce(vcat, y[2:19])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.01:.05:1)
x=repeat(x, 10)

mean(y)
border=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "IRC", ylab = "Support for borders",
title = "(e)", titlelocation = :left, titlefontsize = 15)
scatter!(x.*19, y, c=:firebrick, alpha = .2, label = false)

########################################
######## SEARCH ########################

S=collect(0.1:.05:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 75*9, max_forest = 9*105000, ngroups =9, nsim = 50,
    lattice = [3,3], harvest_limit = 4, harvest_var = .7, harvest_var_ind = .1,
    regrow = .01, pun2_on = true, leak=true, nrounds = 500,
    wages = 0.1, price = 1, experiment_punish1=L, experiment_group = collect(1:1:9), back_leak = true,
    fines1_on = false, punish_cost = 0.1, labor = .7, zero = true, learn_group_policy = true, control_learning = true)
end
dat=pmap(g, S)
serialize("cpr\\data\\abm\\regulation.dat", dat)
dat = deserialize("cpr\\data\\abm\\brutetest2.dat")


y = [mean(mean(dat[i][:punish2][200:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y)
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.01:.05:1)
x=repeat(x, 19)


mean(y)
Punish=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3,
 c=:grey, label = false, xlab = "Presence of Borders",
 ylab = "Support for Regulation", xticks = (collect(1:4:19), ("0", "0.2", "0.4", "0.6", "0.8", "1")),
 title = "(f)", titlelocation = :left, titlefontsize = 15)
scatter!((x.*19 .+.9), b, c=:black, alpha = .2, label = false)


y1 = [mean(mean(dat[i][:punish2][490:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y1[1:19])
μ = mean(a, dims = 2)
a=reduce(vcat, y1[1:19])
a=reduce(vcat, a)

y2 = [mean(mean(dat[i][:limit][490:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a2=reduce(vcat, y1[1:19])
μ = mean(a2, dims = 2)
a2=reduce(vcat, y2[1:19])
a2=reduce(vcat, a2)


Selection=scatter(a, a2, c=:black, ylim = (0, 6), label = false, xlab = "Support for Regulation", yticks = (0, " "), 
ylab = "MAY", alpha = .3,
title = "(g)", titlelocation = :left, titlefontsize = 15)
hline!([3.5], lw = 2, c=:red, label = "MSY", )


S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 20,
    lattice = [3,3], harvest_limit = 8.259-2, regrow = .025, pun1_on = true, 
    wages = 0.007742636826811269, price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_punish1 = L,  travel_cost = 0,
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true, learn_group_policy = true)
end
dat=pmap(g, S)
@JLD2.save("brute3.jld2", dat)






####################################################################
####### BANDITRY ON BORDERS  #######################################

# Note we increase the amount of forest to ensure that it does not bottom out by the time we sample the amount of support for borders. 
if RUN  == true
    S=collect(0.01:.05:1)
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    @everywhere function g(L)
        cpr_abm(n = 75*9, max_forest = 9*200000, ngroups =9, nsim = 20,
        lattice = [3,3], harvest_limit = 3.4, harvest_var = .01, harvest_var_ind = .01,
        regrow = .01, pun2_on = true, leak=false, pun1_on = false, experiment_group = [5,6],
        wages = 0.1, price = 1, defensibility = 1, experiment_leak = L, 
        experiment_effort =1, control_learning = false,
        fines1_on = false, punish_cost = 0.1, labor = .7, 
        zero = true, begin_leakage_experiment = 1)
    end
    dat=pmap(g, S)
    serialize("test.dat", dat)
end

# Load 
using Serialization
dat = deserialize("cpr\\data\\abm\\test.dat")

groups = [collect(1:1:4); collect(7:1:9)]
y = [mean(dat[i][:punish2][400:500,groups,:], dims =1) for i in 1:length(dat)]
μ = [median(y[i]) for i in 1:length(dat)]
a = [reduce(vcat, y[i]) for i in 1:length(y)]
PI = [quantile(a[i], [0.31,.68]) for i in 1:size(y)[1]]
PI=vecvec_to_matrix(PI) 
x1=collect(.01:.05:1)
x=reduce(vcat, [fill(i, length(dat)*7) for i in x1])
a=reduce(vcat, a)

mean(y)
bandits_on_self_regulation=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:grey, label = false,
 xlab = "Roving Banditry", ylab = "Support for Regulation",
xticks = (collect(0:4:20), ("0", "0.2", "0.4", "0.6", "0.8", "1")),
title = "(g)", titlelocation = :left, titlefontsize = 15)
scatter!(x.*20, a, c=:black, alpha = .2, label = false)






####################################################################
####### BANDITRY ON BORDERS  #######################################

# Note we increase the amount of forest to ensure that it does not bottom out by the time we sample the amount of support for borders. 
if RUN  == true
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    S=collect(0.1:.05:1)
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    @everywhere function g(L)
        cpr_abm(n = 75*9, max_forest = 9*105000, ngroups =9, nsim = 50,
        lattice = [3,3], harvest_limit = 2, harvest_var = .01, harvest_var_ind = .1,
        regrow = .01, pun2_on = true, leak=true, nrounds = 1000,
        wages = 0.1, price = 1, experiment_punish1=L, experiment_group = collect(1:1:9), back_leak = true,
        fines1_on = false, punish_cost = 0.1, labor = .7, zero = true, learn_group_policy = true, control_learning = true)
    end
    dat=pmap(g, S)
    serialize("borders_on_reg.dat", dat)
end

# Load 
using Serialization
dat = deserialize("cpr\\data\\abm\\borders_on_reg.dat")

groups = collect(1:1:9)
y = [mean(dat[i][:punish2][400:500,groups,:], dims =1) for i in 1:length(dat)]
μ = [median(y[i]) for i in 1:length(dat)]
a = [reduce(vcat, y[i]) for i in 1:length(y)]
PI = [quantile(a[i], [0.31,.68]) for i in 1:size(y)[1]]
PI=vecvec_to_matrix(PI) 
x1=collect(.1:.05:1)
x=reduce(vcat, [fill(i, size(dat[1][:stock])[3]*9) for i in x1])
a=reduce(vcat, a)

using GR
borders_on_selfreg=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:grey, label = false,
 xlab = "Presence of Borders", ylab = "Support for Regulation",
xticks = (collect(0:4:20), ("0", "0.2", "0.4", "0.6", "0.8", "1")),
title = "(g)", titlelocation = :left, titlefontsize = 15)
scatter!(x[collect(1:10:8550)]*20, a[collect(1:10:8550)], c=:black, alpha = .2, label = false)



a=cpr_abm(n=90, lattice = [3,3], ngroups = 9, pgrowth_data = ones(500), 
max_forest = 410000*9, population_growth = true, 
defensibility = 100, def_perc = false)

plot(a[:stock][:,:,1])
plot(a[:punish][:,:,1])
plot(a[:harvest][:,:,1])
plot(a[:limit][:,:,1])
plot(a[:punish2][:,:,1])
plot(a[:leakage][:,:,1])



include("C:/Users/jeffrey_andrews/OneDrive/Documents/MI/models/trade_spec_functions.jl")
a=dol_abc(ngen = 50, utility = "ces",  
 production_mode = "increasing", unit_tests= true,
 rank = [.6, .4], trading = true, k =.5, specialization = true)

baseplot(a)

using Plots
function

# Prices
p1 = scatter(fill(1, 200), a[:prices][:,1,1,1], alpha = .1, label = "", c = :firebrick)
for j in 2:
    for i in 2:10:1000
        scatter!(fill(i, 200), a[:prices][:,1,i,1], alpha = .1 , label = "", c = :firebrick)
    end
scatter!(fill(1, 200), a[:prices][:,2,1,1], alpha = .1, label = "", c = :blue)
for i in 2:5:1000
    scatter!(fill(i, 200), a[:prices][:,2,i,1], alpha = .1 , label = "", c = :blue)
end
p1


p3=plot([mean(a[:trade_type][:,t,1]).-1 for t in 1:1000])


# Effort and specialziation
p4 = scatter(fill(1, 200), a[:effort][:,1,1,1], alpha = .1, label = "", c = :firebrick)
for i in 2:5:1000
    scatter!(fill(i, 200), a[:effort][:,1,i,1], alpha = .1 , label = "", c = :firebrick)
end
scatter!(fill(1, 200), a[:effort][:,2,1,1], alpha = .1, label = "", c = :blue)
for i in 2:5:1000
    scatter!(fill(i, 200), a[:effort][:,2,i,1], alpha = .1 , label = "", c = :blue)
end
p4



[sum(a[:inv][:,:,t]) for t in 1:50]


using Plots
plot([mean(a[:effort][:,1,t]) for t in 1:500])
plot!([mean(a[:effort][:,2,t]) for t in 1:500])
[sum(a[:inv][:,:,t]) for t in 1:50]



a[:effort][:,:,50]
a[:utility][:,49]


a[:buy][:,:,50]
a[:need][:,:,1]
sum(a[:need][:,:,])
a[:pre_sale_need][:,:,50]
a[:need][:,:,50]




sum(a[:inv][:,:,50])
sum(a[:pre_sale_inv][:,:,50])


need[:,:,t]=a[:pre_sale_need][:,:,3]
inv[:,:,t]=a[:pre_sale_inv][:,:,3]
prices[:,:,t]=a[:prices][:,:,2]

a[:effort]

a[:inv][:,:,1]
a[:prices][:,:,50]
mean(a[:prices][:,:,50], dims = 1)

sum(minimum(inv[i,:,t]./rank))