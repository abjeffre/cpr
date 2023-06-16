plot(plot(dat[19][:stock][250:350:i])plot(dat[19][:limit][250:350:i])
 plot(dat[19][:punish2][1:150:i]) plot(dat[19][:payoffR][250:350:i])
  plot(dat[19][:effort][250:350:i])
  plot(dat[19][:leakage][1:150:i]) label = "")



    nsim = 1                       # Number of simulations per call
    nrounds = 500                  # Number of rounds per generation
    n = 300                        # Size of the population
    ngroups = 2                    # Number of Groups in the population
    lattice = (1, 2)               # This controls the dimensions of the lattice that the world exists on
    mortality_rate = 0.03          # The number of deaths per 100 people
    mutation = 0.01                # Rate of mutation on traits
    wages = .1                     # Wage rate in other sectors - opportunity costs
    max_forest = 350000            # Average max stock
    var_forest = 0                 # Controls athe heterogeneity in forest size across diffrent groups
    degrade = 1                     # This measures how degradable a resource is(when invasion the resource declines linearly with size and as it increase it degrades more quickly if negative it decreases the rate of degredation) degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
    regrow = .01                   # The regrowth rate
    volatility = 0                 # The volatility of the resource each round - set as variance on a normal
    pollution = false              # Pollution provides a public cost based on 
    pol_slope = .1                 # As the slope increases the rate at which pollution increases as the resource declines increase
    pol_C = .1                     # As the constant increases the total amount of polution increases
    ecosys = false                 # Eco-system services provide a public good to all members of a group proportionalm to size of resource
    eco_slope = 1                  # As the slope increases the resource will continue to produce ecosystem servies
    eco_C = .01                    # As the constant increases the total net benifit of the ecosystem services increases
    tech = 1                       # Used for scaling Cobb Douglas production function
    labor = .7                     # The elasticity of labor on harvesting production
    price = 1.0                      # This sets the price of the resource on the market
    ngoods = 2                     # Specifiies the number of sectors
    necessity = 0                  # This sets the minimum amount of the good the household requires
    monitor_tech = 1           # This controls the efficacy of monitnoring higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i 1 x) 0 5) where i is the proportion of monitors in a pop
    defensibility = 1              # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
    def_perc = true                # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
    punish_cost = 0.1              # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs
    fine = 0.0                     # This controls the size of the fine issued when caught note that in a real world situation this could be recouped by the injured parties but it is not
    harvest_limit = 5              # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
    harvest_var = 1.5              # Harvest limit group offset 
    harvest_var_ind = .5           # Harvest limit individual offset
    pun2_on = true                 # Turns punishment on or off. 
    pun1_on = true                 # Turns group borders on or lff
    seized_on = true               # Turns seizures on or nff
    fines_evolve = true            # If false fines stay fixed at initial value
    fines1_on = false              # Turns on fines for local agents
    fines2_on = false              # Turns on fines for non locals
    fine_start = 1                 # Determine mean fine value for all populations at the beginiing SET TO NOHTING TO TURN OFF
    fine_var = .2                  # Determines the group offset for fines at the begining
    distance_adj =0.9              # This affects the proboabilty of sampling a more close group.
    travel_cost = .00              # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
    groups_sampled = 1             # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes
    social_learning = true         # Toggels whether Presitge Biased Tranmission is on
    nmodels = 3                    # The number of models sampled to copy from in social learning
    fidelity = 0.02                # This is the fidelity of social transmission
    learn_type = "income"          # Two Options - "wealth" and "income" indiviudals can choose to copy wealth or income if copy wealth they copy total overall payoffs if copy income they copy payoffs from the previous round
    outgroup = 0.01                # This is the probability that the individual samples from the whole population and not just his group when updating0...
    baseline = .01                 # Baseline payoff to be added each round -
    leak = true                    # This controls whether individuals are able to move into neightboring territory to harvest
    verbose = false                # verbose reporting for debugging
    seed = 1984
    og_on = false                  # THe evolution of listening to outgroup members.
    experiment_leak = false        # THIS SETS THE VALUE OF THE OTHER GROUP LEAKAGE and Punish
    experiment_punish1 = false     # THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
    experiment_punish2 = false     # THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
    experiment_limit = false       # THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
    experiment_effort = false      # THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
    experiment_price = false      # THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
    experiment_group = 1           # Determines the set of groups which the experiment will be run on
    cmls = false                   # Determines whether cmls will operate
    invasion = false                   # Checks invasion criteria by setting all trait start values to near invasion
    glearn_strat = false           # options: "wealth" "income" "env"
    split_method = "random"        # How groups split is CLMS is on
    kmax_data = nothing            # This takes data for k
    back_leak = false              # Determines whether or not individuals can back_invade
    fines_on = false               # Turns fines on or off!
    inspect_timing = nothing       # options: nothing "before" "after" if nothing then it randomizes to half and half
    inher = false                  # Turns wealth inheretence on or off
    tech_data = nothing            # The modle can recieve data specifiying the technological capacity of the system over time
    harvest_type = "individual"    # Individuals can pool labor before harvests 
    policy_weight = "equal"        # Typically takes wealth as a weight but can take any-data that can be used to rank people.
    rec_history =  false           # You can record the history of wealth but it is costly. 
    resource_zero = false          # Sets resource to invasion to observe regrowth dynamics
    harvest_zero = false           # Automatically sets harvest to invasion to observe simple regrowth dynamics
    wealth_degrade = nothing       # When wealth is passed on it degrades by some percent
    slearn_freq = 1                # Not opperational - it defines the frequency of social learning 
    reset_stock = 100000                 # Is the year in which resources are reset to max
    socialLearnYear = nothing      # Which years individuals are allowed to socially learn in  - specify as a vector of dates
    αlearn = 1                     # Controls learning rate
    indvLearn = false              # Controls whehter individual learning is turned on
    full_save = false              # Saves everything if true
    compress_data = true           # Compresses data to Float64 if true
    control_learning = false       # Agents can learn from experimental groups if true
    learn_group_policy = false     # Agents learn the policy of targeted out group not trait of inidivudal
    bsm = "individual"              # Defines how gains from seizures are split options = "Collective" or "individual"
    genetic_evolution = true        # defines whether or not genetic evolution opperates. 
    special_leakage_group = nothing # If the leakage experiment group cannot be the same as the other groups. 
    begin_leakage_experiment = 200000 # this is set so large that it doesnt ping unless changed.
    population_growth = false
    pgrowth_data = nothing
    unitTest = false
   special_experiment_leak = nothing
   α = 1
   population_data = nothing
   new_leakage_experiment = nothing

