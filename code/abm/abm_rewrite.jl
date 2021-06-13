using DataFrames
using Statistics
using Distributions
using Random
using Distributions
using StatsBase

function cpr_abm(
  ;nsim = 1,                    # Number of simulations per call
  nrounds = 2000,               # Number of rounds per generation
  n = 3000,                     # Size of the population
  ngroups = 20,                 # Number of Groups in the population
  lattice = (4, 5),             # This controls the dimensions of the lattice that the world exists on
  mortality_rate = 0.03,      # The number of deaths per 100 people
  mutation = 0.01,            # Rate of mutation on traits
  wages = .1,                   # Wage rate in other sectors - opportunity costs
  wage_growth = false,          # Do wages grow?
  wgrowth_rate =.0001,          # this is a fun parameter, we know that the average growth rate for preindustiral societies is 0.2% per year why not let wages grow and see what happens
  labor_market = false,         # This controls labor market competition
  market_size = 1,              # This controls the demand for labor in the population and is exogenous: Note that when set to 1 the wage rate equilibrates when half the population is in the labor force
  max_forest = 16500,               # Average max stock
  var_forest = 1,                   # Controls athe heterogeneity in forest size across diffrent groups
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
  necessity = 0,                # This sets the minimum amount of the good the household requires
  inst = true,                  # Toggles whether or not punishment is active
  monitor_tech = [1,1],             # This controls the efficacy of monitnoring, higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i, 1, x), 0, 5), where i is the proportion of monitors in a pop
  defensibility = 1,            # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
  def_perc = true,              # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
  punish_cost = 0.001,           # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs
  fine = 0.0,                   # This controls the size of the fine issued when caught, note that in a real world situation this could be recouped by the injured parties but it is not
  self_policing = true,         # Toggles if Punishers also target members of their own ingroup for harvesting over limit
  harvest_limit = 0.25,         # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
  harvest_var = .07,
  pun2_on = true,
  pun1_on = true,
  seized_on = true,
  fines1_on = false,
  fines2_on = false,
  fine_start = .1,               #Determine mean fine value for all populations at the beginiing SET TO NOHTING TO TURN OFF
  fine_var = .02,                #Determines the group offset for fines at the begining
  distance_adj =0.9,            # This affects the proboabilty of sampling a more close group.
  travel_cost = .00,            # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
  groups_sampled = 3,           # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes
  social_learning = true,       # Toggels whether Presitge Biased Tranmission is on
  nmodels = 3,                  # The number of models sampled to copy from in social learning
  fidelity = 0.02,              # This is the fidelity of social transmission
  learn_type = "income",        # Two Options - "wealth" and "income" indiviudals can choose to copy wealth or income if copy wealth they copy total overall payoffs, if copy income they copy payoffs from the previous round
  outgroup = 0.01,              # This is the probability that the individual samples from the whole population and not just his group when updating0...
  baseline = .01,                # Baseline payoff to be added each round -
  invade = true,
  REDD = false,                 # This controls whether or not the natural experiment REDD+ is on, if REDD is on INST must be on
  REDD_dates = 300,             # This can either be an int or vector of dates that development initative try and seed insitutions
  law = .1,                     # This controls sustainable harvesting limit when REDD+ is introduced
  num_cofma = 1,                # This controls the number of Groups that will be converted to CoFMA
  cofma_gid = nothing,          # This allows you to choose the group id - specificy a spatial identity for the ward that becomes protected.
  leak = true,                  # This controls whether individuals are able to move into neightboring territory to harvest
  verbose = false,              # verbose reporting for debugging
  seed = 1984,
  og_on = true,                  # THe evolution of listening to outgroup members.
  experiment_leak = false,              #THIS SETS THE VALUE OF THE OTHER GROUP LEAKAGE and Punish
  experiment_punish1 = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_punish2 = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_limit = false,             #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_effort = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_group = 1,                 #determines the set of groups which the experiment will be run on
  cmls = false,                          #determines whether cmls will operate
  zero = false,
  power = false,
  glearn_strat = false              # options: "wealth", "Income"
)


  ################################################
  ##### The multiverse will be recorded  #########
   history=Dict(
     :stock => zeros(nrounds, ngroups, nsim),
     :effort => zeros(nrounds, ngroups, nsim),
     :limit => zeros(nrounds, ngroups, nsim),
     :leakage => zeros(nrounds, ngroups, nsim),
     :og => zeros(nrounds, ngroups, nsim),
     :harvest => zeros(nrounds, ngroups, nsim),
     :punish => zeros(nrounds, ngroups, nsim),
     :punish2 => zeros(nrounds, ngroups, nsim),
     :fine1 => zeros(nrounds, ngroups, nsim),
     :fine2 =>zeros(nrounds, ngroups, nsim),
     :effortLeak => zeros(nrounds, ngroups, nsim),
     :effortNoLeak => zeros(nrounds, ngroups, nsim),
     :harvestLeak => zeros(nrounds, ngroups, nsim),
     :harvestNoLeak => zeros(nrounds, ngroups, nsim),
     :payoffR => zeros(nrounds, ngroups, nsim),
     :age_max => zeros(nrounds, ngroups, nsim),
     :seized => zeros(nrounds, ngroups, nsim),
     :seized2 => zeros(nrounds, ngroups, nsim),
     :forsize =>  zeros(nrounds, ngroups, nsim),
     :cel =>  zeros(nrounds, ngroups, nsim),
     :clp2 => zeros(nrounds, ngroups, nsim),
     :cep2 => zeros(nrounds, ngroups, nsim),
     :ve => zeros(nrounds, ngroups, nsim),
     :vp2 => zeros(nrounds, ngroups, nsim),
     :vl => zeros(nrounds, ngroups, nsim),
     :roi => zeros(nrounds, ngroups, nsim),
     :fstEffort => zeros(nrounds, nsim),
     :fstLimit => zeros(nrounds, nsim),
     :fstLeakage => zeros(nrounds, nsim),
     :fstPunish => zeros(nrounds, nsim),
     :fstPunish2 => zeros(nrounds, nsim),
     :fstFine1 => zeros(nrounds, nsim),
     :fstFine2 => zeros(nrounds, nsim),
     :fstOg => zeros(nrounds, nsim)
     )


