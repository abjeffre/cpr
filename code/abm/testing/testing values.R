nsim = 1                  # Number of simulations per call
nrounds = 1000             # Number of rounds per generation
n = 600                    # Size of the population
ngroups = 2               # Number of Groups in the population
lattice = c(2, 1)          # This controls the dimensions of the lattice that the world exists on

mortality_rate = 0.03      # The number of deaths per 100 people
mutation = 0.01            # Rate of mutation on traits

wages = .25               # Wage rate in other sectors - opportunity costs
wage_growth = FALSE        # Do wages grow?
wgrowth_rate =.0001        # this is a fun parameter we know that the average growth rate for preindustiral societies is 0.2% per year why not let wages grow and see what happens  
labor_market = FALSE       # This controls labor market competition
market_size = 1            # This controls the demand for labor in the population and is exogenous: Note that when set to 1 the wage rate equilibrates when half the population is in the labor force

max_forest = 1000           # Average max stock
var_forest = 50            # Controls the heterogeneity in forest size across diffrent groups
degradability = 0          # This measures how degradable a resource is(when invasion the resource declines linearly with size and as it increase it degrades more quickly if negative it decreases the rate of degredation) degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
regrow = .001               # the regrowth rate
tech = 1                  # Used for scaling Cobb Douglas production function
labor = .5                 # The elasticity of labor on harvesting production
price = 1                  # This sets the price of the resource on the market
necessity = 0              # This sets the minimum amount of the good the household requires

inst = TRUE                # Toggles whether or not punishment is active
monitor_tech = 1           # This controls the efficacy of monitnoring higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i 1 x) 0 5) where i is the proportion of monitors in a pop 
defensibility = 15          # This sets the minmum number of people needed 
punish_cost = 0.001        # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs 
fine = 0                 # This controls the size of the fine issued when caught note that in a real world situation this could be recouped by the injured parties but it is not
self_policing = TRUE      # Toggles if Punishers also target members of their own ingroup for harvesting over limit
harvest_limit = 0.8        # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate

travel_cost =0.1           # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
groups_sampled = 3         # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes                


social_learning = TRUE     # Toggels whether Presitge Biased Tranmission is on
nmodels = 3                # The number of models sampled to copy from in social learning
fidelity = 0.01            # This is the fidelity of social transmission
learn_type = "income"      # Two Options - "wealth" and "income" indiviudals can choose to copy wealth or income if copy wealth they copy total overall payoffs if copy income they copy payoffs from the previous round 
outgroup = 0.1             # This is the probability that the individual samples from the whole population and not just his group when updating

REDD = FALSE                # This controls whether or not the natural experiment REDD+ is on if REDD is on INST must be on 
REDD_dates = 300           # This can either be an int or vector of dates that development initative try and seed insitutions
law = .1                   # This controls sustainable harvesting limit when REDD+ is introduced
num_cofma = 1              # This controls the number of Groups that will be converted to CoFMA
cofma_gid = NULL           # This allows you to choose the group id - specificy a spatial identity for the ward that becomes protected.  
marginal = FALSE           # NOT CURRENTLY OPPERATIONAL   # This controls whether payoffs have are marginally decreasing in value
marginal_rate = 0.5        # this is the rate of diminishing marginal returns
leak = TRUE

experiment_leak =.5
experiment_punish =c(.5)
experiment_effort =FALSE
experiment_limt = FALSE