using DataFrames
using Statistics
using Distributions
using Random
using Distributions
using StatsBase
include("submodules/SplitGroupsTest.jl")
include("submodules/SocialTransmission.jl")
include("submodules/ResourceDynamics.jl")
include("submodules/MutateAgents.jl")
include("submodules/MakeBabies.jl")
include("submodules/KillAgents.jl")
include("submodules/GetSeizedPay.jl")
include("submodules/GetPollution.jl")
include("submodules/GetPolicy.jl")
include("submodules/GetPatch.jl")
include("submodules/GetModels.jl")
include("submodules/GetAgHarvest.jl")
include("submodules/GetInspection.jl")
include("submodules/GetIndvHarvest.jl")
include("submodules/GetHarvest.jl")
include("submodules/GetGroupHarvest.jl")
include("submodules/GetGroupSeized.jl")
include("submodules/GetFinesPay.jl")
include("submodules/GetEcoSysServ.jl")
include("submodules/TransferWealth.jl")

function cpr_abm(
  ;nsim = 1,                    # Number of simulations per call
  nrounds = 500,               # Number of rounds per generation
  n = 300,                     # Size of the population
  ngroups = 2,                 # Number of Groups in the population
  lattice = (1, 2),             # This controls the dimensions of the lattice that the world exists on
  mortality_rate = 0.03,      # The number of deaths per 100 people
  mutation = 0.01,            # Rate of mutation on traits
  wages = .1,                   # Wage rate in other sectors - opportunity costs
  max_forest = 350000,               # Average max stock
  var_forest = 0,                   # Controls athe heterogeneity in forest size across diffrent groups
  degrade = [1,1],                # This measures how degradable a resource is(when zero the resource declines linearly with size and as it increase it degrades more quickly, if negative it decreases the rate of degredation), degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
  regrow = .01,                     # the regrowth rate
  volatility = 0,                 #the volatility of the resource each round - set as variance on a normal
  pollution = false,
  pol_slope = .1,                 # As the slope increases the rate at which pollution increases as the resource declines increase
  pol_C = .1,                    # As the constant increases the total amount of polution increases
  ecosys = false,
  eco_slope = 1,                 # As the slope increases the resource will continue to produce ecosystem servies
  eco_C = .01,                    # As the constant increases the total net benifit of the ecosystem services increases
  tech = 1,                     # Used for scaling Cobb Douglas production function
  labor = .7,                   # The elasticity of labor on harvesting production
  price = 1,                    # This sets the price of the resource on the market
  nsectors = 3,
  necessity = 0,                # This sets the minimum amount of the good the household requires
  inst = true,                  # Toggles whether or not punishment is active
  monitor_tech = [1,1],             # This controls the efficacy of monitnoring, higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i, 1, x), 0, 5), where i is the proportion of monitors in a pop
  defensibility = 1,            # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
  def_perc = true,              # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
  punish_cost = 0.1,           # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs
  fine = 0.0,                   # This controls the size of the fine issued when caught, note that in a real world situation this could be recouped by the injured parties but it is not
  self_policing = true,         # Toggles if Punishers also target members of their own ingroup for harvesting over limit
  harvest_limit = 5,         # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
  harvest_var = 1.5,
  pun2_on = true,
  pun1_on = true,
  seized_on = true,
  fines_evolve = true,
  fines1_on = true,
  fines2_on = true,
  fine_start = 1,               #Determine mean fine value for all populations at the beginiing SET TO NOHTING TO TURN OFF
  fine_var = .2,                #Determines the group offset for fines at the begining
  distance_adj =0.9,            # This affects the proboabilty of sampling a more close group.
  travel_cost = .00,            # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
  groups_sampled = 1,           # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes
  social_learning = true,       # Toggels whether Presitge Biased Tranmission is on
  nmodels = 3,                  # The number of models sampled to copy from in social learning
  fidelity = 0.02,              # This is the fidelity of social transmission
  learn_type = "income",        # Two Options - "wealth" and "income" indiviudals can choose to copy wealth or income if copy wealth they copy total overall payoffs, if copy income they copy payoffs from the previous round
  outgroup = 0.01,              # This is the probability that the individual samples from the whole population and not just his group when updating0...
  baseline = .01,                # Baseline payoff to be added each round -
  invade = true,
  REDD = false,                 # This controls whether or not the natural experiment REDD+ is on, if REDD is on INST must be on
  leak = true,                  # This controls whether individuals are able to move into neightboring territory to harvest
  verbose = false,              # verbose reporting for debugging
  seed = 1984,
  og_on = false,                  # THe evolution of listening to outgroup members.
  experiment_leak = false,              #THIS SETS THE VALUE OF THE OTHER GROUP LEAKAGE and Punish
  experiment_punish1 = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_punish2 = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_limit = false,             #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_effort = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_group = 1,                 #determines the set of groups which the experiment will be run on
  cmls = false,                          #determines whether cmls will operate
  zero = false,
  glearn_strat = false,              # options: "wealth", "income", "env"
  split_method = "random",
  kmax_data = nothing,
  back_leak = false,
  fines_on = false,
  inspect_timing = nothing,
  inher = false,
  tech_data = nothing,
  harvest_type = "individual",
  policy_weight = "equal",       #typically takes wealth as a weight, but can take any-data that can be used to rank people.
  rec_history =  false,            # You can record the history of wealth but it is costly. 
  resource_zero = false,
  harvest_zero = false,
  wealth_degrade = nothing,
  agPrice = 1,                        # Price of agricultural goods. 
  agDegrade = [1,1],                   # This controls how ag output scales with availible farm land. 
  market_absorbtion = nothing         #THIS IS HOW WELL THE MARKET CAN ABSORB LABOR uses BETA CDF
)
  ################################################
  ##### The multiverse will be recorded  #########
   history=Dict(
     :stock => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :effort => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :limit => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :leakage => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :og => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :harvest => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :punish => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :punish2 => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :fine1 => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :fine2 =>convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :effortLeak => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :effortNoLeak => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :harvestLeak => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :harvestNoLeak => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :payoffR => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :age_max => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :seized => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :seized2 => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :forsize =>  convert.(Float16, zeros(ngroups, nsim)),
     :cel =>  convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :clp2 => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :cep2 => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :ve => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :vp2 => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :vl => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :roi => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :fstEffort => convert.(Float16, zeros(nrounds, nsim)),
     :fstLimit => convert.(Float16, zeros(nrounds, nsim)),
     :fstLeakage => convert.(Float16, zeros(nrounds, nsim)),
     :fstPunish => convert.(Float16, zeros(nrounds, nsim)),
     :fstPunish2 => convert.(Float16, zeros(nrounds, nsim)),
     :fstFine1 => convert.(Float16, zeros(nrounds, nsim)),
     :fstFine2 => convert.(Float16, zeros(nrounds, nsim)),
     :fstOg => convert.(Float16, zeros(nrounds, nsim)),
     :agHarvest => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :agEffort => convert.(Float16, zeros(nrounds, ngroups, nsim)),
     :wealth => Float16[],
     :wealthgroups => Float16[]
     )

     if rec_history == true
      history[:wealth] = convert.(Float16, zeros(n, nrounds, nsim))
      history[:wealthgroups] = convert.(Float16, zeros(n, nrounds, nsim))
      history[:age] = convert.(Float16, zeros(n, nrounds, nsim))
    end