#Store Parameters for Sweep Verification
  para = Dict(
    :wages=>wages,
    :max_forest => max_forest,
    :var_forest => var_forest,
    :degrade => degrade,
    :regrow => regrow,
    :pol_slope => pol_slope,
    :pol_C => pol_C,
    :volatility => volatility,
    :eco_slope => eco_slope,
    :eco_C => eco_C,
    :tech => tech,
    :labor => labor,
    :price => price,
    :necessity => necessity,
    :monitor_tech => monitor_tech,
    :defensibility => defensibility,
    :punish_cost => punish_cost,
    :fine =>  fine,
    :mortality_rate => mortality_rate,
    :mutation => mutation,
    :harvest_limit => harvest_limit,         # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
    :harvest_var => harvest_var,
    :fine_var => fine_var,
    :fine_var => fine_var,
    :distance_adj => distance_adj,
    :fidelity => fidelity,
    :outgroup => outgroup,
    :baseline => baseline
    )
    #Store Feature Configuration for Parameter Sweeps.
  feat = Dict(
    :labor_market => labor_market,
    :pollution => pollution,
    :ecosys => ecosys,
    :inst => inst,
    :def_perc => def_perc,
    :self_policing => self_policing,
    :pun2_on => pun2_on,
    :pun1_on => pun1_on,
    :seized_on => seized_on,
    :fines1_on => fines1_on,
    :fines2_on => fines2_on,
    :social_learning => social_learning,
    :learn_type => learn_type,
    :invade => invade,
    :REDD => REDD,
    :leak => leak,
    :og_on => og_on,
    :experiment_leak => experiment_leak,
    :experiment_punish1 => experiment_punish1,
    :experiment_punish2 => experiment_punish2,
    :experiment_limit => experiment_effort,
    :experiment_limit => experiment_limit,
    :cmls => cmls,
    :zero => zero,
    :power => power,
    :glearn_strat => glearn_strat,
  )


  ##############################
  ####Start Simulations #######
  for sim = 1:nsim
      seed = seed + sim

    #############################
    #### EXPERIMENT SETUP #######
    if experiment_leak==0  experiment_leak = false end
    if experiment_punish1==0  experiment_punish1 = false end
    if experiment_limit==0  experiment_limit = false end
    if experiment_effort==0   experiment_effort = false end
    if experiment_punish2==0   experiment_punish2 = false end
    if (((experiment_limit == 0 && experiment_leak == 0) &&
        experiment_punish1== false) && experiment_effort ==false) && experiment_punish2==0
        experiment = false
      else
        experiment = true
    end

    #############################
    ##### Create the world ######

    world =  A = reshape(collect(1:ngroups), lattice[1], lattice[2])
    distances = distance(world)

    #make the forests and DIVIDE them amongst the groups
    if var_forest == "binary"
      half = convert(Int64, ceil(ngroups/2))
      kmax = ones(ngroups)*(max_forest/ngroups)
      kmax[1:convert(Int64, ceil(ngroups/2))] = fill(ceil(max_forest/ngroups/2), half)
      Random.seed!(seeded)
      if experiment == FALSE
        kmax = sample(kmax, length(kmax) )
      else
        reverse(kmax)
      end
    else
    #  Random.seed(seed)
      kmax = rand(Normal(max_forest, var_forest), ngroups)/ngroups
    end
    kmax[kmax .< 0] .=max_forest/ngroups
    K = copy(kmax)

    ################################
    ### Give birth to humanity #####

    gs_init = convert(Int64, n/ngroups)
    # agent values
    agents = DataFrame(
      id = collect(1:n),
      gid = repeat(1:ngroups, gs_init),
      payoff = zeros(n),
      payoff_round = zeros(n)
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

    #Effort as seperate DF
    temp = ones(ngoods)
    temp[1] = 100-ngoods
    effort = rand(Dirichlet(temp), n)'
    effort=DataFrame(Matrix(effort), :auto)
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
    #Age
    Random.seed!(seed)
    agents.age = sample(18:19, n, replace=true) #notice a small variation in age is necessary for our motrality risk measure
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
          traits.effort[agents.gid.==experiment_group[i]] .= experiment_effort
        end
      end
      if verbose== true print(string("Experiment: COMPLETED"))
      end

      #Politics
      groups.limit=GetPolicy(traits.harv_limit, "equal", agents.payoff, ngroups, agents.gid, groups.group_status, t)
      groups.fine1=GetPolicy(traits.fines1, "equal", agents.payoff, ngroups, agents.gid, groups.group_status, t)
      groups.fine2=GetPolicy(traits.fines2, "equal", agents.payoff, ngroups, agents.gid, groups.group_status, t)

      #Patch Selection
      loc=GetPatch(ngroups, agents.gid, groups.group_status, distances, distance_adj,
                traits.leakage_type, K, groups_sampled, experiment, experiment_group)
      TC=travel_cost.*traits.leakage_type

      # Harvesting
      GH=GetGroupHarvest(effort[:,2], loc, K, kmax, tech, labor, degrade)
      HG=GetIndvHarvest(GH, effort[:,2], loc, necessity, ngroups)

      #Monitoring, Seizure and Fines
      caught1=GetInspection(HG, traits.punish_type, loc, agents.gid, groups.limit, monitor_tech, groups.def, "nonlocal")
      caught2=GetInspection(HG, traits.punish_type2, loc, agents.gid, groups.limit, monitor_tech, groups.def, "local")
      caught_sum = caught1 + caught2
      seized1=GetGroupSeized(HG, caught1, loc, ngroups)
      seized2=GetGroupSeized(HG, caught2, loc, ngroups)
      SP1=GetSeizedPay(seized1, traits.punish_type, agents.gid, ngroups)
      SP2=GetSeizedPay(seized2, traits.punish_type2, agents.gid, ngroups)
      FP1=GetFinesPay(SP1, groups.fine1, agents.gid, ngroups)
      FP2=GetFinesPay(SP2, groups.fine2, agents.gid, ngroups)
      MC1 = punish_cost*traits.punish_type
      MC2 = punish_cost*traits.punish_type2

      #EcoSystem Public Goods
      ECO =  GetEcoSysServ(ngroups, eco_slope, eco_C, K, kmax)
      POL =  GetPollution(effort[:,2], loc, ngroups, pol_slope, pol_C, K, kmax)

      #Wage Labor Market
      WL = wages*effort[:,1]

      #Calculate agents.payoffs
      agents.payoff_round = HG .*(1 .- caught_sum).*price
       + WL + SP1.*price + SP2.*price + FP1.*price + FP2.*price -
      MC1 - MC2 - TC- POL[agents.gid] + ECO[agents.gid]

      agents.payoff += agents.payoff_round .+ baseline
      agents.payoff_round[isnan.(agents.payoff_round)] .=0
      agents.payoff[isnan.(agents.payoff)] .=0

      if verbose == true
        println("harvest, ", sum(isnan.(hg.*(1 .- caught3))))
        println("sg_og, ", sum(isnan.(punish_type)))
        println("sg_ig, ", sum(isnan.(sg_ig[gid].*(punish_type2./p2_tot[gid]))))
        println("fp_ig, ", sum(isnan.(fp_ig[gid].*(punish_type2./p2_tot[gid]))))
        println("fp_og, ", sum(isnan.(punish_type)))
        println("travel_cost:", sum(isnan.(travel_cost.*leakage_type)))
        println("wl, ", sum(isnan.(wl)))
        println("mc1,", sum(isnan.(mc1)))
        println("mc2,", sum(isnan.(mc2)))
        println("pol,", sum(isnan.(pol[gid])))
        println("eco,", sum(isnan.(eco[gid])))
      end



      ################################################
      ########### ECOSYSTEM DYNAMICS #################
      
      K=ResourceDynamics(GH, K, k_max, regrow, volatility, ngroups)


      #################################################
      ############# RECORD HISTORY ####################
        history[:stock][year,:,sim] .=round.(K./kmax, digits=3)      
        history[:effort][year,:,sim] .=round.(report(effort[:,2], agents.gid, ngroups), digits=2)
        history[:limit][year,:,sim] .= round.(reportMedian(traits.harv_limit, gid, ngroups), digits=2)
        history[:leakage][year,:,sim] .= round.(report(traits.leakage_type, gid, ngroups), digits=2)
        history[:og][year,:,sim] .= round.(report(traits.og_type, gid, ngroups), digits=2)
        history[:harvest][year,:,sim] .= round.(report(HG, gid, ngroups), digits=2)
        history[:punish][year,:,sim]  .= round.(report(traits.punish_type, gid, ngroups), digits=2)
        history[:punish2][year,:,sim]  .= round.(report(traits.punish_type2, gid, ngroups), digits=2)
        history[:fine1][year,:,sim] .= round.(reportMedian(traits.fine1, gid, ngroups), digits=2)
        history[:fine2][year,:,sim]  .= round.(reportMedian(traits.fine2, gid, ngroups), digits=2)
        history[:effortLeak][year,:,sim] .= round.(report(effort[agents.leakage_type.==1, 2], agents.gid[agents.leakage_type.==1], ngroups), digits=2)
        history[:effortNoLeak][year,:,sim] .= round.(report(effort[agents.leakage_type.==0, 2], agents.gid[agents.leakage_type.==1], ngroups), digits=2)
        history[:harvestLeak][year,:,sim] .= round.(report(HG[agents.leakage_type.==1, 2], agents.gid[agents.leakage_type.==1], ngroups), digits=2)
        history[:harvestNoLeak][year,:,sim] .= round.(report(HG[agents.leakage_type.==0, 2], agents.gid[agents.leakage_type.==1], ngroups), digits=2)
        history[:payoffR][year,:,sim] .= round.(report(agents.payoff_round, gid, ngroups), digits=2)
        history[:age_max][year,:,sim] => round.(report(agents.age, gid, ngroups), digits=2)
        history[:seized][year,:,sim] .=  round.(tab(SP1, ngroups), digits =2)
        history[:seized2][year,:,sim] .= round.(tab(SP2, ngroups), digits =2)
        history[:forsize][sim] .= kmax
        history[:cel][year,:,sim] =>  round.(reportCor(effort, harv_limit, gid, ngroups), digits=3)
        history[:clp2][year,:,sim] => round.(reportCor(effort, punish_type2, gid, ngroups), digits=3)
        history[:cep2][year,:,sim] => round.(reportCor(harv_limit, punish_type2, gid, ngroups), digits=3)
        history[:ve][year,:,sim] => round.(reportVar(punish_type2, gid, ngroups), digits=3)
        history[:vp2][year,:,sim] => round.(reportVar(harv_limit, gid, ngroups), digits=3)
        history[:vl][year,:,sim] => round.(reportVar(effort, gid, ngroups), digits=3)
        history[:fstEffort][year,sim] .= round.(reportVar(effort[:,2], agents.gid, ngroups), digits=2)./var(effort[:,2])
        history[:fstLimit][year,sim]  .= round.(reportVar(traits.harv_limit, agents.gid, ngroups), digits=2)./var(traits.harv_limit)
        history[:fstLeakage][year,sim]  .= round.(reportVar(traits.leakge_type, agents.gid, ngroups), digits=2)./var(traits.leakge_type)
        history[:fstPunish][year,sim]  .= round.(reportVar(traits.punish_type, agents.gid, ngroups), digits=2)./var(traits.punish_type)
        history[:fstPunish2][year,sim] .= round.(reportVar(traits.punish_type2, agents.gid, ngroups), digits=2)./var(traits.punish_type2)
        history[:fstFine1][year,sim] .= round.(reportVar(traits.fines1, agents.gid, ngroups), digits=2)./var(traits.fines1)
        history[:fstFine2][year,sim] .= round.(reportVar(traits.fines2, agents.gid, ngroups), digits=2)./var(traits.fines2)
        history[:fstOg][year,sim] .= round.(reportVar(traits.og_type, agents.gid, ngroups), digits=2)./var(traits.og_type_type)

      #################################################
      ########### SOCIAL LEARNING #####################


    if social_learning == true

      #Set Up group rankings
      if glearn_strat == "income" gmean=AnalyticWeights(report(payoff_round, gid, ngroups)) end
      if glearn_strat == "wealth" gmean=AnalyticWeights(report(payoff, gid, ngroups)) end
      if glearn_strat == "env" gmean=AnalyticWeights(K./kmax) end
      if glearn_strat == "random" gmean=AnalyticWeights(ones(ngroups))end
      if glearn_strat == false gmean=AnalyticWeights(ones(ngroups))end
      if length(experiment_group)==1 gmean[experiment_group]=0 end  #this ensures all learning happens not from the experimental group.
      if length(experiment_group)>1 gmean[experiment_group].=0 end
      temp = findall(x->x==0, groups.group_status) #remove dead groups
      gmean[temp] .=0


      out = zeros(n)
      #Determine if individuals learn from outgroup or ingroup.
      if og_on == false
        out = rbinom(n, 1, outgroup)
      else
        for i in 1:n
          out[i] = rbinom(1,1, traits.og_type[i])[1]
        end
      end

      models=GetModels(agents, ngroups, gmean, nmodels, out)
      traits=SocialTransmission(traits, models, fidelity, traitTypes)
      

      #########################################
      ############# GENERAL UPDATING ##########
      agents.age .+= 1
      
      ####################################
      ###### Evolutionary dynamics #######
      
      agents.payoff_round[agents.payoff_round.<=0] .=0
      agents.payoff[agents.payoff.<=0] .=0
      sample_payoff = ifelse.(agents.payoff .!=0, agents.payoff, 0.0001)

      if experiment==true
        pop = agents.id[agents.gid .∈  [experiment_group]]
        died =  KillAgents(pop, agents.id, agents.age, mortality_rate, sample_payoff)
        babies = MakeBabies(pop, agents.id, sample_payoff, died)
        traits[babies,:]=MutateAgents(traits[babies, :], mutation, traitTypes)
        #ADD IN ERROR AND DIRECHLET
        payoff[died] .= 0
        age[died]  .= 0
        #Non-experimental Group
        pop = agents.id[agents.gid .∉  [experiment_group]]
        died =  KillAgents(pop, agents.id, agents.age, mortality_rate, sample_payoff)
        babies = MakeBabies(pop, agents.id, sample_payoff, died)
        traits[babies,:]=MutateAgents(traits[babies, :], mutation, traitTypes)
        #ADD IN ERROR AND DIRECHLET
        payoff[died] .= 0
        age[died]  .= 0
        if cmls == true  agents.gid[died] = agents.gid[babies] end
      else
        died =  KillAgents(agents.id, agents.id, agents.age, mortality_rate, sample_payoff)
        babies = MakeBabies(agents.id, agents.id, sample_payoff, died)
        traits[babies,:]=MutateAgents(traits[babies, :], mutation, traitTypes)
        #ADD IN ERROR AND DIRECHLET
        payoff[died] .= 0
        age[died]  .= 0  
        if cmls == true  agents.gid[died] = agents.gid[babies] end
      end


      #############################################
      ############ GROUP DEATH AND SPLITTING ######
      #When one group gets so small that they will be absorbed entirely by other groups, 
      #Then the remaining individuals are distributed evenly amongst other groups and the largest group will fission.
      #The fissioning can have diffrent rules by which this happens, a. Random, b. split according to policy beleifs. just get the median and split down the middle.
      agents.gid=SplitGroups(agents.gid, groups, nmodels, id, traits, split_method)

      year += 1  
    end #End the year
    ry[sim] = REDD_year
  end #End Sims
end#End Function
