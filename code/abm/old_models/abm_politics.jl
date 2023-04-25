
using StatsBase, StatsFuns

# DO NOT CHANGE THIS MODEL BECAUSE IT IS PERFECTION

function killagents(pop, id, age, mortality_rate, sample_payoff)
    if  length(unique(age[pop])) == 1
        age[pop] .=age[pop].+rand(0:1, length(age[pop]))
    end
    mortality_risk = softmax(standardize2(age[pop].^5.5) .- standardize2(sample_payoff[pop].^.25))
    to_die = asInt(round(mortality_rate*length(pop), digits =0))
    died = rand(1:300, to_die)
    died=wsample(pop, sample_payoff[pop], to_die, replace = false)
    return(died)
end


function makebabies(pop, id, sample_payoff, died)
    sample_payoff[died] .=0
    sample_payoff[(id) .∉ Ref(pop)] .=0
    babies=wsample(id, sample_payoff, length(died), replace = true)
    return(babies)
end

function mutateagent(x, mutationrate, type, subpop = nothing)
  subpop == nothing ? n = length(x) : n =  length(x[subpop])
  trans_error = rand(n) .< mutationrate
  if subpop == nothing subpop = collect(1:n) end


    if type == "binary"
      out = ifelse.(trans_error, ifelse.(x[subpop].==1,0,1), x[subpop])
    end
    if type == "prob"
      n_error = rand(Normal(), n)
      out = ifelse.(trans_error, inv_logit.(logit.(x[subpop]) .+ n_error), x[subpop])
    end
    if type == "positivecont"
      n_error = rand(Normal(1, .02), n)
      out = ifelse.(trans_error, x[subpop].*n_error, x[subpop])
    end
    if type == "cont"
      n_error = rand(Normal(), n)
      out = ifelse.(trans_error, x[subpop].+n_error, x[subpop])
    end
    if subpop != nothing
       x[subpop] = out
       out = x
     end
    return(out)
  end