ngroups = 15
a = cpr_abm(degrade = .14, n=75*ngroups, ngroups = ngroups, lattice = [3,5],
  max_forest = 50500*ngroups, tech = .09, wages = 6, price = .7, nrounds = 5000, leak = false,
   harvest_limit = 2, learn_group_policy =true, invasion = true, nsim = 30,
   experiment_group = collect(1:15), control_learning = true, back_leak = true
  )


b = cpr_abm(degrade = .14, n=75*ngroups, ngroups = ngroups, lattice = [3,5],
  max_forest = 50500*ngroups, tech = .09, wages = 6, price = .7, nrounds = 600, leak = false,
   harvest_limit = 2, learn_group_policy =false, invasion = true, nsim = 20,
   experiment_group = collect(1:15), control_learning = true, back_leak = true, outgroup = .5,
   full_save = true, genetic_evolution = false, glearn_strat = "income"
  )

sum(b[:stock][600,:,:] .> .6)

i = 1
r = 200:300
plot(plot(b[:stock][r,:,i] , ylim = (0, 1), title = "stock"), plot(b[:payoffR][r,:,i], title = "payoff" , ylim = (5, 10)), plot(b[:effort][r,:,i], title = "effort", ylim = (0, 1)), plot(b[:harvest][r,:,i], title = "harvest" , ylim = (0, 15)),
  plot(b[:punish2][r,:,i], title = "enforce", ylim = (0, 1), c = "black", alpha = .1), plot(b[:limit][r,:,i] , title = "limit", ylim = (0, 10), c = "black", alpha = 1), label = "")


c = cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [3,5],
max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 600, leak = false,
harvest_limit = 2, learn_group_policy =false, invasion = true, nsim = 20,
experiment_group = collect(1:15), control_learnin114g = false, back_leak = true, outgroup = .0,
full_save = true, genetic_evolution = false, glearn_strat = "income"
)
i=8
r = 1:600
g=2
plot(plot(c[:stock][r,g,i] , ylim = (0, 1), title = "stock"), plot(c[:payoffR][r,g,i], title = "payoff" , ylim = (0, 50)), plot(c[:effort][r,g,i], title = "effort", ylim = (0, 1)), plot(c[:harvest][r,g,i], title = "harvest" , ylim = (0, 25)),
  plot(c[:punish2][r,g,i], title = "enforce", ylim = (0, 1), c = "black", alpha = 1), plot(c[:limit][r,g,i] , title = "limit", ylim = (0, 10), c = "black", alpha = 1),
  plot(c[:seized2][r,g,i] , title = "seizedin", ylim = (0, 1200), c = "black", alpha = 1), label = "")

group =15
x=[cor(c[:punish2full][j,b[:gid][:,sim].==group,i], c[:effortfull][j,b[:gid][:,sim].==group,i]) for j in 1:600]
plot(x)
x=[cor(c[:limitfull][j,b[:gid][:,sim].==group,i], c[:effortfull][j,b[:gid][:,sim].==group,i]) for j in 1:600]
plot!(x)

x=[cor(c[:punish2][j,:,i], c[:effort][j,:,i]) for j in 1:600]
plot(x)
x=[cor(c[:limit][j,:,i], c[:effort][j,:,i]) for j in 1:600]
x=[cor(c[:limit][j,:,i], c[:punish2][j,:,i]) for j in 1:600]
x=[cor(c[:limit][j,:,i], c[:payoffR][j,:,i]) for j in 1:600]
x=[cor(c[:punish2][j,:,i], c[:payoffR][j,:,i]) for j in 1:600]

plot!(x)


sum(c[:stock][600,:,:] .> .6)

ngroups = 15
d = cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [1,2], labor = 1,
   max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 2000, leak = false,
   harvest_limit = 2, learn_group_policy =false, invasion = true, nsim = 1, experiment_effort = .07,
   experiment_group = 1, control_learning = true, back_leak = true, outgroup = .99,
   full_save = true, genetic_evolution = false, glearn_strat = "income"
  )

i=1
plot(plot(d[:stock][:,:,i] , ylim = (0, 1)), plot(d[:payoffR][:,:,i], title = "payoff" , ylim = (0, 50)), plot(d[:effort][:,:,i], title = "effort", ylim = (0, 1)), plot(d[:harvest][:,:,i], title = "harvest" , ylim = (0, 15)),
  plot(d[:punish2][:,:,i], title = "enforce", ylim = (0, 1), c = "black", alpha = .1), plot(d[:limit][:,:,i] , title = "limit", ylim = (0, 10), c = "black", alpha = 1), label = "")


  sum(d[:stock][600,:,:] .> .6)


  mean(d[:payoffR][600,:,:])
  mean(c[:payoffR][600,:,:])
  mean(b[:payoffR][600,:,:])