# #Store Parameters for Sweep Verification
#   para = Dict(
#     :wages=>wages,
#     :max_forest => max_forest,
#     :var_forest => var_forest,
#     :degrade => degrade,
#     :regrow => regrow,
#     :pol_slope => pol_slope,
#     :pol_C => pol_C,
#     :volatility => volatility,
#     :eco_slope => eco_slope,
#     :eco_C => eco_C,
#     :tech => tech,
#     :labor => labor,
#     :price => price,
#     :necessity => necessity,
#     :monitor_tech => monitor_tech,
#     :defensibility => defensibility,
#     :punish_cost => punish_cost,
#     :fine =>  fine,
#     :mortality_rate => mortality_rate,
#     :mutation => mutation,
#     :harvest_limit => harvest_limit,         # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
#     :harvest_var => harvest_var,
#     :fine_var => fine_var,
#     :fine_var => fine_var,
#     :distance_adj => distance_adj,
#     :fidelity => fidelity,
#     :outgroup => outgroup,
#     :baseline => baseline
#     )
#     #Store Feature Configuration for Parameter Sweeps.
#   feat = Dict(
#     :labor_market => labor_market,
#     :pollution => pollution,
#     :ecosys => ecosys,
#     :inst => inst,
#     :def_perc => def_perc,
#     :self_policing => self_policing,
#     :pun2_on => pun2_on,
#     :pun1_on => pun1_on,
#     :seized_on => seized_on,
#     :fines1_on => fines1_on,
#     :fines2_on => fines2_on,
#     :social_learning => social_learning,
#     :learn_type => learn_type,
#     :invade => invade,
#     :REDD => REDD,
#     :leak => leak,
#     :og_on => og_on,
#     :experiment_leak => experiment_leak,
#     :experiment_punish1 => experiment_punish1,
#     :experiment_punish2 => experiment_punish2,
#     :experiment_limit => experiment_effort,
#     :experiment_limit => experiment_limit,
#     :cmls => cmls,
#     :zero => zero,
#     :glearn_strat => glearn_strat,
#   )


  ##############################
  ####Start Simulations #######
  for sim = 1:nsim
      seed = seed + sim

    #############################
    #### EXPERIMENT SETUP #######
    # if experiment_leak==0  experiment_leak = false end
    # if experiment_punish1==0  experiment_punish1 = false end
    # if experiment_limit==0  experiment_limit = false end
    # if experiment_effort==0   experiment_effort = false end
    # if experiment_punish2==0   experiment_punish2 = false end
    if (((experiment_limit == false && experiment_leak == false) &&
        experiment_punish1== false) && experiment_effort ==false) && experiment_punish2==false
        experiment = false
      else
        experiment = true
    end

    #############################
    ##### Create the world ######

    world =  A = reshape(collect(1:ngroups), lattice[1], lattice[2])
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

    resource_zero == true ?  K = rand(ngroups).+1 : nothing
    

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
    temp = ones(nsectors)
    if zero == true
          temp[1] = 100-nsectors
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
      traits.harv_limit[agents.gid.==i] = abs.(rand(Normal(temp[i], .5), gs_init))
    end
    # Fines
    if fine_start !== nothing
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

    if verbose ==true println(string("Sim: ", sim, ", Initiation: COMPLETED ")) end

    ############################################
    ############# Begin years ##################

    year = 1
    REDD_happened = false
    REDD_year = 0


    for t ∈ 1:nrounds
      agents.payoff_round = zeros(n)
      ########Impose Restrictions #######
      if leak == false  traits.leakage_type = zeros(n) end
      if pun1_on == false  traits.punish_type = zeros(n) end
      if pun2_on == false  traits.punish_type2 = zeros(n) end
      if fines1_on == false traits.fines1 = zeros(n)end
      if fines2_on == false traits.fines2 = zeros(n)end
      if og_on == false traits.og_type = zeros(n)end
      if tech_data  !== nothing tech = tech_data[year] end

      ############################
      ### RUN EXPERIMENT #########
      for i = 1:length(experiment_group)
        if experiment_leak != 0
          traits.leakage_type[agents.gid .== experiment_group[i]] = rbinom(sum(agents.gid.==experiment_group[i]),1, experiment_leak)
        end
        if experiment_punish1 != 0
          traits.punish_type[agents.gid .==experiment_group[i]] .= experiment_punish1
        end
        if experiment_punish2 != 0
          traits.punish_type2[agents.gid .==experiment_group[i]] .= experiment_punish2
        end
        if experiment_limit !=0
          traits.harv_limit[agents.gid .==experiment_group[i]] .=experiment_limit
        end
        if experiment_effort != 0
          effort[agents.gid.==experiment_group[i], 2] .= experiment_effort
          effort[agents.gid.==experiment_group[i], 1] .= (1-experiment_effort)
        end
      end
      if verbose== true print(string("Experiment: COMPLETED"))
      end
     

      #Politics
      groups.limit=GetPolicy(traits.harv_limit, policy_weight, agents.payoff, ngroups, agents.gid, groups.group_status, t)
      if fines_evolve == true
        groups.fine1=GetPolicy(traits.fines1, policy_weight, agents.payoff, ngroups, agents.gid, groups.group_status, t)
        groups.fine2=GetPolicy(traits.fines2, policy_weight, agents.payoff, ngroups, agents.gid, groups.group_status, t)
      else
        groups.fine1 = ones(ngroups).*fine 
        groups.fine2 = ones(ngroups).*fine 
      end
     
      #Patch Selection
      loc=GetPatch(ngroups, agents.gid, groups.group_status, distances, distance_adj,
                traits.leakage_type, K, groups_sampled, experiment, experiment_group, back_leak)
      TC=travel_cost.*traits.leakage_type
      #randomize each round
      if inspect_timing == nothing
        catch_before = sample([true, false])
      else
       if inspect_timing == "before" catch_before = true end
       if inspect_timing == "after" catch_before = false end
       end
      
      
      #Harvesting
      if catch_before == true
        temp_hg = zeros(n)
        caught1=GetInspection(temp_hg, traits.punish_type, loc, agents.gid, groups.limit, monitor_tech, groups.def, "nonlocal")
        temp_effort = effort[:,2] .* (1 .-caught1)
        if harvest_type == "collective"
          GH=GetGroupHarvest(temp_effort, loc, K, kmax, tech, labor, degrade, ngroups)
          HG=GetIndvHarvest(GH, temp_effort, loc, necessity, ngroups)
        else
          HG=GetHarvest(temp_effort, loc, K, kmax, tech, labor, degrade, necessity, ngroups)
          GH=reportSum(HG, loc, ngroups)
        end
      else
        if harvest_type == "collective"
          GH=GetGroupHarvest(effort[:,2], loc, K, kmax, tech, labor, degrade, ngroups)
          HG=GetIndvHarvest(GH, effort[:,2], loc, necessity, ngroups)
        else
          HG=GetHarvest(effort[:,2], loc, K, kmax, tech, labor, degrade, necessity, ngroups)
          GH=reportSum(HG, loc, ngroups)
        end
      end


      #Monitoring, Seizure and Fines
      if catch_before == false  
        caught1=GetInspection(HG, traits.punish_type, loc, agents.gid, groups.limit, monitor_tech, groups.def, "nonlocal") 
      end
      caught2=GetInspection(HG, traits.punish_type2, loc, agents.gid, groups.limit, monitor_tech, groups.def, "local")
      caught_sum = caught1 + caught2
      if catch_before == true  
        seized1=GetGroupSeized(caught1, caught1, loc, ngroups) 
      else
        seized1=GetGroupSeized(HG, caught1, loc, ngroups) #REVERT
      end
      seized2=GetGroupSeized(HG, caught2, loc, ngroups)
      SP1=GetSeizedPay(seized1, traits.punish_type, agents.gid, ngroups)
      SP2=GetSeizedPay(seized2, traits.punish_type2, agents.gid, ngroups)
      FP1=GetFinesPay(SP1, groups.fine1, agents.gid, ngroups)
      FP2=GetFinesPay(SP2, groups.fine2, agents.gid, ngroups)
      MC1 = punish_cost*traits.punish_type
      MC2 = punish_cost*traits.punish_type2
      if seized_on == false SP2 = SP1 = zeros(n) end
      if fines_on == false FP2 = FP1 = zeros(n) end
      if catch_before == true SP1 .=0 end

      #EcoSystem Public Goods
      ecosys ? ECO =  GetEcoSysServ(ngroups, eco_slope, eco_C, K, kmax) :  ECO = zeros(n)
      pollution ? POL =  GetPollution(effort[:,2], loc, ngroups, pol_slope, pol_C, K, kmax) : POL = zeros(n)


      #Wage Labor Market
      market_absorbtion !== nothing ? current_wages = (1-cdf.(Beta(market_absorbtion[1], market_absorbtion[2]), 
                                                            sum(effort[:,3])/n))*wages : current_wages = copy(wages)
      
      WL = current_wages*(effort[:,3].*100)*tech
    
      #Agricultural Production
      AG = GetAgHarvest(effort[:,1], agents.gid, K, kmax, tech, labor, agDegrade, necessity, ngroups).*agPrice
      # If you want collective ag enable
      #     GetAgHarvest2(effort[:,1], agents.gid, K, kmax, tech, labor, agDegrade, necessity, ngroups)
      
       

      #Calculate agents.payoffs
      agents.payoff_round = HG .*(1 .- caught_sum).*price +
      WL + AG + SP1.*price + SP2.*price + FP1.*price + FP2.*price -
      MC1 - MC2 - TC- POL[agents.gid] + ECO[agents.gid] - 
      ifelse(catch_before == true, (caught1).*groups.fine1[loc], HG .*(caught1).*groups.fine1[loc]) -
       HG .*(caught2).*groups.fine2[agents.gid] 

      agents.payoff += agents.payoff_round .+ baseline
      agents.payoff_round[isnan.(agents.payoff_round)] .=0
      agents.payoff[isnan.(agents.payoff)] .=0

      if verbose == true
        println("harvest, ", sum(isnan.(HG.*(1 .- caught_sum))))
        println("sg_og, ", sum(isnan.(SP1)))
        println("sg_ig, ", sum(isnan.(SP2)))
        println("fp_ig, ", sum(isnan.(FP1)))
        println("fp_og, ", sum(isnan.(FP1)))
        println("travel_cost:", sum(isnan.(TC)))
        println("wl, ", sum(isnan.(WL)))
        println("mc1,", sum(isnan.(MC1)))
        println("mc2,", sum(isnan.(MC2)))
        println("pol,", sum(isnan.(POL)))
        println("eco,", sum(isnan.(ECO)))
      end



      ################################################
      ########### ECOSYSTEM DYNAMICS #################

      K=ResourceDynamics(GH, K, kmax, regrow, volatility, ngroups, harvest_zero)


      #################################################
      ############# RECORD HISTORY ####################
        history[:stock][year,:,sim] .= convert.(Float16, K./kmax)
        history[:effort][year,:,sim] .=convert.(Float16,report(effort[:,2], agents.gid, ngroups))
        history[:limit][year,:,sim] .= convert.(Float16,reportMedian(traits.harv_limit, agents.gid, ngroups))
        history[:leakage][year,:,sim] .= convert.(Float16,report(traits.leakage_type,agents.gid, ngroups))
        history[:og][year,:,sim] .= convert.(Float16,report(traits.og_type,agents.gid, ngroups))
        history[:harvest][year,:,sim] .= convert.(Float16,report(HG,agents.gid, ngroups))
        history[:punish][year,:,sim]  .= convert.(Float16,report(traits.punish_type,agents.gid, ngroups))
        history[:punish2][year,:,sim]  .= convert.(Float16,report(traits.punish_type2,agents.gid, ngroups))
        history[:fine1][year,:,sim] .= convert.(Float16,reportMedian(traits.fines1, agents.gid, ngroups))
        history[:fine2][year,:,sim]  .= convert.(Float16,reportMedian(traits.fines2, agents.gid, ngroups))
        #history[:effortLeak][year,:,sim] .= convert.(Float16,report(effort[traits.leakage_type.==1, 2], agents.gid[traits.leakage_type.==1], ngroups))
        #history[:effortNoLeak][year,:,sim] .= convert.(Float16,report(effort[traits.leakage_type.==0, 2], agents.gid[traits.leakage_type.==1], ngroups))
        #history[:harvestLeak][year,:,sim] .= convert.(Float16,report(HG[traits.leakage_type.==1], agents.gid[traits.leakage_type.==1], ngroups))
        #history[:harvestNoLeak][year,:,sim] .= convert.(Float16,report(HG[traits.leakage_type.==0], agents.gid[traits.leakage_type.==1], ngroups))
        history[:payoffR][year,:,sim] .= convert.(Float16,report(agents.payoff_round,agents.gid, ngroups))
        history[:age_max][year,:,sim] => convert.(Float16,report(agents.age,agents.gid, ngroups))
        history[:seized][year,:,sim] .=  convert.(Float16,reportSum(SP1, agents.gid, ngroups))
        history[:seized2][year,:,sim] .= convert.(Float16,reportSum(SP2, agents.gid, ngroups))
        history[:forsize][:,sim] .= kmax
        history[:cel][year,:,sim] .=  convert.(Float16,reportCor(effort[:,2], traits.harv_limit,agents.gid, ngroups))
        history[:clp2][year,:,sim] .= convert.(Float16,reportCor(effort[:,2], traits.punish_type2,agents.gid, ngroups))
        history[:cep2][year,:,sim] .= convert.(Float16,reportCor(traits.harv_limit, traits.punish_type2,agents.gid, ngroups))
        history[:ve][year,:,sim] .= convert.(Float16,reportVar(effort[:,2],agents.gid, ngroups))
        history[:vp2][year,:,sim] .= convert.(Float16,reportVar(traits.punish_type2,agents.gid, ngroups))
        history[:vl][year,:,sim] .= convert.(Float16,reportVar(traits.harv_limit,agents.gid, ngroups))
        history[:fstEffort][year,sim] = convert.(Float16, GetFST(effort[:,2], agents.gid, ngroups, experiment_group, experiment))
        history[:fstLimit][year,sim]  = convert.(Float16,GetFST(traits.harv_limit, agents.gid, ngroups, experiment_group, experiment))
        history[:fstLeakage][year,sim]   = convert.(Float16,GetFST(traits.leakage_type, agents.gid, ngroups, experiment_group, experiment))
        history[:fstPunish][year,sim]   = convert.(Float16,GetFST(traits.punish_type, agents.gid, ngroups, experiment_group, experiment))
        history[:fstPunish2][year,sim]  = convert.(Float16,GetFST(traits.punish_type2, agents.gid, ngroups, experiment_group, experiment))
        history[:fstFine1][year,sim]  = convert.(Float16,GetFST(traits.fines1, agents.gid, ngroups, experiment_group, experiment))
        history[:fstFine2][year,sim]  = convert.(Float16,GetFST(traits.fines2, agents.gid, ngroups, experiment_group, experiment))
        history[:fstOg][year,sim]  = convert.(Float16,GetFST(traits.og_type, agents.gid, ngroups, experiment_group, experiment))
        history[:agHarvest][year,:,sim] .= convert.(Float16,report(AG,agents.gid, ngroups))
        history[:agEffort][year,:,sim] .=convert.(Float16,report(effort[:,1], agents.gid, ngroups))
        if rec_history == true 
              history[:wealth][:,year,sim]  = convert.(Float16,agents.payoff)
              history[:wealthgroups][:,year,sim]  = convert.(Float16,agents.gid)
              history[:age][:,year,sim]  = convert.(Float16,agents.age) 
        end
   
         
   
        #################################################
      ########### SOCIAL LEARNING #####################


    if social_learning == true

      #Set Up group rankings
      if glearn_strat == "income" gmean=AnalyticWeights(report(agents.payoff_round, agents.gid, ngroups)) end
      if glearn_strat == "wealth" gmean=AnalyticWeights(report(agents.payoff, agents.gid, ngroups)) end
      if glearn_strat == "env" gmean=AnalyticWeights(K./kmax) end
      if glearn_strat == "random" gmean=AnalyticWeights(ones(ngroups))end
      if glearn_strat == false gmean=AnalyticWeights(ones(ngroups))end
      if experiment== true
      #  if length(experiment_group)==1 gmean[experiment_group]=0 end  #this ensures all learning happens not from the experimental group.
      #  if length(experiment_group)>1 gmean[experiment_group].=0 end
      end

      out = zeros(n)
      #Determine if individuals learn from outgroup or ingroup.
      if og_on == false
        out = rbinom(n, 1, outgroup)
      else
        for i in 1:n
          out[i] = rbinom(1,1, traits.og_type[i])[1]
        end
      end

      models=GetModels(agents, ngroups, gmean, nmodels, out, learn_type, glearn_strat)
      traits=SocialTransmission(traits, models, fidelity, traitTypes)
      effort=SocialTransmission(effort, models, fidelity, "Dirichlet")
    end


      #########################################
      ############# GENERAL UPDATING ##########
      agents.age .+= 1

      ####################################
      ###### Evolutionary dynamics #######
      #println(agents.payoff)
      agents.payoff_round[agents.payoff_round.<=0] .=0
      agents.payoff[agents.payoff.<=0] .=0
      sample_payoff = ifelse.(agents.payoff .!=0, agents.payoff, 0.0001)
      if experiment==true
        pop = agents.id[agents.gid .∈  [experiment_group]]
        died =  KillAgents(pop, agents.id, agents.age, mortality_rate, sample_payoff)
        babies = MakeBabies(pop, agents.id, sample_payoff, died)
        traits[babies,:]=MutateAgents(traits[babies, :], mutation, traitTypes)
        effort[babies, :]=MutateAgents(effort[babies, :], mutation, "Dirichlet")
        if inher == true
          GetChildList(babies, died, children)
          agents.payoff = DistributWealth(died, agents.payoff, children)
          for i in 1:length(died) children[died[i]] = Vector{Int64}[] end #remove children
        end
        agents.payoff[died] .= 0
        agents.age[died]  .= 0
        
        #Non-experimental Group
        sample_payoff = ifelse.(agents.payoff .!=0, agents.payoff, 0.0001)
        pop = agents.id[agents.gid .∉  [experiment_group]]
        died =  KillAgents(pop, agents.id, agents.age, mortality_rate, sample_payoff)
        babies = MakeBabies(pop, agents.id, sample_payoff, died)
        traits[babies,:]=MutateAgents(traits[babies, :], mutation, traitTypes)
        effort[babies, :]=MutateAgents(effort[babies, :], mutation, "Dirichlet")
        if inher == true
          GetChildList(babies, died, children)
          agents.payoff = DistributWealth(died, agents.payoff, children)
          for i in 1:length(died) children[died[i]] = Vector{Int64}[] end #remove children
        end
        agents.payoff[died] .= 0
        agents.age[died]  .= 0
        if cmls == true  agents.gid[died] = agents.gid[babies] end
      else
        died =  KillAgents(agents.id, agents.id, agents.age, mortality_rate, sample_payoff)
        babies = MakeBabies(agents.id, agents.id, sample_payoff, died)
        if inher == true
          GetChildList(babies, died, children)
          agents.payoff = DistributWealth(died, agents.payoff, children)
          for i in 1:length(died) children[died[i]] = Vector{Int64}[] end #remove children
        end
        traits[babies,:]=MutateAgents(traits[babies, :], mutation, traitTypes)
        effort[babies, :]=MutateAgents(effort[babies, :], mutation, "Dirichlet")
        agents.payoff[died] .= 0
        agents.age[died]  .= 0
        if cmls == true  agents.gid[died] = agents.gid[babies] end
       end


      #############################################
      ############ GROUP DEATH AND SPLITTING ######
      #When one group gets so small that they will be absorbed entirely by other groups,
      #Then the remaining individuals are distributed evenly amongst other groups and the largest group will fission.
      #The fissioning can have diffrent rules by which this happens, a. Random, b. split according to policy beleifs. just get the median and split down the middle.
      if cmls == true
      agents.gid=SplitGroups(agents.gid, groups, nmodels, agents.id, traits, split_method)
      end

      ############################################
      ############ WEALTH DYNAMICS ###############

      wealth_degrade !== nothing ? agents.payoff = agents.payoff .* wealth_degrade : nothing

      #
      year += 1
    end #End the year
  end #End Sims
  return(history)
end#End Function
