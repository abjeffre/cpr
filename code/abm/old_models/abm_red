function makebabies(popu, ids, ages, mort, pay)
        sample_payoff = ifelse.(payoff .!=0, payoff, 0.000001)
        if asInt.(unique(age[pop]))[1]==1
            ma = mean(age[pop])
            length(age[pop])
            age[pop] .=age[pop].+rand(0:1, length(age[pop]))
        end
        mortality_risk = softmax(standardize(age[pop].^5) .- standardize(sample_payoff[pop].^.25))
        to_die = asInt(round(mortality_rate*n *((ngroups-1)/ngroups), digits =0))
        died = wsample(id[pop], mortality_risk, to_die)
        pos_parents = id[(id .∈ Ref(pop)) .== (id .∉ Ref(died))]
        pos_payoff = convert.(Float64, vec(sample_payoff[pos_parents]))
        #return(pos_parents, pos_payoff, length(died))
        babies =wsample(pos_parents, pos_payoff, length(died), replace = true)
        return(babies)
    end


function mutatebabies(babies, mutate)
        trans_error = rand(length(babies), 5) .< mutate
        n_error = [[rand(Normal(), length(babies))] [rand(Normal(1, .02), length(babies))]]
        effort[babies] = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[babies]) .+ n_error[1]), effort[babies])
        leakage_type[babies]  =ifelse.(trans_error[:,2], ifelse.(leakage_type[babies].==1,0,1), leakage_type[babies])
        punish_type[babies]  =ifelse.(trans_error[:,3], ifelse.(punish_type[babies].==1,0,1), punish_type[babies])
        harv_limit[babies] = ifelse.(trans_error[:,4], abs.(harv_limit[babies] .* n_error[2]), harv_limit[babies])
        punish_type2[babies]  =ifelse.(trans_error[:,5], ifelse.(punish_type2[babies].==1,0,1), punish_type2[babies])
end



