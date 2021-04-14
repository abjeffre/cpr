
#packages
using(Distributions)
using(DataFrames)
using(JLD)
using(Plots)



  #functions
  function logit(p)
     log(p/(1-p))
   end

function nanmean(x)
  mean(filter(!isnan, x))
end

  function inv_logit(x)
     1/(1+exp(-x))
  end

  function softmax(x)
    exp.(x)/sum(exp.(x))
  end

  function rnorm(n, mu, sd)
    rand(Normal(mu, sd), n)
  end

  function asInt(x)
    convert(Int64, x)
  end


  function rbinom(n, N, p)
    asInt.(rand(Binomial(N, p), n))
  end


  function tab(x, ngroups)
    cnt = zeros(ngroups)
    for i = 1:ngroups
      cnt[i] = sum(x.==i)
    end
    return(cnt)
  end

  function report(x, gid, ngroups)
    cnt = zeros(ngroups)
    for i = 1:ngroups
      cnt[i] = mean(x[gid .== i])
    end
    return(cnt)
  end

  function isnumber(val)
    if typeof(val)<:Number
      x  =  ifelse(isnan(val), false, true)
    else
      x = false
    end
    return(x)
  end



  # note that we use \notin
  # we also use \in
  # vectorized versions include .\in .\notin

  function standardize(x)
     (x.-mean(x))/std(x)
  end

  function distance(x)
    n = length(x)
    Dist = zeros(n,n)
    for i = 1:n, j=1:n
      cordi = findall( x -> x == i, x )
      cordj =  findall( x -> x == j, x )
      Dist[i, j] =  sqrt(abs(cordi[1][1]-cordj[1][1])^2 + abs(cordi[1][2]-cordj[1][2])^2)
    end
    return(Dist)
  end