i = 2


i =7
plot(plot(b[:stock][:,:,i] , ylim = (0, 1), c = "black", alpha = .2), plot(b[:payoffR][:,:,i], title = "payoff" , ylim = (0, 10), c = "black", alpha = .2), plot(b[:effort][:,:,i], title = "effort", ylim = (0, 1)), plot(b[:harvest][:,:,i], title = "harvest" , ylim = (0, 15)),
  plot(b[:punish2][:,:,i], title = "enforce", ylim = (0, 1), c = "black", alpha = .1), plot(b[:limit][:,:,i] , title = "limit", ylim = (0, 10), c = "black", alpha = 1), label = "")
 
b[:limit]
  


using LinearRegression

#x[100]
x=[coef(linregress(b[:payoffR][i,:,1], b[:limit][i,:,1]))[2] for i in 1:200]
x=[cor(b[:limit][i,:,sim], b[:payoffR][i,:,sim]) for i in 1:600]
plot(x, labe = "")
x[50]
for j in 1:15
    x=[cor(b[:limitfull][i,b[:gid][:,sim].==j,sim], b[:payoffRfull][i,b[:gid][:,sim].==j,sim]) for i in 1:600]
    #x=[coef(linregress(b[:limitfull][i,b[:gid].==j,1], b[:payoffRfull][i,b[:gid].==j,1]))[2] for i in 1:200]
    plot!(x, label = "")
end


x=[cor(b[:punish2full][i,:,1], b[:payoffRfull][i,:,1]) for i in 1:20]




x=[cor(b[:punish2full][i,:,1], b[:payoffRfull][i,:,1]) for i in 100:200]
plot(x)
x=[mean(b[:punish2][i,:,1]) for i in 100:200]
plot!(x)
x=[cor(b[:limitfull][i,:,1], b[:payoffRfull][i,:,1]) for i in 100:200]
plot!(x)
x=[cor(b[:effortfull][i,:,1], b[:payoffRfull][i,:,1]) for i in 100:200]
plot!(x)
x=[cor(b[:stock][i,:,1], b[:payoffR][i,:,1]) for i in 100:200]
plot!(x)

scatter( b[:payoffRfull][i,b[:gid].==1,1])
scatter( b[:limitfull][i,b[:gid].==1,1])

scatter( b[:limitfull][10,:,1])
i = 100


anim = @animate for i ∈ 1:2:20
    scatter(b[:limitfull][i,:,1], b[:payoffRfull][i,:,1], ylim = (0, 10), xlim = (0, 10), c = b[:gid][:,:,1])
end
gif(anim, "anim_fps15.gif", fps = 1)


plot!(x)
plot!(b[:payoffR][100:200,:,1].-5)


x=[median(b[:limitfull][i,:,1]) for i in 100:200]
plot!(x)
plot!(b[:stock][100:200,:,1])


x=[cor(b[:effortfull][i,:,1], b[:payoffRfull][i,:,1]) for i in 100:200]
plot!(x)


i= 29
plot(plot(a[:stock][:,:,i] , ylim = (0, 1)), plot(a[:payoffR][:,:,i], title = "payoff" , ylim = (0, 10)), plot(a[:effort][:,:,i], title = "effort", ylim = (0, 1)), plot(a[:harvest][:,:,i], title = "harvest" , ylim = (0, 15)),
 plot(a[:punish2][:,:,i], title = "enforce", ylim = (0, 1)), plot(a[:limit][:,:,i] , title = "limit", ylim = (0, 10)), label = "")

 plot(a[:leakage][:,:,1])




ngroups = 20
g = cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [ngroups,1], labor = .5,
   max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 500, leak = false,
   experiment_stock =fill(5000, ngroups), pun2_on = true,
   limit_seed = [0,.5], harvest_var_ind = .05, invasion = true, nsim = 1, learn_group_policy = false,
   control_learning = true, back_leak = true, outgroup = .1, experiment_group = collect(1:ngroups),
   full_save = true, genetic_evolution = false, glearn_strat = "income", seized_on = true, experiment_punish2 = 1, fidelity = .05,
  )



plot(plot(e[:payoffR][:,:,1], title = "payoff", ylim = (1,2)), plot(e[:effort][:,:,1], title = "effort"), plot(e[:punish2][:,:,1],title = "enforce"), plot(e[:limit][:,:,1], title = "limit"), plot(e[:seized2in][:,:,1], title = "seizures"), plot(e[:harvest][:,:,1], title = "harvest"), label = "")
plot(plot(g[:payoffR][:,:,1], title = "payoff", ylim = (1,2)), plot(g[:effort][:,:,1], title = "effort"), plot(g[:punish2][:,:,1],title = "enforce"), plot(g[:limit][:,:,1], title = "limit"), plot(g[:seized2in][:,:,1], title = "seizures"), plot(g[:harvest][:,:,1], title = "harvest"), label = "")

print(g[:payoffR][begin,:,1])
mean(g[:limit][begin,:,1])
mean(g[:limit][end,:,1])

print(e[:payoffR][end,:,1])

print(g[:payoffR][end,:,1])




####################################################################
################### HOW DOES IT SPEARD #############################
using Plots.PlotMeasures

out = []
ngroups =2
for i in 0.5:.5:15
    c = cpr_abm(degrade = 1, n=100*ngroups, ngroups = ngroups, lattice = [1,2],
        max_forest = 1333*100*ngroups, tech = .00002, wages = 1, price = 3, nrounds = 1000, leak = false,
        limit_seed = [0,3], learn_group_policy =false, invasion = false, nsim = 1, experiment_punish2 =1, experiment_limit = i,
        experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = .0,
        full_save = true, genetic_evolution = false, glearn_strat = "income"
        )
    push!(out, c)