function cpr_abm(
  ;nsim = 1,                    # Number of simulations per call
  nrounds = 2000,               # Number of rounds per generation
  n = 1800,                     # Size of the population
  ngroups = 20,                 # Number of Groups in the population
  lattice = (4, 5),             # This controls the dimensions of the lattice that the world exists on

  mortality_rate = 0.03,      # The number of deaths per 100 people
  mutation = 0.01,            # Rate of mutation on traits

  wages = .1,                   # Wage rate in other sectors - opportunity costs
  wage_growth = false,          # Do wages grow?
  wgrowth_rate =.0001,          # this is a fun parameter, we know that the average growth rate for preindustiral societies is 0.2% per year why not let wages grow and see what happens
  labor_market = false,         # This controls labor market competition
  market_size = 1,              # This controls the demand for labor in the population and is exogenous: Note that when set to 1 the wage rate equilibrates when half the population is in the labor force

  max_forest = 10000,               # Average max stock
  var_forest = 1,                   # Controls athe heterogeneity in forest size across diffrent groups
  degradability = 0,                # This measures how degradable a resource is(when zero the resource declines linearly with size and as it increase it degrades more quickly, if negative it decreases the rate of degredation), degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
  regrow = .01,                     # the regrowth rate

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
  monitor_tech = 1,             # This controls the efficacy of monitnoring, higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i, 1, x), 0, 5), where i is the proportion of monitors in a pop
  defensibility = 1,            # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
  def_perc = true,              # This sets the maximum possible insepction rate if all indiviudals participate in guarding it.
  punish_cost = 0.001,           # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs
  fine = 0.0,                   # This controls the size of the fine issued when caught, note that in a real world situation this could be recouped by the injured parties but it is not
  self_policing = true,         # Toggles if Punishers also target members of their own ingroup for harvesting over limit
  harvest_limit = 0.25,         # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
  harvest_var = .07,


  distance_adj =0.9,            # This affects the proboabilty of sampling a more close group.
  travel_cost = .00,            # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
  groups_sampled = 3,           # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes


  social_learning = true,       # Toggels whether Presitge Biased Tranmission is on
  nmodels = 3,                  # The number of models sampled to copy from in social learning
  fidelity = 0.01,              # This is the fidelity of social transmission
  learn_type = "income",        # Two Options - "wealth" and "income" indiviudals can choose to copy wealth or income if copy wealth they copy total overall payoffs, if copy income they copy payoffs from the previous round
  outgroup = 0.01,              # This is the probability that the individual samples from the whole population and not just his group when updating0...
  baseline = .01,                # Baseline payoff to be added each round -

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
  experiment_leak = false,              #THIS SETS THE VALUE OF THE OTHER GROUP LEAKAGE and Punish
  experiment_punish1 = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_punish2 = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_limit = false,             #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_effort = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_group = 1,                 #determines the set of groups which the experiment will be run on
  cmls = false                          #determines whether cmls will operate
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
  l0p0 = zeros(nrounds, ngroups, nsim)
  l0p1 = zeros(nrounds, ngroups, nsim)
  l1p0 = zeros(nrounds, ngroups, nsim)
  l1p1 = zeros(nrounds, ngroups, nsim)

  l0p0r1 = zeros(nrounds, ngroups, nsim)
  l0p1r1 = zeros(nrounds, ngroups, nsim)
  l1p0r1 = zeros(nrounds, ngroups, nsim)
  l1p1r1 = zeros(nrounds, ngroups, nsim)


  l0p0r0 = zeros(nrounds, ngroups, nsim)
  l0p1r0 = zeros(nrounds, ngroups, nsim)
  l1p0r0 = zeros(nrounds, ngroups, nsim)
  l1p1r0 = zeros(nrounds, ngroups, nsim)


  lc =  zeros(nrounds, ngroups, nsim)
  elh =  zeros(nrounds, ngroups, nsim)

  l1p1r0hl = zeros(nrounds, ngroups, nsim)
  l1p0r0hl = zeros(nrounds, ngroups, nsim)
  l0p0r0hl = zeros(nrounds, ngroups, nsim)
  l0p1r0hl = zeros(nrounds, ngroups, nsim)

  l1p1r1hl = zeros(nrounds, ngroups, nsim)
  l1p0r1hl = zeros(nrounds, ngroups, nsim)
  l0p0r1hl = zeros(nrounds, ngroups, nsim)
  l0p1r1hl = zeros(nrounds, ngroups, nsim)


  l1p1r0e = zeros(nrounds, ngroups, nsim)
  l1p0r0e = zeros(nrounds, ngroups, nsim)
  l0p0r0e = zeros(nrounds, ngroups, nsim)
  l0p1r0e = zeros(nrounds, ngroups, nsim)

  l1p1r1e = zeros(nrounds, ngroups, nsim)
  l1p0r1e = zeros(nrounds, ngroups, nsim)
  l0p0r1e = zeros(nrounds, ngroups, nsim)
  l0p1r1e = zeros(nrounds, ngroups, nsim)



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
    degrade = 1 + degradability


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
    harv_limit = zeros(n)
    loc = zeros(n)
    Random.seed!(seed)
    age = sample(18:19, n, replace=true) #notice a small variation in age is necessary for our motrality risk measure

    #assign agent values
    Random.seed!(seed+1)
    effort = inv_logit.(rnorm(n,logit(.5), .15)) #THIS STARTS AROUND 50%

    Random.seed!(seed+2)
    temp=abs.(rand(Normal(harvest_limit, harvest_var), ngroups))
    for i in 1:ngroups
      Random.seed!(seed+i+2)
      harv_limit[gid.==i] = abs.(rand(Normal(temp[i], .03), gs_init))
    end

    leak_temp =zeros(gs_init)
    leak_temp[1:asInt(ceil(gs_init/2))].=1 #50% START AS LEAKERS

    for i = 1:ngroups
    Random.seed!(seed+i+2+ngroups)
      leakage_type[gid.==i] = sample(leak_temp, gs_init)
    end

    punish_temp = zeros(gs_init)
    punish_temp[1:asInt(ceil((n/ngroups)*.1))].=1 #10%STARTS AS ENFORCERS
    for i = 1:ngroups
      Random.seed!(seed+(i)+2+(ngroups*2))
      punish_type2[gid.==i] = sample(punish_temp, gs_init)
      Random.seed!(seed+(i*2)+2+(ngroups*2))
      punish_type[gid.==i] = sample(punish_temp, gs_init)
    end

    #set group status
    group_status = ones(ngroups)

    #set defensibility
    if def_perc==true
        def = gs_init/defensibility
    else
        def =defensibility
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

      ############################
      ### RUN EXPERIMENT #########
      for i = 1:length(experiment_group)
        if experiment_leak != 0
          leakage_type[gid .== experiment_group[i]] = rbinom(sum(gid.==experiment_group[i]),1, experiment_leak)
        end
        if experiment_punish1 != 0
          punish_type[gid .==experiment_group[i]] = rbinom(sum(gid.==experiment_group[i]),1, experiment_punish1)
        end
        if experiment_punish2 != 0
          punish_type2[gid .==experiment_group[i]] = rbinom(sum(gid.==experiment_group[i]),1, experiment_punish2)
        end
        if experiment_limit !=0
          harv_limit[gid .==experiment_group[i]] .=experiment_limit
        end

        if experiment_limit != 0
          effort[gid.==experiment_group[i]] .= experiment_effort
        end
      end


      if verbose== true print(string("Mean Group 1 Leakage: ",
         mean(leakage_type[gid.==1]), " Mean Group 1 Punish: ", mean(punish_type[gid.==1])))
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
        b[i]=cdf.(Beta(degrade, 1), K[i]/maximum(kmax))
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

        # calculate total harvest
        # first evaluate those caught and have their harvests removed
          #note that the if else captures the case when no individuals harvest from the location and sum would result in na

        X =zeros(ngroups)
        eg2 = zeros(ngroups)

        if verbose == true println(string("b = ", round.(b, digits =2), ", K/max = ", round.(K./maximum(kmax), digits =2))) end


        for i in 1:ngroups
          X[i] =tech*((sum(effort[loc .== i])^a)*b[i])
        end

        loc = asInt.(loc)
        for i = 1:ngroups
          temp = sum(effort[loc.==i]).*price
          if isinf(temp) | isnan(temp)
            eg2[i] = 0
          else
            eg2[i] = temp
          end
        end

        hg_temp =ifelse.(isnan.(effort./eg2[loc]), 0,
           ((effort./eg2[loc]) .* X[loc] .- necessity) .* price)


        caught = asInt.(zeros(n))
        caught2 = asInt.(zeros(n))
        for i = 1:n
          prob_caught = cdf.(Beta(1, monitor_tech), sum(punish_type[gid .== loc[i]])/def)
          prob_caught2 = cdf.(Beta(1, monitor_tech), sum(punish_type2[gid .== loc[i]])/def)
          if loc[i] != gid[i]
            caught[i] = rbinom(1, 1, prob_caught)[1]
          else
            if self_policing ==true
              if hg_temp[i] >=  median(harv_limit[gid[asInt(loc[i])]]) caught2[i] = rbinom(1, 1, prob_caught2)[1]
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

        for i = 1:ngroups
          # Outgroup
          temp = (X_siezed_og[i]/sum(punish_type[gid.==i])).*price
          if isinf(temp) | isnan(temp)
            sg_og[i] = 0
          else
            sg_og[i] = temp
          end
          temp = (sg_og[i]).*fine
          if isinf(temp) | isnan(temp)
            fp_og[i] = 0
          else
            fp_og[i] = temp
          end
          #Ingroup
          # Outgroup
          temp = (X_siezed_ig[i]/sum(punish_type2[gid.==i])).*price
          if isinf(temp) | isnan(temp)
            sg_ig[i] = 0
          else
            sg_ig[i] = temp
          end
          temp = (sg_ig[i]).*fine
          if isinf(temp) | isnan(temp)
            fp_ig[i] = 0
          else
            fp_ig[i] = temp
          end
        end

        loc = asInt.(loc)
        for i = 1:ngroups
            #Effort for normal harvests
          temp = sum(effort2[loc.==i]).*price
          if isinf(temp) | isnan(temp)
            eg[i] = 0
          else
            eg[i] = temp
          end
        end



        hg =ifelse.(isnan.(effort2./eg[loc]), 0,
           ((effort2./eg[loc]) .* X_non_siezed[loc] .- necessity) .* price)

        fc = fine*ifelse.(isnan.(effort./eg2[loc]), 0,
           ((effort./eg2[loc]) .* X[loc]) .* price)

        payoff_round = hg.*(1 .- caught3) + wl +
         sg_og[gid].*punish_type +
          sg_ig[gid].*punish_type2  +
           fp_og[gid].*punish_type +
            fp_ig[gid].*punish_type2 -
            mc1 - mc2 -
             fc.*caught - fc.*caught2 -
              travel_cost.*leakage_type -
              pol[gid] +
              eco[gid]

        payoff += payoff_round .+ baseline

    else


    ##################################################################
    ############ In a world without boundaries .... ##################

        X_non_siezed = 0 #just for reporting
        X = zeros(ngroups)

        for i in 1:ngroups
          X[i] =tech*((sum(effort[loc .== i])^a)*(K[i]/maximum(kmax))^b[i])
        end

        wl = w.*(1 .- effort)
        hg = zeros(ngroups)
        eg = zeros(ngroups)
        loc = asInt.(loc)

        for i = 1:ngroups
          temp = sum(effort2[loc.==i]).*price
          if isinf(temp) | isnan(temp)
            eg[i] = 0
          else
            eg[i] = temp
          end
        end


        hg =ifelse.(isnan.(effort./eg[loc]), 0,
           ((effort./eg[loc]) .* X[loc] .- necessity) .* price)


        payoff_round = hg + wl - travel_cost.*leakage_type  -
        pol[gid] +
        eco[gid]

        payoff += payoff_round  .+ baseline

      end

      if verbose == true println(string("Year: ", year, ", Payoff: COMPLETED ")) end

      #################################
      ####### Forest Dynamics #########

      #remove stock
      K -= X
      #regrow stock
      K += K*regrow.*(1 .- K./kmax)
      #Check to make sure stock follows logical constraints
      K .= ifelse.(K .> kmax, kmax, K)
      K .= ifelse.(K.<= 0, .01 .* kmax, K) #note that if the forest is depleted it will regrow back to the regrowth rate* max.


      if verbose == true print(string("Year: ", year, ", Regrow: COMPLETED ")) end


      ######################################
      ######### Social Learning ############

      # Prestige Biased Transmission
      if social_learning == true
        models = zeros(n)
        out = rbinom(n, 1, outgroup)
        for i = 1:n
          temp2 = id[(gid .∈ Ref(gid[i])) .== (id .!= i)]
          model_list = ifelse(out[i]==1, sample(id[1:end .!= id[i]], nmodels, replace = false),
          sample(temp2, nmodels, replace = false))
          if learn_type == "wealth"
            model_temp = model_list[findmax(payoff[model_list])[2]]
            models[i] = ifelse(payoff[model_temp] > payoff[i], model_temp, i)
          else # Now check for income learners
              model_temp = model_list[findmax(payoff_round[model_list])[2]]
              models[i] = ifelse(payoff_round[model_temp] > payoff_round[i], model_temp, i)
          end
        end # End finding models
        models = asInt.(models)


        #note that there can be eigenmodels
        trans_error = rand(n, 5) .< fidelity
        n_error = [[rand(Normal(), n)] [rand(Normal(1, .02), n)]]
        #Ensure there is no transmission error for indiviudals who did not copy
        self = models .== id
        trans_error[self,:] .=0

        #apply mutations in learning
        effort = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[models]) .+ n_error[1]), effort[models])
        leakage_type  =ifelse.(trans_error[:,2], ifelse.(leakage_type[models].==1,0,1), leakage_type[models])
        punish_type  =ifelse.(trans_error[:,3], ifelse.(punish_type[models].==1,0,1), punish_type[models])
        harv_limit = ifelse.(trans_error[:,4], harv_limit[models] .* n_error[2], harv_limit[models])
        punish_type2  =ifelse.(trans_error[:,5], ifelse.(punish_type2[models].==1,0,1), punish_type2[models])

      if verbose ==true println(string("Year: ", year, ", Social Learning: COMPLETED ")) end
      end



      ############################
      ### RUN EXPERIMENT #########
      for i = 1:length(experiment_group)
        if experiment_leak != 0
          leakage_type[gid .== experiment_group[i]] = rbinom(sum(gid.==experiment_group[i]),1, experiment_leak)
        end
        if experiment_punish1 != 0
          punish_type[gid .==experiment_group[i]] = rbinom(sum(gid.==experiment_group[i]),1, experiment_punish1)
        end
        if experiment_punish2 != 0
          punish_type2[gid .==experiment_group[i]] = rbinom(sum(gid.==experiment_group[i]),1, experiment_punish2)
        end
        if experiment_limit !=0
          harv_limit[gid .==experiment_group[i]] .=experiment_limit
        end

        if experiment_limit != 0
          effort[gid.==experiment_group[i]] .= experiment_effort
        end
      end



      #############################################
      ### Record the Year in the  History books ###

      s[year,:,sim] .= round.(K./kmax, digits=3)
      h[year,:,sim] .= round.(X, digits=2)

      e[year,:,sim] .= round.(report(effort, gid, ngroups), digits=2)
      el[year,:,sim] .= round.(report(effort[leakage_type.==1], gid[leakage_type.==1], ngroups), digits=2)
      enl[year,:,sim] .= round.(report(effort[leakage_type.==0], gid[leakage_type.==0], ngroups), digits=2)
      p[year,:,sim] .= round.(report(payoff, gid, ngroups), digits=2)
      pr[year,:,sim] .= round.(report(payoff_round, gid, ngroups), digits=2)
      lc[year,:,sim] = tab(caught[gid.==loc], ngroups)


      lc[year,:,sim] = tab(harv_limit[gid], ngroups)

      l0p0r1[year,:,sim] .= round.(report(((leakage_type.==0) .& (punish_type.==0)).& (punish_type2 .==1), gid, ngroups), digits=2)
      l1p0r1[year,:,sim] .= round.(report(((leakage_type.==1) .& (punish_type.==0)).& (punish_type2 .==1), gid, ngroups), digits=2)
      l0p1r1[year,:,sim] .= round.(report(((leakage_type.==0) .& (punish_type.==1)).& (punish_type2 .==1), gid, ngroups), digits=2)
      l1p1r1[year,:,sim] .= round.(report(((leakage_type.==1) .& (punish_type.==1)).& (punish_type2 .==1), gid, ngroups), digits=2)

      l0p0r0[year,:,sim] .= round.(report(((leakage_type.==0) .& (punish_type.==0)).& (punish_type2 .==0), gid, ngroups), digits=2)
      l1p0r0[year,:,sim] .= round.(report(((leakage_type.==1) .& (punish_type.==0)).& (punish_type2 .==0), gid, ngroups), digits=2)
      l0p1r0[year,:,sim] .= round.(report(((leakage_type.==0) .& (punish_type.==1)).& (punish_type2 .==0), gid, ngroups), digits=2)
      l1p1r0[year,:,sim] .= round.(report(((leakage_type.==1) .& (punish_type.==1)).& (punish_type2 .==0), gid, ngroups), digits=2)



      l0p0r1hl[year,:,sim] .= round.(report(harv_limit[((leakage_type.==0) .& (punish_type.==0)).& (punish_type2.==1)], gid[((leakage_type.==0) .& (punish_type.==0)).& (punish_type2.==1)], ngroups), digits=2)
      l1p0r1hl[year,:,sim] .= round.(report(harv_limit[((leakage_type.==1) .& (punish_type.==0)).& (punish_type2.==1)], gid[((leakage_type.==1) .& (punish_type.==0)).& (punish_type2.==1)], ngroups),  digits=2)
      l0p1r1hl[year,:,sim] .= round.(report(harv_limit[((leakage_type.==0) .& (punish_type.==1)).& (punish_type2.==1)], gid[((leakage_type.==0) .& (punish_type.==1)).& (punish_type2.==1)], ngroups), digits=2)
      l1p1r1hl[year,:,sim] .= round.(report(harv_limit[((leakage_type.==1) .& (punish_type.==1)).& (punish_type2.==1)], gid[((leakage_type.==1) .& (punish_type.==1)).& (punish_type2.==1)],  ngroups), digits=2)


      l0p0r0hl[year,:,sim] .= round.(report(harv_limit[((leakage_type.==0) .& (punish_type.==0)).& (punish_type2.==0)], gid[((leakage_type.==0) .& (punish_type.==0)).& (punish_type2.==0)], ngroups), digits=2)
      l1p0r0hl[year,:,sim] .= round.(report(harv_limit[((leakage_type.==1) .& (punish_type.==0)).& (punish_type2.==0)], gid[((leakage_type.==1) .& (punish_type.==0)).& (punish_type2.==0)], ngroups),  digits=2)
      l0p1r0hl[year,:,sim] .= round.(report(harv_limit[((leakage_type.==0) .& (punish_type.==1)).& (punish_type2.==0)], gid[((leakage_type.==0) .& (punish_type.==1)).& (punish_type2.==0)], ngroups), digits=2)
      l1p1r0hl[year,:,sim] .= round.(report(harv_limit[((leakage_type.==1) .& (punish_type.==1)).& (punish_type2.==0)], gid[((leakage_type.==1) .& (punish_type.==1)).& (punish_type2.==0)],  ngroups), digits=2)

    cnt = zeros(ngroups)
      for i = 1:ngroups
        if sum((gid.==i) .& (leakage_type.==0))==0
          cnt[i] = NaN
        else
          cnt[i]=mean(hg_temp[(gid.==i) .& (leakage_type.==0)] .< median(harv_limit[gid.==i]))
        end
      end


      elh[year,:,sim] .= round.(cnt, digits=2)
      l0p0r1e[year,:,sim] .= round.(report(effort[((leakage_type.==0) .& (punish_type.==0)).& (punish_type2.==1)], gid[((leakage_type.==0) .& (punish_type.==0)).& (punish_type2.==1)], ngroups), digits=2)
      l1p0r1e[year,:,sim] .= round.(report(effort[((leakage_type.==1) .& (punish_type.==0)).& (punish_type2.==1)], gid[((leakage_type.==1) .& (punish_type.==0)).& (punish_type2.==1)], ngroups),  digits=2)
      l0p1r1e[year,:,sim] .= round.(report(effort[((leakage_type.==0) .& (punish_type.==1)).& (punish_type2.==1)], gid[((leakage_type.==0) .& (punish_type.==1)).& (punish_type2.==1)], ngroups), digits=2)
      l1p1r1e[year,:,sim] .= round.(report(effort[((leakage_type.==1) .& (punish_type.==1)).& (punish_type2.==1)], gid[((leakage_type.==1) .& (punish_type.==1)).& (punish_type2.==1)],  ngroups), digits=2)


      l0p0r0e[year,:,sim] .= round.(report(effort[((leakage_type.==0) .& (punish_type.==0)).& (punish_type2.==0)], gid[((leakage_type.==0) .& (punish_type.==0)).& (punish_type2.==0)], ngroups), digits=2)
      l1p0r0e[year,:,sim] .= round.(report(effort[((leakage_type.==1) .& (punish_type.==0)).& (punish_type2.==0)], gid[((leakage_type.==1) .& (punish_type.==0)).& (punish_type2.==0)], ngroups),  digits=2)
      l0p1r0e[year,:,sim] .= round.(report(effort[((leakage_type.==0) .& (punish_type.==1)).& (punish_type2.==0)], gid[((leakage_type.==0) .& (punish_type.==1)).& (punish_type2.==0)], ngroups), digits=2)
      l1p1r0e[year,:,sim] .= round.(report(effort[((leakage_type.==1) .& (punish_type.==1)).& (punish_type2.==0)], gid[((leakage_type.==1) .& (punish_type.==1)).& (punish_type2.==0)],  ngroups), digits=2)




      pt[year,:,sim] .= round.(report(punish_type, gid, ngroups), digits=2)
      pt2[year,:,sim] .= round.(report(punish_type2, gid, ngroups), digits=2)
      lt[year,:,sim] .= round.(report(leakage_type, gid, ngroups), digits=2)
      lr[year,:,sim] .= round.(report(loc .!= gid, gid, ngroups), digits=2)

      cnt = zeros(ngroups)
      for i = 1:ngroups
        if sum(gid.==i)==0
          cnt[i] = NaN
        else
          cnt[i]=median(harv_limit[gid.==i])
        end
      end

      lmr[year,:,sim] .= round.(cnt, digits=3)

      gs2[year,:,sim] .= round.(X-X_non_siezed_ig, digits=2)
      gs[year,:,sim] .= round.(X-X_non_siezed_og, digits=2)

      lpt1[year, sim] = round.(mean(payoff_round[leakage_type.==1]), digits = 2)
      ppt1[year, sim] =  round.(mean(payoff_round[punish_type.==1]), digits = 2)
      lpt0[year, sim] = round.(mean(payoff_round[leakage_type.==0]), digits = 2)
      ppt0[year, sim] = round.(mean(payoff_round[punish_type.==0]), digits = 2)
      rpt1[year, sim] = round.(mean(payoff_round[punish_type2.==1]), digits = 2)
      rpt0[year, sim] = round.(mean(payoff_round[punish_type2.==0]), digits = 2)

      am[year, sim] = median(age)
      ma[year, sim] = maximum(age)

      grs[year,:,sim] .= round.(tab(gid, ngroups), digits =2)

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

      if experiment==true
        #ensure that the experimental group is a seperate breeding population
        pop = id[gid .∈  [experiment_group]]

        makebabies(pop, id, age, mortality_rate, payoff)
        mutatebabies(babies, mutation)

        payoff[died] .= 0
        age[died]  .= 0

        #For all other groups are part of a breeding population
        pop = id[gid .∉  [experiment_group]]
        makebabies(pop, id, age, mortality_rate, payoff)
        mutatebabies(babies, mutation)

        #CMLS dynamic

        if cmls== true  gid[died] = copy(gid[babies]) end

      else #end experiment

        makebabies(id, id, age, mortality_rate, payoff)
        mutatebabies(babies, mutation)

        #CMLS dynamic
        if cmls == true  gid[died] = gid[babies] end

    end

    #reset the wealth of the dead
    payoff[died] .= 0
    age[died]  .= 0
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

    year += 1
    end #end years
    fm[:, sim] = kmax
    ry[sim] = REDD_year

  end# end sims
  output=Dict("effort" => e,
    "stock" => s,
    "effortNl" => enl,
    "effortL" => el,
    "harvest" => h,
    "punish" => pt,
    "punish2" => pt2,
    "l0p0r0" => l0p0r0,
    "l0p1r0" => l0p1r0,
    "l1p0r0" => l1p0r0,
    "l1p1r0" => l1p1r0,
    "l0p0r1" => l0p0r1,
    "l0p1r1" => l0p1r1,
    "l1p0r1" => l1p0r1,
    "l1p1r1" => l1p1r1,
    "l0p0r1e" => l0p0r1e,
    "l0p1r1e" => l0p1r1e,
    "l1p0r1e" => l1p0r1e,
    "l1p1r1e" => l1p1r1e,
    "l0p0r0e" => l0p0r0e,
    "l0p1r0e" => l0p1r0e,
    "l1p0r0e" => l1p0r0e,
    "l1p1r0e" => l1p1r0e,

    "comp" => elh,
    "loc_caught" => lc,
    "l0p1r0hl" => l0p1r0hl,
    "l0p0r0hl" => l0p0r0hl,
    "l1p0r0hl" => l1p0r0hl,
    "l1p1r0hl" => l1p1r0hl,

    "l0p1r1hl" => l0p1r1hl,
    "l0p0r1hl" => l0p0r1hl,
    "l1p0r1hl" => l1p0r1hl,
    "l1p1r1hl" => l1p1r1hl,

    "leakage" => lt,
    "payoffR" => pr,
    "payoff_punish" => ppt1,
    "payoff_punish2" => rpt1,
    "payoff_leakage" => lpt1,
    "payoff_no_punish" => ppt0,
    "payoff_no_punish2" => rpt0,
    "payoff_no_leakage" => lpt0,
    "leakage_rate" => lr,
    "limit" => lmr,
    "age_max" => am,
    "age_mean" => ma,
    "seized" => gs,
    "seized2" => gs2,
    "forsize" => fm,
    "reddyear" => ry,
    "group_size" => grs
    )

    return(output)

end
