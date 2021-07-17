versioninfo()
    #generate fake data for the testing of sub units - this should be expanded to have a set of trails and loops through them. 

    include("C:\\Users\\jeffr\\Documents\\work\\functions\\utility.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\SplitGroups.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\SocialTransmission.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\ResourceDynamics.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\MutateAgents.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\MakeBabies.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\KillAgents.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetSeizedPay.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetPollution.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetHarvest.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetPolicy.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetPatch.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetModels.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetInspection.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetIndvHarvest.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetGroupHarvest.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetGroupSeized.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetFinesPay.jl")
    include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\submodules\\GetEcoSysServ.jl")
    


    nsim = 4                     # Number of simulations per call
    nrounds = 500                # Number of rounds per generation
    n = 300                      # Size of the population
    ngroups = 2                  # Number of Groups in the population
    lattice = (1, 2)              # This controls the dimensions of the lattice that the world exists on
    mortality_rate = 0.03       # The number of deaths per 100 people
    mutation = 0.01             # Rate of mutation on traits
    wages = .1                    # Wage rate in other sectors - opportunity costs
    wage_data = nothing 
    labor_market = false          # This controls labor market competition
    market_size = 1               # This controls the demand for labor in the population and is exogenous: Note that when set to 1 the wage rate equilibrates when half the population is in the labor force
    max_forest = 15000                # Average max stock
    var_forest = 1                    # Controls athe heterogeneity in forest size across diffrent groups
    degrade = [1 1]                 # This measures how degradable a resource is(when zero the resource declines linearly with size and as it increase it degrades more quickly  if negative it decreases the rate of degredation)  degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
    regrow = .01                      # the regrowth rate
    volatility = 0                  #the volatility of the resource each round - set as variance on a normal
    pollution = false 
    pol_slope = .1                  # As the slope increases the rate at which pollution increases as the resource declines increase
    pol_C = .1                     # As the constant increases the total amount of polution increases
    ecosys = false 
    eco_slope = 1                  # As the slope increases the resource will continue to produce ecosystem servies
    eco_C = .01                     # As the constant increases the total net benifit of the ecosystem services increases
    tech = 1                      # Used for scaling Cobb Douglas production function
    labor = .7                    # The elasticity of labor on harvesting production
    price = 1                     # This sets the price of the resource on the market
    ngoods = 2 
    necessity = 0                 # This sets the minimum amount of the good the household requires
    inst = true                   # Toggles whether or not punishment is active
    monitor_tech = [1, 1]              # This controls the efficacy of monitnoring  higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i  1  x)  0  5)  where i is the proportion of monitors in a pop
    defensibility = 1             # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
    def_perc = true               # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
    punish_cost = 0.001            # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs
    fine = 0.0                    # This controls the size of the fine issued when caught  note that in a real world situation this could be recouped by the injured parties but it is not
    self_policing = true          # Toggles if Punishers also target members of their own ingroup for harvesting over limit
    harvest_limit = 0.25          # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
    harvest_var = .07 
    pun2_on = true 
    pun1_on = true 
    seized_on = true 
    fines_evolve = false 
    fines1_on = false 
    fines2_on = false 
    fine_start = .1                #Determine mean fine value for all populations at the beginiing SET TO NOHTING TO TURN OFF
    fine_var = .02                 #Determines the group offset for fines at the begining
    distance_adj =0.9             # This affects the proboabilty of sampling a more close group.
    travel_cost = .00             # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
    groups_sampled = 1            # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes
    social_learning = true        # Toggels whether Presitge Biased Tranmission is on
    nmodels = 3                   # The number of models sampled to copy from in social learning
    fidelity = 0.02               # This is the fidelity of social transmission
    learn_type = "income"         # Two Options - "wealth" and "income" indiviudals can choose to copy wealth or income if copy wealth they copy total overall payoffs  if copy income they copy payoffs from the previous round
    outgroup = 0.01               # This is the probability that the individual samples from the whole population and not just his group when updating0...
    baseline = .01                 # Baseline payoff to be added each round -
    invade = true 
    REDD = false                  # This controls whether or not the natural experiment REDD+ is on  if REDD is on INST must be on
    REDD_dates = 300              # This can either be an int or vector of dates that development initative try and seed insitutions
    law = .1                      # This controls sustainable harvesting limit when REDD+ is introduced
    num_cofma = 1                 # This controls the number of Groups that will be converted to CoFMA
    cofma_gid = nothing           # This allows you to choose the group id - specificy a spatial identity for the ward that becomes protected.
    leak = true                   # This controls whether individuals are able to move into neightboring territory to harvest
    verbose = false               # verbose reporting for debugging
    seed = 1984 
    og_on = true                   # THe evolution of listening to outgroup members.
    experiment_leak = false               #THIS SETS THE VALUE OF THE OTHER GROUP LEAKAGE and Punish
    experiment_punish1 = false             #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
    experiment_punish2 = false             #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
    experiment_limit = false              #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
    experiment_effort = false             #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
    experiment_group = 1                  #determines the set of groups which the experiment will be run on
    cmls = false                           #determines whether cmls will operate
    zero = false 
    power = false 
    glearn_strat = false               # options: "wealth"  "Income"
    split_method = "random" 
    kmax_data = nothing 
    back_leak = false 
    fines_on = false 
    inspect_timing = nothing 
    inher = false 
    tech_data = nothing 
    harvest_type = "individual" 
    policy_weight = "equal"


    world =  A = reshape(collect(1:ngroups),  lattice[1],  lattice[2])
    distances = distance(world)

    #make the forests and DIVIDE them amongst the groups
    if kmax_data !== nothing
      kmax = kmax_data
      K = copy(kmax)

    else
    #  Random.seed(seed)
      kmax = rand(Normal(max_forest, var_forest), ngroups)/ngroups
      kmax[kmax .< 0] .=max_forest/ngroups
      K = copy(kmax)
    end


    ################################
    ### Give birth to humanity #####

    gs_init = convert(Int64, n/ngroups)
    # agent values
    agents = DataFrame(
      id = collect(1:n),
      gid = repeat(1:ngroups, gs_init),
      payoff = zeros(n),
      payoff_round = zeros(n),
      age = sample(1:2, n, replace=true) #notice a small variation in age is necessary for our motrality risk measure
      )
    #All trait minus effort
    traits = DataFrame(
      leakage_type = zeros(n),
      punish_type = zeros(n),
      punish_type2 = zeros(n),
      fines1 = zeros(n),
      fines2 = zeros(n),
      harv_limit = zeros(n),
      og_type = zeros(n))

    traitTypes = ["binary" "prob" "prob" "positivecont" "positivecont" "positivecont" "prob"]

    # Set up Array To contain Family history
    children = Vector{Int}[]
    for i in 1:n push!(children, Vector{Int}[]) end
    #Effort as seperate DF
    temp = ones(ngoods)
    if zero == true
          temp[1] = 100-ngoods
          effort = rand(Dirichlet(temp), n)'
          effort=DataFrame(Matrix(effort), :auto)
    else
          temp=temp*2
          effort = rand(Dirichlet(temp), n)'
          effort=DataFrame(Matrix(effort), :auto)
      end
      # Setup leakage
    leak_temp =zeros(gs_init)
    leak_temp[1:asInt(ceil(gs_init/2))].=1 #50% START AS LEAKERS
    for i = 1:ngroups
    Random.seed!(seed+i+2+ngroups)
      traits.leakage_type[agents.gid.==i] = sample(leak_temp, gs_init)
    end
    # Setup punishment
    for i = 1:ngroups
      Random.seed!(seed+(i)+2+(ngroups*2))
      traits.punish_type2[agents.gid.==i] = rand(Beta(1, (1/.1-1)), gs_init) # the denominator in the beta term determines the mean
      Random.seed!(seed+(i*2)+2+(ngroups*2))
      traits.punish_type[agents.gid.==i] = rand(Beta(1, (1/.1-1)), gs_init) # the denominator in the beta term determines the mean
    end
    #Setup Harvest Limit
    Random.seed!(seed+2)
    temp=abs.(rand(Normal(harvest_limit, harvest_var), ngroups))
    for i in 1:ngroups
      Random.seed!(seed+i+2)
      traits.harv_limit[agents.gid.==i] = abs.(rand(Normal(temp[i], .03), gs_init))
    end
    # Fines
    if fine_start != nothing
      Random.seed!(seed+20)
      temp=abs.(rand(Normal(fine_start, fine_var), ngroups))
      for i in 1:ngroups
        Random.seed!(seed+i+20)
        traits.fines1[agents.gid.==i] = abs.(rand(Normal(temp[i], .03), gs_init))
      end
      Random.seed!(seed+21)
      temp=abs.(rand(Normal(fine_start, fine_var), ngroups))
      for i in 1:ngroups
        Random.seed!(seed+i+21)
        traits.fines2[agents.gid.==i] = abs.(rand(Normal(temp[i], .03), gs_init))
      end
    end
    # Outgroup learn
    Random.seed!(seed+56)
    if zero == true
        traits.og_type = rand(Beta(1,10), n)
      else
        traits.og_type  = inv_logit.(rnorm(n,logit(.5), .15)) #THIS STARTS AROUND 50%
    end

    #Define Groups
    groups = DataFrame(gid = collect(1:ngroups),
                        fine1 = zeros(ngroups),
                        fine2 = zeros(ngroups),
                        limit = zeros(ngroups),
                        group_status = ones(ngroups),
                        def = zeros(ngroups))

    #set defensibility
      def = zeros(ngroups)
      for i in 1:ngroups
         if def_perc==true
            groups.def[i] = gs_init/defensibility
          else
            groups.def[i] =defensibility
          end
        end

#################################################################################################
############# NABASE LINE DATA ##################################################################

#####################################################################
########### TESTS ####################################################


function getBaseline()
    cpr_abm(
    ngroups = 2,
    n = 150*2,
    tech = .02,
    wages = .1,
    price = 1,
    max_forest=10000*2,
    nrounds = 10000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[1,2],
    var_forest = 0,
    travel_cost = .00001,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    seized_on = false,
    fines_on = false,
    fines1_on = false,
    fines_evolve = false,
    fines2_on = false,
    verbose = false,
    pun1_on = false,
    pun2_on =false,
    leak = false,
    zero = true,
    og_on = false,
    fine_start = .1,
    fine_var = .2,
    glearn_strat = "income",
    monitor_tech = [1,1],
    harvest_type = "individual",
    policy_weight = "equal",
    learn_type = "income"
)
end


plot(test[]:stock][:,:,1], ylim = [0,1])