end


pay=[out[i][:payoffR][end,1,1] for i in 1:length(out)]
limit=[out[i][:limit][end,1,1] for i in 1:length(out)]

Threshold=plot(limit, pay, xlab = "Limit", ylab = "Payoff", c =:black)
vline!([3., 3.])
#
Trajedy=scatter(out[15][:harvestfull][500:1000,:,1], out[15][:payoffRfull][500:1000,:,1], label = "", c = :black, alpha = .2, xlab = "Harvest", ylab = "Payoff")


plot(out[1][:stock][:,:,1])
plot(out[15][:effort][:,:,1])


# plot(plot(c[:stock][:,:,1]), plot(c[:payoffR][:,:,1]))
p1 = plot(out[1][:stock][:,1,1], color = cgrad(:thermal, 15, rev = true, categorical = true)[1], xlab = "Time", ylab = "Resource Stock")
for i in 2:15 plot!(out[i][:stock][:,1,1],  color = cgrad(:thermal, 15, rev = true, categorical = true)[i]) end


p2 = plot(out[1][:payoffR][:,1,1], color = cgrad(:thermal, 15, rev = true, categorical = true)[1], xlab = "Time", ylab = "Payoff", ylim = (0,30))
for i in 2:15 plot!(out[i][:payoffR][:,1,1],  color = cgrad(:thermal, 15, rev = true, categorical = true)[i]) end

plot(p1, p2, Threshold, Trajedy, labels = "", width = 3, height  = 2, size = (1000, 350), bottom_margin = 20px, left_margin = 20px)


#######################################################
############### GET A LIST OF STOCK, AND LIMIT ########

stock = zeros(15)
limit = zeros(15)
effort = zeros(15)

for i in 1:15
 stock[i] =  out[i][:stock][end,1,1]
 effort[i] =  out[i][:effort][end,1,1]
 limit[i] = out[i][:limit][end,1,1]
end


ngroups = 30
test = cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [1,ngroups],
max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 3000, leak = false,
limit_seed = [0,5], learn_group_policy =false, invasion = true, nsim = 1,
experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = .03,
full_save = true, genetic_evolution = false, glearn_strat = "income", socialLearnYear = collect(1:10:5000), punish_cost = .3,
limit_seed_override = collect(range(.01, stop = 5, length = 30))
)

palette = "black"
plot(plot(test[:stock][:,:,1], title = "stock", c = palette), plot(test[:limit][:,:,1], title = "limit", c = palette),
plot(test[:payoffR][:,:,1], title = "payoff", c = palette), label = "", plot(test[:punish2][:,:,1], title = "punish2", c = palette))

m=Int.(test[:models][1:10:5000, :, 1 ])
m2 = copy(m)
for i in 1:500
    m2[i,:]= test[:gid][m[i,:]]
end

histogram(m2[400,:], bins = 30)


######################################################
################## TEST ###############################

ngroups = 20
test = cpr_abm(degrade = 1, n=75*ngroups, ngroups = ngroups, lattice = [1,ngroups],
max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 15000, leak = false,
learn_group_policy =false, invasion = true, nsim = 1,
experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = .01,
full_save = true, genetic_evolution = false, punish_cost = .1,
limit_seed_override = [fill(4, 10); fill(2, 10)])

using Plots
plot(test[:punish2][:,1,1], lw = 4, label = "")
plot!(test[:effort][:,1,1], lw = 4, label = "")
plot!(test[:stock][:,1,1], lw = 4, label = "")
plot!(test[:limit][:,1,1], lw = 4, label = "")
plot!(test[:limit][:,2,1], lw = 4, label = "")


plot(test[:stock][:,:,1], lw = 4, label = "")
plot(test[:limit][:,:,1], lw = 4, label = "")
plot(test[:payoffR][:,:,1], lw = 4, label = "")
plot(test[:effort][:,:,1], lw = 4, label = "")
plot(test[:harvest][:,:,1], lw = 4, label = "")
plot(test[:punish2][:,:,1], lw = 4, label = "")

corelpop=[cor(test[:payoffRfull][i,:,1], test[:limitfull][i,:,1]) for i in 1:15000]
corelinv=[[cor(test[:payoffRfull][i,test[:gid].==g,1], test[:limitfull][i,test[:gid].==g,1]) for i in 1:15000] for g in 1:20]
corelgroup = [cor(test[:payoffR][i,:,1], test[:limit][i,:,1]) for i in 1:15000]

corelpope=[cor(test[:payoffRfull][i,11:20,1], test[:effortfull][i,11:20,1]) for i in 1:15000]
corelinve=[[cor(test[:payoffRfull][i,test[:gid].==g,1], test[:effortfull][i,test[:gid].==g,1]) for i in 1:15000] for g in 1:20]
corelgroupe = [cor(test[:payoffR][i,11:20,1], test[:effort][i,11:20,1]) for i in 1:15000]

g=8
plot(plot(test[:stock][:,g,1]), plot(test[:punish2][:,g,1]))
plot(plot(corelinv[g], alpha = .05), plot(corelgroup, lw = 4, label = ""))

g =1
plot(plot(corelinve[g], alpha = .05), plot(corelgroupe, lw = 4, label = ""))
g =1
plot(plot(corelinve[g], alpha = .05), plot(corelgroupe, lw = 4, label = ""))

g = 17
corel=[cor(test[:payoffRfull][i,test[:gid].==g,1], test[:limitfull][i,test[:gid].==g,1]) for i in 1:15000]
plot(plot(corel, alpha = .05), plot(test[:stock][:,g,1], lw = 4, label = ""))
mean(Float64.(corel))