function cpr_abm(
  nsim = 1,                  # Number of simulations per call
  nrounds = 2000,             # Number of rounds per generation
  n = 1800,                    # Size of the population
  ngroups = 40,               # Number of Groups in the population
  lattice = (5, 8),          # This controls the dimensions of the lattice that the world exists on

  mortality_rate = 0.03,      # The number of deaths per 100 people
  mutation = 0.01,            # Rate of mutation on traits

  wages = .1,                # Wage rate in other sectors - opportunity costs
  wage_growth = false,        # Do wages grow?
  wgrowth_rate =.0001,        # this is a fun parameter, we know that the average growth rate for preindustiral societies is 0.2% per year why not let wages grow and see what happens
  labor_market = false,       # This controls labor market competition
  market_size = 1,            # This controls the demand for labor in the population and is exogenous: Note that when set to 1 the wage rate equilibrates when half the population is in the labor force

  max_forest = 30000,           # Average max stock
  var_forest = 1,            # Controls the heterogeneity in forest size across diffrent groups
  degradability = 0,          # This measures how degradable a resource is(when zero the resource declines linearly with size and as it increase it degrades more quickly, if negative it decreases the rate of degredation), degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
  regrow = .01,               # the regrowth rate
  tech = 1,                # Used for scaling Cobb Douglas production function
  labor = .7,                 # The elasticity of labor on harvesting production
  price = 1,                  # This sets the price of the resource on the market
  necessity = 0,              # This sets the minimum amount of the good the household requires

  inst = true,                # Toggles whether or not punishment is active
  monitor_tech = .5,           # This controls the efficacy of monitnoring, higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i, 1, x), 0, 5), where i is the proportion of monitors in a pop
  defensibility = 46,          # This sets the minmum number of people needed
  punish_cost = 0.04,        # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs
  fine = 0.1,                 # This controls the size of the fine issued when caught, note that in a real world situation this could be recouped by the injured parties but it is not
  self_policing = true,      # Toggles if Punishers also target members of their own ingroup for harvesting over limit
  harvest_limit = 0.8,        # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate

  travel_cost =0.9,           # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
  groups_sampled = 3,         # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes


  social_learning = true,     # Toggels whether Presitge Biased Tranmission is on
  nmodels = 5,                # The number of models sampled to copy from in social learning
  fidelity = 0.01,            # This is the fidelity of social transmission
  learn_type = "income",      # Two Options - "wealth" and "income" indiviudals can choose to copy wealth or income if copy wealth they copy total overall payoffs, if copy income they copy payoffs from the previous round
  outgroup = 0.01,             # This is the probability that the individual samples from the whole population and not just his group when updating

  REDD = false,                # This controls whether or not the natural experiment REDD+ is on, if REDD is on INST must be on
  REDD_dates = 300,           # This can either be an int or vector of dates that development initative try and seed insitutions
  law = .1,                   # This controls sustainable harvesting limit when REDD+ is introduced
  num_cofma = 1,              # This controls the number of Groups that will be converted to CoFMA
  cofma_gid = nothing,           # This allows you to choose the group id - specificy a spatial identity for the ward that becomes protected.
  marginal = false,           # NOT CURRENTLY OPPERATIONAL   # This controls whether payoffs have are marginally decreasing in value
  marginal_rate = 0.5,        # this is the rate of diminishing marginal returns
  leak = true,
  verbose = false,
  seed = 1984,
  experiment_leak = false,          #THIS SETS THE VALUE OF THE OTHER GROUP LEAKAGE and Punish
  experiment_punish = false,          #THIS SETS THE VALUE OF THE OTHER GROUPS PUNISHMENT
  experiment_limit = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_effort = false,            #THIS SETS THE VALUE OF THE OTHER GROUPS LIMIT
  experiment_group = 1,
  cmls = true
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
  lt = zeros(nrounds, ngroups, nsim)
  lr = zeros(nrounds, ngroups, nsim)
  lmr = zeros(nrounds, ngroups, nsim)
  l0p0 = zeros(nrounds, ngroups, nsim)
  l0p1 = zeros(nrounds, ngroups, nsim)
  l1p0 = zeros(nrounds, ngroups, nsim)
  l1p1 = zeros(nrounds, ngroups, nsim)

  l1p1hl = zeros(nrounds, ngroups, nsim)
  l1p0hl = zeros(nrounds, ngroups, nsim)
  l0p0hl = zeros(nrounds, ngroups, nsim)
  l0p1hl = zeros(nrounds, ngroups, nsim)

  l1p1e = zeros(nrounds, ngroups, nsim)
  l1p0e = zeros(nrounds, ngroups, nsim)
  l0p0e = zeros(nrounds, ngroups, nsim)
  l0p1e = zeros(nrounds, ngroups, nsim)


  lpt1 = zeros(nrounds, nsim)
  ppt1 = zeros(nrounds, nsim)
  lpt0 = zeros(nrounds, nsim)
  ppt0 = zeros(nrounds, nsim)

  gs = zeros(nrounds, ngroups, nsim)
  grs = zeros(nrounds, ngroups, nsim)

  am = zeros(nrounds, nsim)
  ma = zeros(nrounds, nsim)
  fm = zeros(ngroups, nsim)
  ry = zeros(nsim)



  #simulations
  for sim = 1:nsim

    #############################
    #### EXPERIMENT SETUP ########
    if experiment_leak==0  experiment_leak = false end
    if experiment_punish==0  experiment_punish = false end
    if experiment_limit==0  experiment_limit = false end
    if experiment_effort==0   experiment_effort = false end
    if ((experiment_limit == 0 && experiment_leak == 0) &&
        experiment_punish== false) && experiment_effort ==false
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
      set.seed(seed)
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
    loc = zeros(n)
    #Random.seed(seed)
    age = sample(18:19, n, replace=true) #notice a small variation in age is necessary for our motrality risk measure

    #assign agent values
    #Random.seed(seed)
    effort = inv_logit.(rnorm(n,logit(.5), .15)) #THIS STARTS AROUND 50%
    #Random.seed(seed)

    harv_limit = inv_logit.(rnorm(n,logit(harvest_limit), .15))
    leak_temp =zeros(gs_init)

    leak_temp[1:asInt(ceil(gs_init/2))].=1 #50% START AS LEAKERS

    for i = 1:ngroups
    #  Random.seed(seed)
      leakage_type[gid.==i] = sample(leak_temp, gs_init)
    end

    punish_temp = zeros(gs_init)
    #Random.seed(seed)
    punish_temp[1:asInt(ceil((n/ngroups)*.1))].=1 #10%STARTS AS ENFORCERS
    for i = 1:ngroups
      #Random.seed(seed)
      punish_type[gid.==i] = sample(punish_temp, gs_init)
    end

    #set group status
    group_status = ones(ngroups)

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

      if experiment_leak != 0
        leakage_type[gid .== experiment_group] = rbinom(sum(gid.==experiment_group),1, experiment_leak)
      end
      if experiment_punish != 0
        punish_type[gid .==experiment_group] = rbinom(sum(gid.==experiment_group),1, experiment_punish)
      end

      if experiment_limit !=0
        harv_limit[gid .==experiment_group] .=experiment_limit
      end

      if experiment_limit != 0
        effort[gid.==experiment_group] .= experiment_effort
      end


      if verbose== true print(string("Mean Group 1 Leakage: ",
         mean(leakage_type[gid.==1]), " Mean Group 1 Punish: ", mean(punish_type[gid.==1])))
      end

       ############################
       #### Set up the economy ###



       # derive production elasticities
       #check how the function for labor market elasticity to the supply of labor  curve(.05-.05^((1-log(x)))^1, from = 0, to = 1), where x is the share the population in the labor pool and 1 is the market size
       w = wages
       if(labor_market == true) w = wages-wages^(1 .- log(mean((1 .- effort))))^market_size end
       a = copy(labor)


       b = 1 .- (degradability*(1 .- K/maximum(kmax))) #  The use of max(kmax) here allows for patchiness and the productivity to be measured against the total prod

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
          weights = softmax(-distances[:, gid[i]]*travel_cost)
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
        caught = asInt.(zeros(n))
        for i = 1:n
          prob_caught = cdf.(Beta(1, monitor_tech), sum(punish_type[gid .== loc[i]])/defensibility)
          if loc[i] != gid[i]
            caught[i] = rbinom(1, 1, prob_caught)[1]
          else
            if self_policing ==true
              if effort[i] >=  mean(harv_limit[gid[asInt(loc[i])]]) caught[i] = rbinom(1, 1, prob_caught)[1]
              end
            end
          end
        end


        if verbose == true println(string("Year: ", year, ", Monitoring: COMPLETED ")) end

        # calculate total harvest
        # first evaluate those caught and have their harvests removed
          #note that the if else captures the case when no individuals harvest from the location and sum would result in na

        X =zeros(ngroups)
        for i in 1:ngroups
          X[i] =tech*((sum(effort[loc .== i])^a)*(K[i]/maximum(kmax))^b[i])
        end


        #Calcualte the marignal amount of confiscated goods.
        X_non_siezed = zeros(ngroups)
        effort2 = copy(effort)
        effort2[caught.== 1] .= 0

        for i in 1:ngroups
          X_non_siezed[i] =tech*((sum(effort2[loc .== i])^a)*(K[i]/maximum(kmax))^b[i])
        end


        X_siezed = X-X_non_siezed

        if verbose ==true println(string("Year: ", year, ", Harvest: COMPLETED ")) end



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

        mc = punish_cost*punish_type # monitoring cost
        wl = w.*(1 .- effort)
        fc = fine*effort
        fp = zeros(ngroups)
        sg = zeros(ngroups)
        hg = zeros(ngroups)
        eg = zeros(ngroups)

        for i = 1:ngroups
          temp = (sum(caught[i .== loc])*fine)/sum(punish_type[i .== gid])
          if isinf(temp) | isnan(temp)
            fp[i] = 0
          else
            fp[i] = temp
          end
        end


        for i = 1:ngroups
          temp = (X_siezed[gid[i]]/sum(punish_type[gid.==gid[i]])).*price
          if isinf(temp) | isnan(temp)
            sg[i] = 0
          else
            sg[i] = temp
          end
        end

        loc = asInt.(loc)
        for i = 1:ngroups
          temp = sum(effort2[loc.==i]).*price
          if isinf(temp) | isnan(temp)
            eg[i] = 0
          else
            eg[i] = temp
          end
        end

        hg =ifelse.(isnan.(effort2./eg[loc]), 0,
           ((effort2./eg[loc]) .* X_non_siezed[loc] .- necessity) .* price)


        payoff_round = hg.*(1 .- caught) + wl + sg[gid].*punish_type + fp[gid].*punish_type - mc - fc.*caught

        payoff += payoff_round


      end


    ##################################################################
    ############ In a world without boundaries .... ##################



      if inst == false
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


        payoff_round = hg + wl

        payoff += payoff_round

      end

      if verbose == true println(string("Year: ", year, ", Payoff: COMPLETED ")) end

      #################################
      ####### Forest Dynamics #########

      #remove stock
      K -= X
      #regrow stock
      K += K*regrow.*(1 .- K./kmax)
      #Check to make sure stock follows logical constraints
      K <- ifelse.(K .> kmax, kmax, K)
      K <- ifelse.(K.<= 0, .01 .* kmax, K) #note that if the forest is depleted it will regrow back to the regrowth rate* max.


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
              model_temp = model_list[findmax(payoff[model_list])[2]]
              models[i] = ifelse(payoff[model_temp] > payoff[i], model_temp, i)
          end
        end # End finding models
        models = asInt.(models)

        #note that there can be eigenmodels
        trans_error = rand(n, 4) .< fidelity
        n_error = rand(Normal(), n, 2)

        #apply mutations in learning
        effort = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[models]) .+ n_error[:,1]), effort[models])
        leakage_type  =ifelse.(trans_error[:,2], ifelse.(leakage_type[models]==1,0,1), leakage_type[models])
        punish_type  =ifelse.(trans_error[:,3], ifelse.(punish_type[models]==1,0,1), punish_type[models])
        harv_limit = ifelse.(trans_error[:,4], inv_logit.(logit.(harv_limit[models]) .+ n_error[:,2]), harv_limit[models])

      if verbose ==true println(string("Year: ", year, ", Social Learning: COMPLETED ")) end
      end



    ############################
    ### RUN EXPERIMENT #########

      if experiment_leak != 0
        leakage_type[gid .== experiment_group] = rbinom(sum(gid.==experiment_group),1, experiment_leak)
      end
      if experiment_punish != 0
        punish_type[gid .==experiment_group] = rbinom(sum(gid.==experiment_group),1, experiment_punish)
      end

      if experiment_limit !=0
        harv_limit[gid .==experiment_group] .=experiment_limit
      end

      if experiment_limit != 0
        effort[gid.==experiment_group] .= experiment_effort
      end


      #############################################
      ### Record the Year in the  History books ###

      s[year,:,sim] .= round.(K./kmax, digits=2)
      h[year,:,sim] .= round.(X, digits=2)

      e[year,:,sim] .= round.(report(effort, gid, ngroups), digits=2)
      el[year,:,sim] .= round.(report(effort[leakage_type.==1], gid[leakage_type.==1], ngroups), digits=2)
      enl[year,:,sim] .= round.(report(effort[leakage_type.==0], gid[leakage_type.==0], ngroups), digits=2)
      p[year,:,sim] .= round.(report(payoff, gid, ngroups), digits=2)
      pr[year,:,sim] .= round.(report(payoff_round, gid, ngroups), digits=2)

      l0p0[year,:,sim] .= round.(report((leakage_type.==0) .& (punish_type.==0), gid, ngroups), digits=2)
      l1p0[year,:,sim] .= round.(report((leakage_type.==1) .& (punish_type.==0), gid, ngroups), digits=2)
      l0p1[year,:,sim] .= round.(report((leakage_type.==0) .& (punish_type.==1), gid, ngroups), digits=2)
      l1p1[year,:,sim] .= round.(report((leakage_type.==1) .& (punish_type.==1), gid, ngroups), digits=2)

      l0p0hl[year,:,sim] .= round.(report(harv_limit[(leakage_type.==0) .& (punish_type.==0)], gid[(leakage_type.==0) .& (punish_type.==0)], ngroups), digits=2)
      l1p0hl[year,:,sim] .= round.(report(harv_limit[(leakage_type.==1) .& (punish_type.==0)], gid[(leakage_type.==1) .& (punish_type.==0)], ngroups),  digits=2)
      l0p1hl[year,:,sim] .= round.(report(harv_limit[(leakage_type.==0) .& (punish_type.==1)], gid[(leakage_type.==0) .& (punish_type.==1)], ngroups), digits=2)
      l1p1hl[year,:,sim] .= round.(report(harv_limit[(leakage_type.==1) .& (punish_type.==1)], gid[(leakage_type.==1) .& (punish_type.==1)],  ngroups), digits=2)


      l0p0e[year,:,sim] .= round.(report(effort[(leakage_type.==0) .& (punish_type.==0)], gid[(leakage_type.==0) .& (punish_type.==0)], ngroups), digits=2)
      l1p0e[year,:,sim] .= round.(report(effort[(leakage_type.==1) .& (punish_type.==0)], gid[(leakage_type.==1) .& (punish_type.==0)], ngroups),  digits=2)
      l0p1e[year,:,sim] .= round.(report(effort[(leakage_type.==0) .& (punish_type.==1)], gid[(leakage_type.==0) .& (punish_type.==1)], ngroups),  digits=2)
      l1p1e[year,:,sim] .= round.(report(effort[(leakage_type.==1) .& (punish_type.==1)], gid[(leakage_type.==1) .& (punish_type.==1)],  ngroups), digits=2)




      pt[year,:,sim] .= round.(report(punish_type, gid, ngroups), digits=2)
      lt[year,:,sim] .= round.(report(leakage_type, gid, ngroups), digits=2)
      lr[year,:,sim] .= round.(report(loc .!= gid, gid, ngroups), digits=2)
      lmr[year,:,sim] .= round.(report(harv_limit, gid, ngroups), digits=2)
      gs[year,:,sim] .= round.(X-X_non_siezed, digits=2)

      lpt1[year, sim] = round.(mean(payoff_round[leakage_type.==1]), digits = 2)
      ppt1[year, sim] =  round.(mean(payoff_round[punish_type.==1]), digits = 2)
      lpt0[year, sim] = round.(mean(payoff_round[leakage_type.==0]), digits = 2)
      ppt1[year, sim] = round.(mean(payoff_round[punish_type.==0]), digits = 2)

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

      payoff = ifelse.(payoff .<= 0, 0, payoff)

      if experiment==true
        #ensure that the experimental group is a seperate breeding population
        pop = id[gid.==experiment_group]

        mortality_risk = softmax(standardize(age[pop].^5) .- standardize(payoff[pop].^.25))
        to_die = asInt(round(mortality_rate*n *((ngroups-1)/ngroups), digits =0))
        died = wsample(id[pop], mortality_risk, to_die)
        sample_payoff = ifelse.(payoff .!=0, payoff, 0)
        # if all(sample_payoff .<= 0)  break end #CHECK
        pos_parents = id[(id .∈ Ref(pop)) .== (id .∉ Ref(died))]
        pos_payoff = sample_payoff[pos_parents]
        babies = wsample(pos_parents, pos_payoff, length(died), replace = true)

        #note that there can be eigenmodels
        trans_error = rand(length(babies), 4) .< mutation
        n_error = rand(Normal(), length(babies), 2)

        #apply mutations in learning
        effort[babies] = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[babies]) .+ n_error[:,1]), effort[babies])
        leakage_type[babies]  =ifelse.(trans_error[:,2], ifelse.(leakage_type[babies]==1,0,1), leakage_type[babies])
        punish_type[babies]  =ifelse.(trans_error[:,3], ifelse.(punish_type[babies]==1,0,1), punish_type[babies])
        harv_limit[babies] = ifelse.(trans_error[:,4], inv_logit.(logit.(harv_limit[babies]) .+ n_error[:,2]), harv_limit[babies])



        #For all other groups are part of a breeding population

        pop = id[gid.!=experiment_group]

        mortality_risk = softmax(standardize(age[pop].^5) .- standardize(payoff[pop].^.25))
        to_die = asInt(round(mortality_rate*n *((ngroups-1)/ngroups), digits =0))
        died = wsample(id[pop], mortality_risk, to_die)
        sample_payoff = ifelse.(payoff .!=0, payoff, 0)
        # if all(sample_payoff .<= 0)  break end #CHECK
        pos_parents = id[(id .∈ Ref(pop)) .== (id .∉ Ref(died))]
        pos_payoff = sample_payoff[pos_parents]
        babies = wsample(pos_parents, pos_payoff, length(died), replace = true)

        #note that there can be eigenmodels
        trans_error = rand(length(babies), 4) .< mutation
        n_error = rand(Normal(), length(babies), 2)

        #apply mutations in learning
        effort[babies] = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[babies]) .+ n_error[:,1]), effort[babies])
        leakage_type[babies]  =ifelse.(trans_error[:,2], ifelse.(leakage_type[babies]==1,0,1), leakage_type[babies])
        punish_type[babies]  =ifelse.(trans_error[:,3], ifelse.(punish_type[babies]==1,0,1), punish_type[babies])
        harv_limit[babies] = ifelse.(trans_error[:,4], inv_logit.(logit.(harv_limit[babies]) .+ n_error[:,2]), harv_limit[babies])


        #CMLS dynamic - new babies enter the group of the parent - in non-cmls the babies stay as a part of died group.
        if cmls== true  gid[died] = copy(gid[babies]) end



      else #end experiment

        #NON Experiment Breeding Dynamics

        mortality_risk = softmax(standardize(age.^5) .- standardize(payoff.^(.25)))
        to_die = asInt(round(mortality_rate*n, digits =0))
        died = wsample(id, mortality_risk, to_die)
        sample_payoff = ifelse.(payoff .!=0, payoff, 0)
        # if all(sample_payoff .<= 0)  break end #CHECK
        pos_parents = asInt.(id[id .∉ Ref(died)])
        pos_payoff = convert.(Float64, vec(sample_payoff[pos_parents]))
        #if verbose == true println(string("pos_parents: ", round.(pos_parents, digits =2), ", pos_payoff: ", round.(pos_payoff, digits = 2), ", size: ",  length(died)))end
        babies = wsample(pos_parents, pos_payoff, length(died), replace = true)

        trans_error = rand(length(babies), 4) .< mutation
        n_error = rand(Normal(), length(babies), 2)

        #apply mutations in learning
        effort[babies] = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[babies]) .+ n_error[:,1]), effort[babies])
        leakage_type[babies]  =ifelse.(trans_error[:,2], ifelse.(leakage_type[babies]==1,0,1), leakage_type[babies])
        punish_type[babies]  =ifelse.(trans_error[:,3], ifelse.(punish_type[babies]==1,0,1), punish_type[babies])
        harv_limit[babies] = ifelse.(trans_error[:,4], inv_logit.(logit.(harv_limit[babies]) .+ n_error[:,2]), harv_limit[babies])


        #CMLS dynamic - new babies enter the group of the parent - in non-cmls the babies stay as a part of died group.
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
    "l0p0" => l0p0,
    "l0p1" => l0p1,
    "l1p0" => l1p0,
    "l1p1" => l1p1,
    "l0p0e" => l0p0e,
    "l0p1e" => l0p1e,
    "l1p0e" => l1p0e,
    "l1p1e" => l1p1e,
    "l0p0hl" => l0p0hl,
    "l0p1hl" => l0p1hl,
    "l1p0hl" => l1p0hl,
    "l1p1hl" => l1p1hl,
    "leakage" => lt,
    "payoffR" => pr,
    "payoff_punish" => ppt1,
    "payoff_leakage" => lpt1,
    "payoff_no_punish" => ppt0,
    "payoff_no_leakage" => lpt0,
    "leakage_rate" => lr,
    "limit" => lmr,
    "age_max" => am,
    "age_mean" => ma,
    "seized" => gs,
    "forsize" => fm,
    "reddyear" => ry,
    "group_size" => grs
    )

    return(output)

end