#
#
# function makebabies(pop, id, pay,died)
#         sample_payoff = ifelse.(pay .!=0, pay, 0.000001)
#         pos_parents = id[(id .∈ Ref(pop)) .== (id .∉ Ref(died))]
#         pos_payoff = convert.(Float64, vec(sample_payoff[pos_parents]))
#         #return(pos_parents, pos_payoff, length(died))
#         babies =wsample(pos_parents, pos_payoff, length(died), replace = true)
#         return(babies)
#     end


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
  degrade = [1,1],                # This measures how degradable a resource is(when invasion the resource declines linearly with size and as it increase it degrades more quickly, if negative it decreases the rate of degredation), degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
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
  marginal = false,             # NOT CURRENTLY OPPERATIONAL   # This controls whether payoffs have are marginally decreasing in value
  marginal_rate = 0.5,          # this is the rate of diminishing marginal returns
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
  invasion = false,
  power = false,
  glearn_strat = false              # options: "wealth", "Income"
)



  if REDD ==true
    if inst != true
      @warn("If REDD+ is on Institutions will be set to true")
      inst == true
    end
  end


  ################################################
  ##### The multiverse will be recorded  #########


  e = zeros(nrounds, ngroups, nsim)
  el = zeros(nrounds, ngroups, nsim)
  enl = zeros(nrounds, ngroups, nsim)
  h = zeros(nrounds, ngroups, nsim)
  p = zeros(nrounds, ngroups, nsim)
  pr = zeros(nrounds, ngroups, nsim)
  s = zeros(nrounds, ngroups, nsim)
  pt = zeros(nrounds, ngroups, nsim)
  pt2 =zeros(nrounds, ngroups, nsim)
  lt = zeros(nrounds, ngroups, nsim)
  lr = zeros(nrounds, ngroups, nsim)
  lmr = zeros(nrounds, ngroups, nsim)
  fi1 = zeros(nrounds, ngroups, nsim)
  fi2 = zeros(nrounds, ngroups, nsim)
  ogt = zeros(nrounds, ngroups, nsim)
  lc =  zeros(nrounds, ngroups, nsim)
  elh =  zeros(nrounds, ngroups, nsim)
  cel = zeros(nrounds, ngroups, nsim)
  cep2 = zeros(nrounds, ngroups, nsim)
  clp2 = zeros(nrounds, ngroups, nsim)
  vl = zeros(nrounds, ngroups, nsim)
  vp2 = zeros(nrounds, ngroups, nsim)
  ve = zeros(nrounds, ngroups, nsim)
  lpt1 = zeros(nrounds, nsim)
  ppt1 = zeros(nrounds, nsim)
  lpt0 = zeros(nrounds, nsim)
  ppt0 = zeros(nrounds, nsim)
  rpt0 = zeros(nrounds, nsim)
  rpt1 = zeros(nrounds, nsim)
  gs = zeros(nrounds, ngroups, nsim)
  gs2 = zeros(nrounds, ngroups, nsim)
  grs = zeros(nrounds, ngroups, nsim)

  am = zeros(nrounds, nsim)
  ma = zeros(nrounds, nsim)
  fm = zeros(ngroups, nsim)
  ry = zeros(nsim)
  ages = zeros(n)



  #simulations
  for sim = 1:nsim
    seed = seed + sim

    #############################
    #### EXPERIMENT SETUP ########
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
    if length(world) != ngroups
       @warn("the world is not built for your groups, check lattice and group size")
       break
    end
    #measure the distance between them
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

    # agent values
    id = collect(1:n)
    gs_init = convert(Int64, n/ngroups)
    gid = repeat(1:ngroups, gs_init)
    effort = zeros(n)
    leakage_type = zeros(n)
    punish_type = zeros(n)
    punish_type2 = zeros(n)
    fines1 = zeros(n)
    fines2 = zeros(n)
    harv_limit = zeros(n)
    loc = zeros(n)
    Random.seed!(seed)
    age = sample(18:19, n, replace=true) #notice a small variation in age is necessary for our motrality risk measure

    #assign agent values
    Random.seed!(seed+1)
    if invasion == true
        effort = rand(Beta(.1,10), n)
      else
        effort = inv_logit.(rnorm(n,logit(.5), .15)) #THIS STARTS AROUND 50%
    end
    #Setup harvest limit

    Random.seed!(seed+56)
    if invasion == true
        og_type = rand(Beta(1,10), n)
      else
        og_type  = inv_logit.(rnorm(n,logit(.5), .15)) #THIS STARTS AROUND 50%
    end

    Random.seed!(seed+2)
    temp=abs.(rand(Normal(harvest_limit, harvest_var), ngroups))
    for i in 1:ngroups
      Random.seed!(seed+i+2)
      harv_limit[gid.==i] = abs.(rand(Normal(temp[i], .03), gs_init))
    end

    # Setup fines
    if fine_start != nothing
      Random.seed!(seed+20)
      temp=abs.(rand(Normal(fine_start, fine_var), ngroups))
      for i in 1:ngroups
        Random.seed!(seed+i+20)
        fines1[gid.==i] = abs.(rand(Normal(temp[i], .03), gs_init))
      end

      Random.seed!(seed+21)
      temp=abs.(rand(Normal(fine_start, fine_var), ngroups))
      for i in 1:ngroups
        Random.seed!(seed+i+21)
        fines2[gid.==i] = abs.(rand(Normal(temp[i], .03), gs_init))
      end
    end

    # Setup leakage
    leak_temp =zeros(gs_init)
    leak_temp[1:asInt(ceil(gs_init/2))].=1 #50% START AS LEAKERS

    for i = 1:ngroups
    Random.seed!(seed+i+2+ngroups)
      leakage_type[gid.==i] = sample(leak_temp, gs_init)
    end

    # Setup punishment
    for i = 1:ngroups
      Random.seed!(seed+(i)+2+(ngroups*2))
      punish_type2[gid.==i] = rand(Beta(1, (1/.1-1)), gs_init) # the denominator in the beta term determines the mean
      Random.seed!(seed+(i*2)+2+(ngroups*2))
      punish_type[gid.==i] = rand(Beta(1, (1/.1-1)), gs_init) # the denominator in the beta term determines the mean
    end

    #set group status
    group_status = ones(ngroups)

    #set defensibility
      def = zeros(ngroups)
      for i in 1:ngroups
         if def_perc==true
            def[i] = gs_init/defensibility
          else
              def[i] =defensibility
          end
        end




    if verbose ==true println(string("Sim: ", sim, ", Initiation: COMPLETED ")) end




    ############################################
    ############# begin years ##################

    year = 1
    payoff = zeros(n)
    REDD_happened = false
    REDD_year = 0


    for t ∈ 1:nrounds
      payoff_round = zeros(n)

      ############################
      ########Check Config #######

      if leak == false  leakage_type = zeros(n) end
      if pun1_on == false  punish_type = zeros(n) end
      if pun2_on == false  punish_type2 = zeros(n) end
      if fines1_on == false fines1 = zeros(n)end
      if fines2_on == false fines2 = zeros(n)end


      ############################
      ### RUN EXPERIMENT #########
      for i = 1:length(experiment_group)
        if experiment_leak != 0
          leakage_type[gid .== experiment_group[i]] = rbinom(sum(gid.==experiment_group[i]),1, experiment_leak)
        end
        if experiment_punish1 != 0
          punish_type[gid .==experiment_group[i]] .= experiment_punish1
        end
        if experiment_punish2 != 0
          punish_type2[gid .==experiment_group[i]] .= experiment_punish2
        end
        if experiment_limit !=0
          harv_limit[gid .==experiment_group[i]] .=experiment_limit
        end

        if experiment_effort != 0
          effort[gid.==experiment_group[i]] .= experiment_effort
        end
      end


      if verbose== true print(string("Experiment: COMPLETED"))
      end

       ############################
       #### Set up the economy ###



       # derive production elasticities
       #check how the function for labor market elasticity to the supply of labor  curve(.05-.05^((1-log(x)))^1, from = 0, to = 1), where x is the share the population in the labor pool and 1 is the market size
       w = wages
       if(labor_market == true) w =  wages*cdf.(Beta(1, market_size), mean((1 .- effort))) end
       a = copy(labor)

       b = zeros(ngroups)
      for i in 1:ngroups
        b[i]=cdf.(Beta(degrade[1], degrade[2]), K[i]/maximum(kmax))
      end

       #######################
       ##### Agents act ######

       #individuals choose harvest patch
                # For Leakage Types, they nominate a number of patches set by groups_sampled, which are sampled in accordance with their distance,
         # the distance is scaled by travel costs and basically just means individuals will travel further away.
         # Once a set of proposals have been nominated, the individual chooses the forest with the most remaining forest, and travel there to harvest
         # note that we have an linear travel costs
         # Also indiviudals who are not leakage types simply harvest from their own patches



      for i = 1:n
        if ngroups == 2
          proposal =collect(1:2)[1:end .!= gid[i]]
        else
          weights = softmax(-distances[:, gid[i]]*distance_adj)
          temp = findall(x->x==0, group_status)
          weights[temp] .=0
          weights[gid[i]]=0
          if experiment == true weights[1:ngroups .∈ Ref(experiment_group)].=0 end
          proposal = wsample(collect(1:ngroups),  weights, groups_sampled, replace = false)
        end
          loc[i] = ifelse(leakage_type[i]==1, proposal[findmax(K[proposal])[2]], gid[i])
      end
      loc=asInt.(loc)
      if verbose ==true println(string("Year: ", year, ", Location Selection: COMPLETED ")) end


      #######################################################################
      #### When people are willing to exclude foreigners ... ################

      # Check to see if individuals who harvest outside their patch are caught
      # Check to see if individuals who are harvesting in their patch are not harvesting above the groups limit
      # prob = the proportion of punishers in the group - scaled by some elasticity that controls monitoring efficiency
      # The monitoring tech is such that p = plot(curve(pbeta(x, i, 1)
      # we can also use(n_punish^a/n) where a is monitoring tech and any value below one will produce and increasing concave function

      if inst == true


        #Determine defensibility

        if cmls == true
          if year > 1
            def = zeros(ngroups)
            for i in 1:ngroups
               if def_perc==true
                  def[i] = sum(gid.==i)/defensibility
               else
                  def[i] =defensibility
               end
             end
            end
          end


        # calculate total harvest
        # first evaluate those caught and have their harvests removed
          #note that the if else captures the case when no individuals harvest from the location and sum would result in na

        X =zeros(ngroups)

        #Set up effort invested by location
        eg2 = zeros(ngroups)


        for i in 1:ngroups
          X[i] =tech*((sum(effort[loc .== i])^a)*b[i])

        end

        loc = asInt.(loc)
        for i = 1:ngroups
          temp = sum(effort[loc.==i])
          if isinf(temp) | isnan(temp)
            eg2[i] = 0
          else
            eg2[i] = temp
          end
        end


        #Determine harvesting baseline values before investigation and confiscation

        hg_temp =ifelse.(isnan.(effort./eg2[loc]), 0,
           ((effort./eg2[loc]) .* X[loc] .- necessity) .* price)



        #inspect agents
        caught = asInt.(zeros(n))
        caught2 = asInt.(zeros(n))

        t ==1 ? wei = rand(Normal(.5, .01),n) : wei = copy(payoff)
         policy = zeros(ngroups)
         for i in 1:ngroups
           if group_status[i] == 1 policy[i]=median(harv_limit[gid.==i]) end

            if power == "wealth"
             wei = AnalyticWeights(wei)
             if group_status[i] == 1 policy[i]=median(harv_limit[gid.==i], wei[gid.==i]) end
           end
            if power == "poor"
             wei = abs.(wei.-findmax(wei)[1])
             wei = AnalyticWeights(wei)
             if group_status[i] == 1 policy[i]=median(harv_limit[gid.==i], wei[gid.==i]) end
            end
            if power == "income"
            t ==1 ? wei = rand(Normal(.5, .01),n) : wei = copy(payoff_round)
             wei = AnalyticWeights(wei)
             if group_status[i] == 1 policy[i]=median(harv_limit[gid.==i], wei[gid.==i]) end
            end
         end


        for i = 1:n
          prob_caught = cdf.(Beta(monitor_tech[1], monitor_tech[2]), sum(punish_type[gid .== loc[i]])/def[gid[i]])
          prob_caught2 = cdf.(Beta(monitor_tech[1], monitor_tech[2]), sum(punish_type2[gid .== loc[i]])/def[gid[i]])
          if loc[i] != gid[i]
            caught[i] = rbinom(1, 1, prob_caught)[1]
          else
            if self_policing ==true
              if hg_temp[i] >=  policy[gid[i]] caught2[i] = rbinom(1, 1, prob_caught2)[1]*(1-leakage_type[i])
              end
            end
          end
        end

        caught3 = caught2 + caught


        if verbose == true println(string("Year: ", year, ", Monitoring: COMPLETED ")) end


        #Calcualte the marignal amount of confiscated goods.
        X_non_siezed = zeros(ngroups)
        X_non_siezed_og = zeros(ngroups)
        X_non_siezed_ig = zeros(ngroups)
        effort2 = copy(effort)
        effort2[caught.== 1] .= 0
        effort2[caught2.== 1] .= 0

        effort3 = copy(effort)
        effort3[caught.== 1] .= 0 # only minus caught outgroup memebers


        effort4 = copy(effort)
        effort4[caught2.== 1] .= 0 # only minus caught ingroup memebers

        for i in 1:ngroups
          X_non_siezed[i] =tech*((sum(effort2[loc .== i])^a)*b[i])
          X_non_siezed_og[i] =tech*((sum(effort3[loc .== i])^a)*b[i])
          X_non_siezed_ig[i] =tech*((sum(effort4[loc .== i])^a)*b[i])
        end

        X_siezed = X-X_non_siezed_og-X_non_siezed_ig
        X_siezed_og = X-X_non_siezed_og
        X_siezed_ig = X-X_non_siezed_ig

        #Calculate ecosystem service benifits
        eco = zeros(ngroups)
        if ecosys > 0
           for i in 1:ngroups
             eco[i]=cdf.(Beta(1, eco_slope), K[i]/maximum(kmax))*eco_C
           end
         end

      #Calcualte pollition costs
       pol = zeros(ngroups)
       if pollution > 0
          for i in 1:ngroups
            pol[i]=(1 .- cdf.(Beta(pol_slope, 1), K[i]/maximum(kmax)))*pol_C
            pol[i] = mean(effort[loc .==i])*pol[i]
          end
        end



        if verbose ==true println(string("Year: ", year, ", Harvest: COMPLETED ")) end
        if verbose ==true println(string("Pollution: ", round.(pol, digits =2))) end
        if verbose ==true println(string("Eco_sys: ", round.(eco, digits = 2))) end



        ################################
        ##### Calculate payoffs ########


        # first calculate whether or not the individual was caught
        # first we see if they are harvesting in their own location - if they are not they are evaluated
        # the probability that they are caught is is a downward concave increasing function of the total time alotted to protecting the forest
        # So the payoff function has X components
        # 1. The individuals gets a proportional harvest from the forest they harvested from equivelent to their total labor contribution from the
        #        total NON-SEIZED assets
        # 2. They get some income from working in the wage labor sector
        # 3. They loss some income if they are punishers
        # 4. The group splits the revenue from all assets that they confiscated from individuals illegally harvesting from their patch.
        # 5. If the individual was caught stealing from another patch they then must pay some fine that is scaled by the amount they tried to steal.

        mc1 = punish_cost*punish_type # monitoring cost
        mc2 = punish_cost*punish_type2 # monitoring cost
        wl = w.*(1 .- effort)
        fp_og = zeros(ngroups)
        fp_ig = zeros(ngroups)
        sg_ig = zeros(ngroups)
        sg_og = zeros(ngroups)
        hg = zeros(ngroups)
        eg = zeros(ngroups)

        #Caclulate effort from non-confiscated harvests
        loc = asInt.(loc)
        for i = 1:ngroups
            temp = sum(effort2[loc.==i])
          if isinf(temp) | isnan(temp)
            eg[i] = 0
          else
            eg[i] = temp
          end
        end
        hg =ifelse.(isnan.(effort2./eg[loc]), 0,
           ((effort2./eg[loc]) .* X_non_siezed[loc] .- necessity) .* price)


        #determine fines
        for i = 1:ngroups
          # Outgroup

          temp = (X_siezed_og[i]).*price
          if isinf(temp) | isnan(temp)
            sg_og[i] = 0
          else
            sg_og[i] = temp
          end

          temp = (sg_og[i]).*median(fines1[gid .==i])
          if isinf(temp) | isnan(temp)
            fp_og[i] = 0
          else
            fp_og[i] = temp
          end

          #Ingroup
          temp = (X_siezed_ig[i]).*price
          if isinf(temp) | isnan(temp)
            sg_ig[i] = 0
          else
            sg_ig[i] = temp
          end

          temp = (sg_ig[i]).*median(fines2[gid .==i])
          if isinf(temp) | isnan(temp)
            fp_ig[i] = 0
          else
            fp_ig[i] = temp
          end
        end

        #fine cost paid by the person who committed the infraction.
        policyfine1 = zeros(n)
        policyfine2 = zeros(n)
        if fine_start != nothing
           for i = 1:ngroups
             if sum(loc.==i) != 0
               policyfine1[loc .==i] = caught[loc.==i] .* median(fines1[loc .==i])
             end
               policyfine2[gid .==i] = caught2[gid.==i] .* median(fines2[gid .==i])
           end
         end

        fc1 = policyfine1.*ifelse.(isnan.(effort./eg2[loc]), 0,
           ((effort./eg2[loc]) .* X[loc]) .* price)

        fc2 = policyfine2.*ifelse.(isnan.(effort./eg2[loc]), 0,
          ((effort./eg2[loc]) .* X[loc]) .* price)

        # calculate each individuals relative contribution to protecting the resource
        p1_tot = zeros(ngroups)
        p2_tot = zeros(ngroups)
        for i = 1:ngroups
          p1_tot[i] = sum(punish_type[gid .==i])
          p2_tot[i] = sum(punish_type2[gid .==i])
        end

        if seized_on == false sg_ig = sg_og = zeros(n) end


        payoff_round = hg.*(1 .- caught3) + wl +
         ifelse.(isnan.(sg_og[gid].*(punish_type./p1_tot[gid])), 0, sg_og[gid].*(punish_type./p1_tot[gid])) +
          ifelse.(isnan.(sg_ig[gid].*(punish_type2./p2_tot[gid])), 0, sg_ig[gid].*(punish_type2./p2_tot[gid]))  +
            ifelse.(isnan.(fp_og[gid].*(punish_type./p1_tot[gid])), 0, fp_og[gid].*(punish_type./p1_tot[gid]))  +
              ifelse.(isnan.(fp_ig[gid].*(punish_type2./p2_tot[gid])), 0,fp_ig[gid].*(punish_type2./p2_tot[gid]))  -
            mc1 - mc2 -
             fc1 - fc2 -
              travel_cost.*leakage_type -
              pol[gid] +
              eco[gid]

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



      payoff += payoff_round .+ baseline
      payoff_round[isnan.(payoff_round)] .=0
      payoff[isnan.(payoff)] .=0


    else


    ##################################################################
    ############ In a world without boundaries .... ##################

        X_non_siezed = 0 #just for reporting
        X = zeros(ngroups)
        fp_og = zeros(ngroups)
        fp_ig = zeros(ngroups)
        sg_ig = zeros(ngroups)
        sg_og = zeros(ngroups)
        hg = zeros(ngroups)
        eg = zeros(ngroups)
        hg_temp = zeros(n)
        caught = zeros(n)
        X_non_siezed_ig = zeros(ngroups)
        X_non_siezed_og = zeros(ngroups)
        fine1 = zeros(n)
        fine2 = zeros(n)


        for i in 1:ngroups
          X[i] =tech*((sum(effort[loc .== i])^a)*b[i])

        end

        wl = w.*(1 .- effort)
        hg = zeros(ngroups)
        eg = zeros(ngroups)
        loc = asInt.(loc)

        for i = 1:ngroups
          temp = sum(effort[loc.==i])
          if isinf(temp) | isnan(temp)
            eg[i] = 0
          else
            eg[i] = temp
          end
        end

        #Calculate ecosystem service benifits
        eco = zeros(ngroups)
        if ecosys > 0
           for i in 1:ngroups
             eco[i]=cdf.(Beta(1, eco_slope), K[i]/maximum(kmax))*eco_C
           end
         end

      #Calcualte pollition costs
       pol = zeros(ngroups)
       if pollution > 0
          for i in 1:ngroups
            pol[i]=(1 .- cdf.(Beta(pol_slope, 1), K[i]/maximum(kmax)))*pol_C
            pol[i] = mean(effort[loc .==i])*pol[i]
          end
        end



        hg =ifelse.(isnan.(effort./eg[loc]), 0,
           ((effort./eg[loc]) .* X[loc] .- necessity) .* price)


        payoff_round = hg + wl - travel_cost.*leakage_type  -
        pol[gid] +
        eco[gid]

        payoff += payoff_round  .+ baseline

        payoff_round[isnan.(payoff_round)] .=0
        payoff[isnan.(payoff)] .=0
      end

      if verbose == true println(string("Year: ", year, ", Payoff: COMPLETED ")) end

      #################################
      ####### Forest Dynamics #########

      #remove stock
      K -= X
      #regrow stock
      K += K*regrow.*(1 .- K./kmax)

      #apply volatility
      vola=rand(Normal(1, volatility), ngroups)
      K .= K.*vola

      #Check to make sure stock follows logical constraints
      K .= ifelse.(K .> kmax, kmax, K)
      K .= ifelse.(K.<= 0, .01 .* kmax, K) #note that if the forest is depleted it will regrow back to the regrowth rate* max.


      if verbose == true print(string("Year: ", year, ", Regrow: COMPLETED ")) end


      ######################################
      ######### Social Learning ############

      # Prestige Biased Transmission
      if social_learning == true
        models = zeros(n)
        out = zeros(n)
        if og_on == false
          out = rbinom(n, 1, outgroup)
        else
          out = zeros(n)
          for i in 1:n
            out[i] = rbinom(1,1, og_type[i])[1]
          end
        end
        #Make group averages
        if glearn_strat == "income" gmean=AnalyticWeights(report(payoff_round, gid, ngroups)) end
        if glearn_strat == "wealth" gmean=AnalyticWeights(report(payoff, gid, ngroups)) end
        if glearn_strat == "env" gmean=AnalyticWeights(K./kmax) end
        if glearn_strat == "random" gmean=AnalyticWeights(ones(ngroups))end
        if glearn_strat == false gmean=AnalyticWeights(ones(ngroups))end
        if length(experiment_group)==1 gmean[experiment_group]=0 end  #this ensures all learning happens not from the experimental group.
        if length(experiment_group)>1 gmean[experiment_group].=0 end
        temp = findall(x->x==0, group_status) #remove dead groups
        gmean[temp] .=0

        model_groups = sample(1:ngroups,gmean, n)


        for i = 1:n
          temp2 = id[(gid .∈ Ref(gid[i])) .== (id .!= i)]
          if glearn_strat == false
            model_list = ifelse(out[i]==1,
              sample(id[gid.==model_groups[i]], nmodels, replace = false),
              sample(temp2, nmodels, replace = false))
            else
              model_list = ifelse(out[i]==1,
                sample(id[1:end .!= id[i]], nmodels, replace = false),
                sample(temp2, nmodels, replace = false))
            end

          if learn_type == "wealth"
            model_temp = model_list[findmax(payoff[model_list])[2]]
            models[i] = ifelse(payoff[model_temp] > payoff[i], model_temp, i) end
          if learn_type == "income"
              model_temp = model_list[findmax(payoff_round[model_list])[2]]
              models[i] = ifelse(payoff_round[model_temp] > payoff_round[i], model_temp, i) end
        end # End finding models
        models = asInt.(models)


        #note that there can be eigenmodels
        trans_error = rand(n,8) .< fidelity
        n_error = [[rand(Normal(), n)] [rand(Normal(1, .02), n)] [rand(Normal(), n)] [rand(Normal(), n)] [rand(Normal(1, .02), n)] [rand(Normal(1, .02), n)] [rand(Normal(), n)]]
        #Ensure there is no transmission error for indiviudals who did not copy
        self = models .== id
        trans_error[self,:] .=0
        #apply mutations in learning
        effort = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[models]) .+ n_error[1]), effort[models])
        leakage_type  =ifelse.(trans_error[:,2], ifelse.(leakage_type[models].==1,0,1), leakage_type[models])
        punish_type =  ifelse.(trans_error[:,3], inv_logit.(logit.(punish_type[models]) .+ n_error[3]), punish_type[models])
        harv_limit = ifelse.(trans_error[:,4], harv_limit[models] .* n_error[2], harv_limit[models])
        punish_type2  = ifelse.(trans_error[:,5], inv_logit.(logit.(punish_type2[models]) .+ n_error[4]), punish_type2[models])
        fines1 = ifelse.(trans_error[:,6], fines1[models] .* n_error[5], fines1[models])
        fines2 = ifelse.(trans_error[:,7], fines2[models] .* n_error[6], fines2[models])
        og_type = ifelse.(trans_error[:,7], inv_logit.(logit.(og_type[models]) .+ n_error[7]), og_type[models])



      if verbose ==true println(string("Year: ", year, ", Social Learning: COMPLETED ")) end
      end

      ############################
      ### RUN EXPERIMENT #########
      for i = 1:length(experiment_group)
        if experiment_leak != 0
          leakage_type[gid .== experiment_group[i]] = rbinom(sum(gid.==experiment_group[i]),1, experiment_leak)
        end
        if experiment_punish1 != 0
          punish_type[gid .==experiment_group[i]] .= experiment_punish1
        end
        if experiment_punish2 != 0
          punish_type2[gid .==experiment_group[i]] .= experiment_punish2
        end
        if experiment_limit !=0
          harv_limit[gid .==experiment_group[i]] .=experiment_limit
        end

        if experiment_effort != 0
          effort[gid.==experiment_group[i]] .= experiment_effort
        end
      end



      #############################################
      ### Record the Year in the  History books ###

      s[year,:,sim] .= round.(K./kmax, digits=3)
      h[year,:,sim] .= round.(report(hg./price, gid, ngroups), digits=2)

      e[year,:,sim] .= round.(report(effort, gid, ngroups), digits=2)
      el[year,:,sim] .= round.(report(effort[leakage_type.==1], gid[leakage_type.==1], ngroups), digits=2)
      enl[year,:,sim] .= round.(report(effort[leakage_type.==0], gid[leakage_type.==0], ngroups), digits=2)
      p[year,:,sim] .= round.(report(payoff, gid, ngroups), digits=2)
      pr[year,:,sim] .= round.(report(payoff_round, gid, ngroups), digits=3)
      lc[year,:,sim] = tab(caught[gid.==loc], ngroups)
      pt[year,:,sim] .= round.(report(punish_type, gid, ngroups), digits=2)
      pt2[year,:,sim] .= round.(report(punish_type2, gid, ngroups), digits=2)
      lt[year,:,sim] .= round.(report(leakage_type, gid, ngroups), digits=2)
      ogt[year,:,sim] .= round.(report(og_type, gid, ngroups), digits=2)
      lr[year,:,sim] .= round.(report(loc .!= gid, gid, ngroups), digits=2)
      lc[year,:,sim] = tab(harv_limit[gid], ngroups)
      gs2[year,:,sim] .= round.(X-X_non_siezed_ig, digits=2)
      gs[year,:,sim] .= round.(X-X_non_siezed_og, digits=2)
      lpt1[year, sim] = round.(mean(payoff_round[leakage_type.==1]), digits = 2)
      lpt0[year, sim] = round.(mean(payoff_round[leakage_type.==0]), digits = 2)
      am[year, sim] = median(age)
      am[year, sim] = maximum(age)
      lmr[year,:,sim] .= round.(reportMedian(harv_limit, gid, ngroups), digits=4)
      fi1[year,:,sim] .= round.(reportMedian(fines1, gid, ngroups), digits=3)
      fi2[year,:,sim] .= round.(reportMedian(fines2, gid, ngroups), digits=3)
      cel[year,:,sim] .= round.(reportCor(effort, harv_limit, gid, ngroups), digits=3)
      cep2[year,:,sim] .= round.(reportCor(effort, punish_type2, gid, ngroups), digits=3)
      clp2[year,:,sim] .= round.(reportCor(harv_limit, punish_type2, gid, ngroups), digits=3)
      vp2[year,:,sim] .= round.(reportVar(punish_type2, gid, ngroups), digits=3)
      vl[year,:,sim] .= round.(reportVar(harv_limit, gid, ngroups), digits=3)
      ve[year,:,sim] .= round.(reportVar(effort, gid, ngroups), digits=3)

      ages = age



      cnt = zeros(ngroups)
      for i = 1:ngroups
        if sum(gid.==i)==0
          cnt[i] = NaN
        else
          cnt[i]=median(harv_limit[gid.==i])
        end
      end

      #lmr[year,:,sim] .= round.(cnt, digits=3)
      grs[year,:,sim] .= round.(tab(gid, ngroups), digits =2)




    cnt = zeros(ngroups)
      for i = 1:ngroups
        if sum((gid.==i) .& (leakage_type.==0))==0
          cnt[i] = NaN
        else
          cnt[i]=mean(hg_temp[(gid.==i) .& (leakage_type.==0)] .< median(harv_limit[gid.==i]))
        end
      end

      cnt = zeros(ngroups)
      for i = 1:ngroups
        if sum(gid.==i)==0
          cnt[i] = NaN
        else
          cnt[i]=median(harv_limit[gid.==i])
        end
      end

      ##############################################
      ###### Impose Insitutions ####################

      if REDD_happened == false
        trigger = false
        if REDD == true
          if REDD_dates == "leakage"
            if ngroups == 2
              if cofma_gid == "biggest"
                if mean(leakage_type[gid .==findmin(kmax)[2]]) >= .5 && (year >20 && year < 150) trigger == true
                end
              end

              if cofma_gid == "smallest"
                if mean(leakage_type[gid .==findmax(kmax)[2]]) >= .5 && (year >20 && year < 150) trigger == true
                end
              end
            end
          end
          if REDD_dates == "no_leakage"
            if ngroups == 2
              if cofma_gid == "biggest"
                if mean(leakage_type[gid .==findmin(kmax)[2]]) <= .1 && (year >20 && year < 150) trigger == true
                end
              end
              if cofma_gid == "smallest"
                if mean(leakage_type[gid .==findmax(kmax)[2]]) <= .1 && (year >20 && year < 150) trigger == true
                end
              end
            end
          end
          if (year ∈ REDD_dates) | trigger
            if isnothing(cofma_gid)
              cofmas = sample(gid, num_cofma, replace = false)
            else
              if cofma_gid == "biggest"
                cofmas <- findmax(kmax)[2]
              end
              if cofma_gid == "smallest"
                cofmas = findmin(kmax)
              end
              if all(isnumber.(cofma_gid))
               cofmas = copy(cofma_gid)
              end
            end
            punish_type[gid .∈ Ref(cofmas)] .= 1
            punish_type2[gid .∈ Ref(cofmas)] .= 1
            if law == "current"
              for i in cofmas
                harv_limit[gid.==i] .= mean(effort[gid.==i])
              end
            else
              harv_limit[gid .∈ Ref(cofmas)] .= law
            end
            REDD_year = copy(year)
          end
          if trigger == true  | year >= REDD_dates REDD_happened = true end
        end
      end
      if verbose ==true println(string("Year: ", year, ", REDD+: COMPLETED "))end


      #########################################
      ############# GENERAL UPDATING ##########


      if wage_growth == true wages <- wages*wgrowth_rate + wages end
      if wages >=1  wages =.99 end
      age .+= 1





      ####################################
      ###### Evolutionary dynamics #######

      #ADD BASELINE PAYOFFS

      payoff_round[payoff_round.<=0] .=0
      payoff[payoff.<=0] .=0
      sample_payoff = ifelse.(payoff .!=0, payoff, 0.0001)


      if experiment==true
        #ensure that the experimental group is a seperate breeding population
        pop = id[gid .∈  [experiment_group]]
        died =  killagents(pop, id, age, mortality_rate, sample_payoff)
        babies = makebabies(pop, id, sample_payoff, died)

        trans_error = rand(length(babies), 7) .< mutation
        n_error = [[rand(Normal(), length(babies))] [rand(Normal(1, .02), length(babies))] [rand(Normal(), length(babies))] [rand(Normal(), length(babies))] [rand(Normal(1, .02), length(babies))] [rand(Normal(1, .02), length(babies))]]

        effort[babies] = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[babies]) .+ n_error[1]), effort[babies])
        leakage_type[babies]  =ifelse.(trans_error[:,2], ifelse.(leakage_type[babies].==1,0,1), leakage_type[babies])
        punish_type[babies] =  ifelse.(trans_error[:,3], inv_logit.(logit.(punish_type[babies]) .+ n_error[3]), punish_type[babies])
        harv_limit[babies] = ifelse.(trans_error[:,4], harv_limit[babies] .* n_error[2], harv_limit[babies])
        punish_type2[babies] =  ifelse.(trans_error[:,5], inv_logit.(logit.(punish_type2[babies]) .+ n_error[4]), punish_type2[babies])
        fines1[babies] = ifelse.(trans_error[:,6], fines1[babies] .* n_error[5], fines1[babies])
        fines2[babies] = ifelse.(trans_error[:,7], fines2[babies] .* n_error[6], fines2[babies])


        payoff[died] .= 0
        age[died]  .= 0

        #For all other groups are part of a breeding population
        pop = id[gid .∉  [experiment_group]]
        sample_payoff = ifelse.(payoff .!=0, payoff, 0.0001)
        died =  killagents(pop, id, age, mortality_rate, sample_payoff)
        babies = makebabies(pop, id, sample_payoff, died)

        trans_error = rand(length(babies), 7) .< mutation
        n_error = [[rand(Normal(), length(babies))] [rand(Normal(1, .02), length(babies))] [rand(Normal(), length(babies))] [rand(Normal(), length(babies))] [rand(Normal(1, .02), length(babies))] [rand(Normal(1, .02), length(babies))]]
        effort[babies] = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[babies]) .+ n_error[1]), effort[babies])
        leakage_type[babies]  =ifelse.(trans_error[:,2], ifelse.(leakage_type[babies].==1,0,1), leakage_type[babies])
        punish_type[babies]  = ifelse.(trans_error[:,3], inv_logit.(logit.(punish_type[babies]) .+ n_error[3]), punish_type[babies])
        harv_limit[babies] = ifelse.(trans_error[:,4], harv_limit[babies] .* n_error[2], harv_limit[babies])
        punish_type2[babies]  = ifelse.(trans_error[:,5], inv_logit.(logit.(punish_type2[babies]) .+ n_error[4]), punish_type2[babies])
        fines1[babies] = ifelse.(trans_error[:,6], fines1[babies] .* n_error[5], fines1[babies])
        fines2[babies] = ifelse.(trans_error[:,7], fines2[babies] .* n_error[6], fines2[babies])

        payoff[died] .= 0
        age[died]  .= 0
        #CMLS dynamic

        if cmls== true  gid[died] = copy(gid[babies]) end

      else #end experiment


        died =  killagents(id, id, age, mortality_rate, sample_payoff)
        babies = makebabies(id, id, sample_payoff, died)

        trans_error = rand(length(babies), 7) .< mutation
        n_error = [[rand(Normal(), length(babies))] [rand(Normal(1, .02), length(babies))] [rand(Normal(), length(babies))] [rand(Normal(), length(babies))] [rand(Normal(1, .02), length(babies))] [rand(Normal(1, .02), length(babies))]]
        effort[babies] = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[babies]) .+ n_error[1]), effort[babies])
        leakage_type[babies]  =ifelse.(trans_error[:,2], ifelse.(leakage_type[babies].==1,0,1), leakage_type[babies])
        punish_type[babies]  = ifelse.(trans_error[:,3], inv_logit.(logit.(punish_type[babies]) .+ n_error[3]), punish_type[babies])
        harv_limit[babies] = ifelse.(trans_error[:,4], harv_limit[babies] .* n_error[2], harv_limit[babies])
        punish_type2[babies] =  ifelse.(trans_error[:,5], inv_logit.(logit.(punish_type2[babies]) .+ n_error[4]), punish_type2[babies])
        fines1[babies] = ifelse.(trans_error[:,6], fines1[babies] .* n_error[5], fines1[babies])
        fines2[babies] = ifelse.(trans_error[:,7], fines2[babies] .* n_error[6], fines2[babies])


        payoff[died] .= 0
        age[died]  .= 0
    #CMLS dynamic
        if cmls == true  gid[died] = gid[babies] end

    end


    #reset the wealth of the dead

    if verbose ==true println(string("Year: ", year, ", Evolution: COMPLETED - Group Sizes: ", grs[year,:,sim])) end
    #DEAL WITH DEAD GROUPS
    if cmls == true
      if any(tab(gid, ngroups).<(nmodels+1))
        failed = findall((tab(gid, ngroups) .< (nmodels+1)))
        successful = findall((tab(gid, ngroups) .>= (nmodels+1)))
        temp = ones(ngroups)
        temp[failed].=0
        temp2 = copy(group_status)
        temp3 = temp .!=temp2
        new_failed =findall(x->x .==1, temp3)
        if any(temp .!=temp2)
          gid[gid .∈ Ref(new_failed)] = sample(gid[gid .∉ Ref(new_failed)], sum(gid .∈ Ref(new_failed)), replace = false)
          K[successful] .=  asInt.(round.(K[successful] .+  sum(K[new_failed])/length(successful)))
          kmax[successful] .=  asInt.(round.(kmax[successful] .+  sum(kmax[new_failed])/length(successful)))
        end
      end
    dead_groups = findall((tab(gid, ngroups) .< (nmodels+1)))
    group_status[dead_groups].=0
    K[dead_groups].=0
    end
    if verbose ==true println(string("Year: ", year, ",  COMPLETED ")) end
    year += 1


    end #end years

    ry[sim] = REDD_year


  end# end sims


  output=Dict("effort" => e,
    "stock" => s,
    "effortNl" => enl,
    "effortL" => el,
    "harvest" => h,
    "punish" => pt,
    "punish2" => pt2,
    "comp" => elh,
    #"loc_caught" => lc,
    "leakage" => lt,
    "payoffR" => pr,
    "fine1"=>fi1,
    "fine2"=>fi2,
    "payoff_leakage" => lpt1,
    "payoff_no_leakage" => lpt0,
    #"leakage_rate" => lr,
    "limit" => lmr,
    #"age_max" => am,
    #"age_mean" => ma,
    "seized" => gs,
    "seized2" => gs2,
    "forsize" => fm,
    #"reddyear" => ry,
    #"group_size" => grs,
    "ages" => ages,
    "cel" => cel,
    "clp2" => clp2,
    "cep2" => cep2,
    "ve" => ve,
    "vp2" => vp2,
    "vl" => vl,
    "roi" => h./e,
    "og" => ogt


    )

    return(output)

end