g=12
corel=[cor(test[:payoffRfull][i,test[:gid].==g,1], test[:punish2full][i,test[:gid].==g,1]) for i in 1:15000]
plot(plot(corel, alpha = .05), plot(test[:stock][:,g,1], lw = 4, label = ""))
mean(Float64.(corel))



G=load("Y:/eco_andrews/Projects/CPR/data/G1.jld2")["G"]
I=load("Y:/eco_andrews/Projects/CPR/data/I1.jld2")["I"]

a=plot(G[1], c = :orange, alpha = .2, label = "")
plot!(I[1], c = :violet, alpha = .2, label = "")

for i in 1:50
  plot!(G[i], c = :orange, alpha = .2, label = "")
  plot!(I[i], c = :violet, alpha = .2, label = "")
end 
a

P = [dat["out"][i][:punish2][14000:15000,:,1]] 


a=load("Y:/eco_andrews/Projects/CPR/data/test.jld2")["test"]

plot(a[1].p)
plot!(a[1].X)
plot!(a[1].x)

using GLM

x=[coef(lm(@formula(p ~ x + X), a[i]))[2] for i in 1:50]
X=[coef(lm(@formula(p ~ x + X), a[i]))[3] for i in 1:50]

scatter(x)
scatter!(X)


ngroups = 10
n = 30
ok2=cpr_abm(degrade = 1, n=30*ngroups, ngroups = ngroups, lattice = [1,ngroups],
max_forest = 1333*ngroups*n, tech = .00002, wages = 1, price = 3, nrounds = 3000, leak = true, regrow= .1,
learn_group_policy =false, invasion = true, nsim = 1, control_learning = false, back_leak = true, outgroup = .2,
full_save = true, genetic_evolution = false, limit_seed_override = collect(range(start = .1, stop = 5, length =ngroups)))




ngroups = 10
n = 30
ok2=cpr_abm(degrade = 1, n=30*ngroups, ngroups = ngroups, lattice = [1,ngroups],
max_forest = 1333*ngroups*n, tech = .00002, wages = 1, price = 3, nrounds = 3000, leak = true, regrow= .1,
learn_group_policy =false, invasion = true, nsim = 1, control_learning = false, back_leak = true, outgroup = .2,
full_save = true, genetic_evolution = true, limit_seed_override = collect(range(start = .1, stop = 5, length =ngroups)))


plot(plot(ok2[:stock][:,:,1], label = ""), plot(ok2[:leakage][:,:,1], label = ""), plot(ok2[:punish][:,:,1], label = ""), plot(ok2[:punish2][:,:,1], label = ""), plot(ok2[:limit][:,:,1], label = ""))



S = [collect(1:10), collect(11:20)]


@everywhere function g(a, b)
  addNumbers(a = a, b = b)
end

output=pmap(g, S[1], S[2])






function GetContextualSelection(data, x, X)
  out = []
  for k in 1:1
      df=data["out"][k]
      ngroups=size(df[X])[2]
      nrounds = size(df[X])[1]
      println(k)
      dat = DataFrame(p = mean(Float64.(df[x][2,:,1].-df[x][1,:,1])),
                      X = var(Float64.(df[X][1,:,1])),
                      x = mean([var(Float64.(df[x][1,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])
      )

      for i in 2:(nrounds-1)
          temp = DataFrame(p = mean(Float64.(df[x][i+1,:,1].-df[x][i,:,1])),
                      X = var(Float64.(df[X][i,:,1])),
                      x = mean([var(Float64.(df[x][i,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])    )

          append!(dat, temp)
      end
      push!(out,dat) 
  end
  return(out)
end






for i in each(readdir("phase_sweeps"))


  print("Current directory: ", pwd())
  for i in readdir("phase_sweeps")
    path = string("phase_sweeps/$i/output.jld2")
    a=load(path)
  end
  
  
  
    load(string(i))
  
  
  foreach(readdir("phase_sweeps")) do f
         println(readdir, f)
         #dump(stat(f)) # you can customize what you want to print
  end
  
  cnt = 1
  time  = []
  fname = []
  for f in readdir("phase_sweeps")
    c = round(S[cnt,1], digits =3)
    b = round(S[cnt,3], digits =3)
    pc = round(S[cnt, 2], digits =3)
    push!(time, mtime("phase_sweeps/$f"))
    push!(fname, f)  
    #new=string("sweep_pc", pc, "_b",b,"_c",c)
    #mv(string("phase_sweeps/$f"), new)
    #cnt=cnt+1
  end
  
  
  a=DataFrame(n = fname,
            t = time)
  
  
  stock = []
  regulate = []
  exclude = []
  limit = []
  
  for i in readdir("phase_sweeps")
    println(i)
    temp=load("phase_sweeps/$i/output.jld2")
    temp=temp["out"]
    push!(stock, mean([mean(temp[i][:stock][14400:15000, :, 1]) for i in 1:50]))
    push!(exclude, mean([mean(temp[i][:punish][14400:15000, :, 1]) for i in 1:50]))
    push!(regulate, mean([mean(temp[i][:punish2][14400:15000, :, 1]) for i in 1:50]))
    push!(limit, mean([mean(temp[i][:limit][14400:15000, :, 1]) for i in 1:50]))
  end
  save("limit.jld2", "out", limit)
  save("stock.jld2", "out", stock)
  save("exclude.jld2", "out", exclude)
  save("regulate.jld2", "out", regulate)
  
  
  reg=load("Y:/eco_andrews/Projects/CPR/data/regulate.jld2")
  exc=load("Y:/eco_andrews/Projects/CPR/data/exclude.jld2")
  lim=load("Y:/eco_andrews/Projects/CPR/data/limit.jld2")
  sto=load("Y:/eco_andrews/Projects/CPR/data/stock.jld2")
  
  
  plot(sto["out"])
  plot(exc["out"])
  plot(reg["out"])
  stom=reshape(sto["out"], 10, 10)
  excm=reshape(exc["out"], 10, 10)
  regm=reshape(reg["out"], 10, 10)
  limm=reshape(lim["out"], 10, 10)
  
  x = .13
  heatmap((excm .> x) .& (regm .> x))
  heatmap((excm .> x) .& (regm .< x))
  heatmap((excm .< x) .& (regm .> x))
  heatmap((excm .< x) .& (regm .< x))
  
  heatmap(excm)
  heatmap(regm)
    
    ngroups = 50
    max_forest = n*ngroups*1333
    limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups))

  a=cpr_abm(
    n = n*ngroups,
    max_forest = max_forest,
    ngroups =ngroups,
    nsim = 1,
    lattice = [5,10],
    limit_seed_override = limit_seed_override,
    pun2_on = true,
    leak=false,
    pun1_on = false,
    seized_on = false,
    experiment_group = [5,6],
    price = price,
    wages = wages,
    experiment_leak = L, 
    experiment_effort =1,
    control_learning = false,
    punish_cost = 0.1,
    tech = tech,
    outgroup = .9,
    invasion = true,
    nrounds = 1000,
    begin_leakage_experiment = 1)

  plot(a[:stock][:,:,1])
  plot(a[:punish2][:,:,1])
  



y1 = [mean(mean(dat[i][:punish2][900:1000,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y1)
μ = mean(a, dims = 2)
a=reduce(vcat, y1)
a=reduce(vcat, a)

p2 = []
l = []
for i in 1:19 
  for j in 1:50
    p2=[p2; reduce(vcat, mean(dat[i][j][:punish2][1900:2000,:,1], dims =1))]
    l=[l; reduce(vcat, mean(dat[i][j][:limit][1900:2000,:,1], dims =1))]
  end
end


p=plot(dat[1][1][:limit][:,:,1], label = "", c = :black, alpha = .02)
for i in 1:50 
  plot!(dat[1][i][:limit][:,:,1], label = "", c = :black, alpha = .02) 
end
p
hline!([3.33], c =:red)

sum([sum(dat[1][i][:limit][1000:2000,:,1] .> 3.33) for i in 1:50])
sum([sum(dat[19][i][:limit][1000:2000,:,1] .> 3.33) for i in 1:50])

scatter(p2, l, alpha = .1)



function g(b, c, pc, o)
  cpr_abm(degrade = 1, n=30*100,
  ngroups = 100,
  lattice = [10,10],
  max_forest = 1333*30*100,
  tech = .00002,
  wages = c,
  price = b,
  nrounds = 4000,
  leak = true,
  learn_group_policy =false,
  invasion = true,
  nsim = 1,
  inspect_timing = "after",
  punish_cost = pc,
  outgroup = o,
  full_save = false,
  genetic_evolution = false,
  #glearn_strat = "income",
  limit_seed_override = collect(range(start = .1, stop = 4, length =100)))
end    


a=g(3, 1, .01, .25)
b=g(3, 1, .01, .75)


plot(plot(a[:stock][:,:,1], label = ""), plot(b[:stock][:,:,1], label = ""))


using BenchmarkTools
using Profile
using Juno

@profile for i in 1:50 cpr_abm(ngroups = 100, lattice = [10, 10], n = 30*100, nrounds = 2) end
Profile.print()
Juno.profiler()
Profile.clear()

@profview cpr_abm(ngroups = 100, lattice = [10, 10], n = 30*100, nrounds = 2)


function profile_test(n)
  for i = 1:n
      A = randn(100,100,20)
      m = maximum(A)
      Am = mapslices(sum, A; dims=2)
      B = A[:,:,5]
      Bsort = mapslices(sort, B; dims=1)
      b = rand(100)
      C = B.*b
  end
end

using ProfileView
@profview profile_test(1)  # run once to trigger compilation (ignore this one)
@profview profile_test(10)




Inv=load("Y:/eco_andrews/Projects/CPR/data/Inv.jld2")["out"]
G=load("Y:/eco_andrews/Projects/CPR/data/G.jld2")["out"]

mean(mean(G))
mean(mean(Inv))
plot(G, c=:Red, label = false, ylim = (-50,50))
plot!(Inv, c=:Blue, label = false, ylim = (-50,50))
hline!([0])



function GetContextualSelection(data, x, X)
  out = []
  for k in 1:50
      df=data["out"][k]
      ngroups=size(df[X])[2]
      nrounds = size(df[X])[1]
      println(k)
      dat = DataFrame(p = mean(Float64.(df[x][2,:,1].-df[x][1,:,1])),
                      X = var(Float64.(df[X][1,:,1])),
                      x = mean([var(Float64.(df[x][1,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])
      )

      for i in 2:(nrounds-1)
          temp = DataFrame(p = mean(Float64.(df[x][i+1,:,1].-df[x][i,:,1])),
                      X = var(Float64.(df[X][i,:,1])),
                      x = mean([var(Float64.(df[x][i,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])    )

          append!(dat, temp)
      end
      push!(out,dat) 
  end
  return(out)
end




##################################################################
#################### SELECTION ###################################
dir = readdir(base_folder)[5]



function GetPriceSelection(data, x, X)
  out = []
  for k in 1:50
      println(k)
      df=data["out"][k]
      ngroups=size(df[X])[2]
      nrounds = size(df[X])[1]
      dat = DataFrame(p = mean(Float64.(df[x][5002,:,1].-df[x][1,:,1])),
                      X = var(Float64.(df[X][5001,:,1])),
                      x = mean([var(Float64.(df[x][5001,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])
      )

      for i in 5002:(nrounds-1)
          temp = DataFrame(p = mean(Float64.(df[x][i+1,:,1].-df[x][i,:,1])),
                      X = var(Float64.(df[X][i,:,1])),
                      x = mean([var(Float64.(df[x][i,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])    )
          append!(dat, temp)
      end
      dat.x = dat.x.-dat.X
      push!(out,dat) 
  end
  return out
end




function GetPricePayoff(data, x, X)
  Inv = []
  G = []
  for k in 1:50
      println(k)
      Inv_coefs = []
      G_coefs = []
      df=data["out"][k]
      nrounds=size(df[X])[1]
      ngroups=size(df[X])[2]
      for i in 5000:nrounds
          dat = DataFrame(Y = Float64.(df[:payoffRfull][i,:,1]),
                          X = Float64.(df[X][i,Int.(df[:gid][:,1,1]),1]),
                          x = Float64.(df[x][i,:,1]))
          dat.x .= dat.x.-dat.X
          a=lm(@formula(Y ~ x + X), dat)
          push!(Inv_coefs, coef(a)[2])
          push!(G_coefs, coef(a)[3]) 
      end
      push!(Inv, Inv_coefs)
      push!(G, G_coefs)
  end
  return[Inv, G]
end


LimP = []
LimS = []
RegP = []
RegS = []

base_folder = "outgroup_sweeps"
for dir in readdir(base_folder)
    dat=load(string("$base_folder/$dir/output.jld2"))
    println(dir)
    limit_payoff=GetPricePayoff(dat, :limitfull, :limit)
    limit_selection = GetPriceSelection(dat, :limitfull, :limit)
    reg_payoff = GetPricePayoff(dat, :punish2full, :punish)
    reg_selection = GetPriceSelection(dat, :punish2full, :punish)
    push!(LimP, limit_payoff)
    push!(LimS, limit_selection)
    push!(RegP, reg_payoff)
    push!(RegS, reg_selection)
end

#
save("LimP.jld2", "out", LimP) 
save("LimS.jld2", "out", LimS)
save("RegP.jld2", "out", RegP) 
save("RegS.jld2", "out", RegS)


LimP=load("Y:/eco_andrews/Projects/CPR/data/LimP.jld2")
LimS=load("Y:/eco_andrews/Projects/CPR/data/LimS.jld2")
REGP=load("Y:/eco_andrews/Projects/CPR/data/RegP.jld2")
REGS=load("Y:/eco_andrews/Projects/CPR/data/RegS.jld2")

using GLM

using GLM

a=[[coef(lm(@formula(p ~ x + X),LimS["out"][j][i])) for i in 1:50] for j in 1:11]

j=11
scatter([a[j][i][2] for i in 1:50], ylim=(-4, 4))
scatter!([a[j][i][3] for i in 1:50])
plot([median(a[i][1:end][3]) for i in 1:11])
plot!([median(a[i][1:end][2]) for i in 1:11])


a=[[[median(LimP["out"][j][k][i]) for i in 1:50] for k in 1:2] for j in 1:11]
q=plot()
for i in 1:11 scatter!(fill(i, 50).+rand(Uniform(0, 1),50), a[i][1], label = "", c = :black) end
q

for i in 1:11 scatter!(fill(i, 50).+rand(Uniform(0, 1),50), a[i][2], label = "", c = :red) end
q
plot!([median(a[i][2]) for i in 1:11], c=:blue, w=3)
plot!([median(a[i][1]) for i in 1:11], c = :orange, w=4)



#####################################################################
############### CHECK FOR WHEN STOCK IS OVER OR UNDER ###############
out = []
for j in 1:11
  a =[]
  print("I")
  k=1
  for i in 1:50
  #for k in 1:2
       temp = vec(median(STOCK["out"][j][i], dims = 1).<.5)
      ind=findall(temp .==1)
      if size(ind)[1] > 1 
        push!(a, median(LimP["out"][j][k][i][ind]))
      end
    end
    push!(out, a)
  end
  
end 

q = plot()
for i in 3:11
  scatter!(fill(i, 50).+rand(Uniform(0, 1),50), out[i], label = "", c = :black)
end
q

a=[[[median(LimP["out"][j][k][i]) for i in 1:50] for k in 1:2] for j in 1:11]
q=plot()
for i in 1:11 scatter!(fill(i, 50).+rand(Uniform(0, 1),50), a[i][1], label = "", c = :black) end
q

for i in 1:11 scatter!(fill(i, 50).+rand(Uniform(0, 1),50), a[i][2], label = "", c = :red) end
q
plot!([median(a[i][2]) for i in 1:11], c=:blue, w=3)
plot!([median(a[i][1]) for i in 1:11], c = :orange, w=4)








a=[[[median(REGP["out"][j][k][i]) for i in 1:50] for k in 1:2] for j in 1:11]

q=plot()
for i in 1:11 scatter!(fill(i, 50).+rand(Uniform(0, 1),50), a[i][1], label = "", c = :black) end
q

for i in 1:11 scatter!(fill(i, 50).+rand(Uniform(0, 1),50), a[i][2], label = "", c = :red) end
q

plot!([median(a[i][2]) for i in 1:11])
plot!([median(a[i][1]) for i in 1:11])


#############################################################
##################### SCRAPE OUT STOCKS #####################


Stock = []
Payoff = []
Punish2 = []
base_folder = "outgroup_sweeps"
for dir in readdir(base_folder)
    dat=load(string("$base_folder/$dir/output.jld2"))
    println(dir)
    ST=[dat["out"][i][:stock][5000:15000,:,1] for i in 1:50]
    P=[dat["out"][i][:payoffRfull][5000:15000,:,1] for i in 1:50]
    P2=[dat["out"][i][:punish2][5000:15000,:,1] for i in 1:50]
    push!(Stock, ST)
    push!(Payoff, P)
    push!(Punish2, P2)
end

save("STOCK_FULL.jld2", "out", Stock)
save("PAYOFF_FULL.jld2", "out", P)
save("PUNISH_FULL.jld2", "out", P2)



STOCK=load("Y:/eco_andrews/Projects/CPR/data/STOCK_FULL.jld2")
EXCLUDE=load("Y:/eco_andrews/Projects/CPR/data/PUNISH_FULL.jld2")

#################################################
########## WHEN STOCK IS ABOVE 5 ################

coefs = []
for j in 1:11
  println(string("j = $j"))
  out = []
  for i in 1:50
    println(string("i = $i"))
    isoverMSY = Int.(median(STOCK["out"][j][i][2:(end-1),:], dims = 2) .> .6)
    ind=findall(x->x==1, vec(isoverMSY))
    if size(ind)[1] > 1
      dat=LimS["out"][j][i][ind, :]
      a=coef(lm(@formula(p ~ x + X),dat))
      push!(out, a)
    else
      push!(out, nothing)
   end
  end
  push!(coefs, out)
end

x = []
for i in 1:11
  out = []
  println("i = $i")
  for j in 1:50 
    println("j = $j")
    if coefs[i][j] !== nothing
      println("got here")
      push!(out, coefs[i][j][2])
    end 
  end 
  push!(x, out)
end

q=plot()
for i in 1:11
  if any(x[i] .!== nothing)
    n=size(x[i])
    scatter!(fill(i, n).+rand(Uniform(0, .3),n), x[i], label = "", c = :black, alpha = .2)
  end
end

temp = []
for i in 1:11
  if all(x[i].== nothing)
    push!(temp, 0)
  else
    push!(temp, mean(x[i]))
  end
end
plot!(temp)


x = []
for i in 1:11
  out = []
  println("i = $i")
  for j in 1:50 
    println("j = $j")
    if coefs[i][j] !== nothing
      println("got here")
      push!(out, coefs[i][j][3])
    end 
  end 
  push!(x, out)
end

for i in 1:11
  if any(x[i] .!== nothing)
    n=size(x[i])
    scatter!(fill(i, n).+rand(Uniform(0, .3),n), x[i], label = "", c = :red, alpha = .2)
  end
end

temp = []
for i in 1:11
  if all(x[i].== nothing)
    push!(temp, 0)
  else
    push!(temp, mean(x[i]))
  end
end
plot!(temp)


hline!([0])




#################################################
########## WHEN STOCK IS BELOW 5 ################

coefs = []
for j in 1:11
  println(string("j = $j"))
  out = []
  for i in 1:50
    println(string("i = $i"))
    tempdat= median(STOCK["out"][j][i][2:(end-1),:], dims = 2)
    tempdat2= median(EXCLUDE["out"][j][i][2:(end-1),:], dims = 2)  
    isoverMSY = ((tempdat.< .5)  .& (tempdat .> .05) .& (tempdat2 .> .6))
      ind2 = 
    ind=findall(x->x==1, vec(isoverMSY))
    if size(ind)[1] > 1
      dat=LimS["out"][j][i][ind, :]
      a=coef(lm(@formula(p ~ x + X),dat))
      push!(out, a)
    else
      push!(out, nothing)
   end
  end
  push!(coefs, out)
end

x = []
for i in 1:11
  out = []
  println("i = $i")
  for j in 1:50 
    println("j = $j")
    if coefs[i][j] !== nothing
      println("got here")
      push!(out, coefs[i][j][2])
    end 
  end 
  push!(x, out)
end

q=plot()
for i in 1:11
  if any(x[i] .!== nothing)
    n=size(x[i])
    scatter!(fill(i, n).+rand(Uniform(0, .3),n), abs.(x[i]), label = "", c = :black, alpha = .2)
  end
end
q



x = []
for i in 1:11
  out = []
  println("i = $i")
  for j in 1:50 
    println("j = $j")
    if coefs[i][j] !== nothing
      println("got here")
      push!(out, coefs[i][j][3])
    end 
  end 
  push!(x, out)
end

for i in 1:11
  if any(x[i] .!== nothing)
    n=size(x[i])
    scatter!(fill(i, n).+rand(Uniform(0, .3),n), abs.(x[i]), label = "", c = :red, alpha = .2, ylim = (0, 3))
  end
end
q
hline!([0])

mean(abs.(x))










function GetPriceSelection(data, x, X)
  out = []
  for k in 1:50
      println(k)
      df=data["out"][k]
      ngroups=size(df[X])[2]
      nrounds = size(df[X])[1]
      dat = DataFrame(p = mean(Float64.(df[x][5002,:,1].-df[x][1,:,1])),
                      X = var(Float64.(df[X][5001,:,1])),
                      x = mean([var(Float64.(df[x][5001,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])
      )

      for i in 5002:(nrounds-1)
          temp = DataFrame(p = mean(Float64.(df[x][i+1,:,1].-df[x][i,:,1])),
                      X = var(Float64.(df[X][i,:,1])),
                      x = mean([var(Float64.(df[x][i,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])    )
          append!(dat, temp)
      end
      dat.x = dat.x.-dat.X
      push!(out,dat) 
  end
  return out
end
