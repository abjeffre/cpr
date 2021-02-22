#######################################################################
############### CPR Insitution Dist ###################################


# production function
# assumption 1: for a given level of stock each additional unit of labor will decrease with the total labor expenditure. 
# assumption 2: marginal returns on aggreate labor are a function of current resource stock. 
# assumption 3: The aggregate harvest is assumed to exceed total effort cost (wX) up until some point because costs increase linearly
# assumption 4: the share of total harvest given to any individual is proportional to the share their effort in total effort 
# in short ui = xi/X*f(X) -wxi
# where f(X) = H(X, K) 
# where H is total harvest at that that time step
# X is the aggreagate amount of labor supplied
# K is the current amount of the resource. 
# and wxi is effort cost. 
# note that w can be set to the expected wage rate in the rest of the population. 

# I think we can then define total output as
# H = (X^a)*b
# a = (1 - sum(Xcurrent/Xmax)/n)
# b = Kcurrent/Kmax
# note that we must measure effort as proportion of total effort that could be dedicated to the thing in the given time step.     




cpr_institution_abm <- function(
  nsim = 10,                  # Number of simulations per call
  nrounds = 1000,             # Number of rounds per generation
  mortality_rate = 0.03,      # The number of deaths per 100 people
  n = 150,                    # Size of the population
  ngroups = 15,               # Number of Groups in the population
  max_forest = 200,           # Average max stock
  var_forest = 50,            # Controls the heterogeneity in forest size across diffrent groups
  wages = .05,                # Wage rate in other sectors - opportunity costs
  wage_growth = FALSE,        # Do wages grow?
  wgrowth_rate =.0001,        # this is a fun parameter, we know that the average growth rate for preindustiral societies is 0.2% per year why not let wages grow and see what happens  
  degradability = 0,          # This measures how degradable a resource is(when zero the resource declines linearly with size and as it increase it degrades more quickly, if negative it decreases the rate of degredation), degradable resource means that as the resouce declines in size beyond its max more additional labor is required to harvest the same amount
  regrow = .05,               # the regrowth rate
  mutation = 0.01,            # Rate of mutation on traits
  tech = 0.05,                # Used for scaling Cobb Douglas production function
  labor = .5,                 # The elasticity of labor on harvesting production
  labor_market = FALSE,       # This controls labor market competition
  market_size = 1,            # This controls the demand for labor in the population and is exogenous: Note that when set to 1 the wage rate equilibrates when half the population is in the labor force
  lattice = c(3, 5),          # This controls the dimensions of the lattice that the world exists on
  inst = TRUE,                # Toggles whether or not punishment is active
  monitor_tech = 1,           # This controls the efficacy of monitnoring, higher values increase the detection rate -  to understand the functio check plot(curve(pbeta(i, 1, x), 0, 5), where i is the proportion of monitors in a pop 
  defensibility = 15,          # This sets the minmum number of people needed 
  punish_cost = 0.001,        # This is the cost that must be paid for individuals <0 to monitor their forests - For the default conditions this is about 10 percent of mean payoffs 
  travel_cost =0.1,           # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
  groups_sampled = 3,         # When leakers sample candidate wards to visit they draw this number of groups to compare forest sizes                
  social_learning = TRUE,     # Toggels whether Presitge Biased Tranmission is on
  nmodels = 3,                # The number of models sampled to copy from in social learning
  fidelity = 0.01,            # This is the fidelity of social transmission
  fine = 0.5,                 # This controls the size of the fine issued when caught, note that in a real world situation this could be recouped by the injured parties but it is not
  self_policing = FALSE,      # Toggles if Punishers also target members of their own ingroup for harvesting over limit
  harvest_limit = 0.8,        # This is the average harvest limit. If a person is a punisher it controls the max effort a person is allowed to allocate
  outgroup = 0.1,             # This is the probability that the individual samples from the whole population and not just his group when updating
  
  REDD = FALSE,                # This controls whether or not the natural experiment REDD+ is on, if REDD is on INST must be on 
  REDD_dates = 200,           # This can either be an int or vector of dates that development initative try and seed insitutions
  law = .1,                   # This controls sustainable harvesting limit when REDD+ is introduced
  num_cofma = 1,               # This controls the number of Groups that will be converted to CoFMA
  marginal = FALSE,           #NOT CURRENTLY OPPERATIONAL   # This controls whether payoffs have are marginally decreasing in value
  marginal_rate = 0.5,         # this is the rate of diminishing marginal returns
  leak = TRUE
  ){
  
  #check group size
  if(n%%ngroups != 0) stop("n is not evenly divisible by ngroups")
  
  #functions
  logit <- function (p) log(p/(1-p))
  inv_logit <- function (x) 1/(1+exp(-x)) 
  softmax <- function(x) {exp(x)/sum(exp(x))}
  sigmoid01 <- function(x, b =.5){
    if(!b > 0) stop("b must be positive")
    1/(1+(x/(1-x))^(-b))
  }
  standardize <- function(x) (x-mean(x))/sd(x)
  distance <- function(x){
    n <- length(x)
    distance <- matrix(ncol = n, nrow = n)
    for(i in 1:n){
      for(j in 1:n){
        cordi <- which(x == i, arr.ind = T)
        cordj <-  which(x == j, arr.ind = T)
        distance[i, j] <-  sqrt(abs(cordi[1]-cordj[1])^2 + abs(cordi[2]-cordj[2])^2)   
      }
    }
    return(distance)
  }
  
  if(REDD ==TRUE){
    if(inst != TRUE) {
      warning("If REDD+ is on Institutions will be set to true")
      inst == TRUE
    }
  }
  
  ################################################
  ##### The multiverse will be recorded  #########
  
  e <- list()
  p <- list()
  s <- list() 
  wa <- list()
  h <- list()
  lt <- list()
  pt <- list()
  lpt1 <- list()
  ppt1 <- list()
  lpt0 <- list()
  ppt0 <- list()
  lr <- list()
  lmr <- list()
  am <- list()
  ma <- list()
  gs <- list()
  fm <- list()
  
  #simulations
  for (sim in 1:nsim){
    
    #############################
    ##### Create the world ######
    
    world <- matrix(1:ngroups, lattice)
    if(length(world) != ngroups) stop("the world is not built for your groups, check lattice and group size")
    #measure the distance between them
    distances <- distance(world)
    
    #make the forests and DIVIDE them amongst the groups
    kmax <- rnorm(ngroups, max_forest, var_forest)/ngroups
    kmax <- ifelse(kmax < 0, max_forest, kmax)
    K <- kmax 
    
    
    ###############################
    #### Make the history books ###
    
    # histories   
    stock <- matrix(NA, ncol = ngroups, nrow = nrounds)
    harvest <- rep(NA, nrounds)
    wage <- rep(NA, nrounds)
    effort_h <- rep(NA, nrounds)
    payoff_h <- rep(NA, nrounds)
    punish_h <- matrix(NA, ncol = ngroups, nrow = nrounds)
    leakage_h <-matrix(NA, ncol = ngroups, nrow = nrounds)
    payoff_punish_h <- rep(NA, nrounds)
    payoff_leakage_h <-rep(NA, nrounds)
    payoff_no_punish_h <-rep(NA, nrounds)
    payoff_no_leakage_h <-rep(NA, nrounds)
    leakage_rate_h <- rep(NA, nrounds)
    limit_h <- matrix(NA, ncol = ngroups, nrow = nrounds)
    age_h <- rep(NA, nrounds)
    age_mean <- rep(NA, nrounds)
    seized <- matrix(NA, ncol = ngroups, nrow = nrounds)
    forest_size <- rep(NA, ngroups)
    
    ################################
    ### Give birth to humanity #####
    
    # agent values
    id <- 1:n
    gid <- rep(1:ngroups, n/ngroups)
    effort <- rep(NA, n)
    leakage_type <- rep(NA, n)
    punish_type <- rep(NA, n)
    loc <- rep(NA, n)
    age <- sample(18:19, n, replace=TRUE) #notice a small variation in age is necessary for our motrality risk measure
    
    #assign agent values
    effort <- rbeta(n, 1, 1)
    beta <- 1/harvest_limit- 1 
    harv_limit <- rbeta(n, 1, beta)
    leakage_type <- rbinom(n, 1, 0.5)
    punish_type <- rbinom(n, 1, .1)
    
    
    
    
    ############################################
    ############# begin years ##################
    
    year <- 1
    payoff <- rep(0, n)
    
    for(t in 1:nrounds){
      payoff_round <- rep(0, n)  
      
      ############################
      ########Check Config #######
      
      if(leak == FALSE) leakage_type <- rep(0, n)
      
      ############################
      #### Set up the economy ###
      
      # derive production elasticities
      #check how the function for labor market elasticity to the supply of labor  curve(.05-.05^((1-log(x)))^1, from = 0, to = 1), where x is the share the population in the labor pool and 1 is the market size
      w <- wages
      if(labor_market == TRUE) w <- wages-wages^(1-log(mean((1-effort))))^market_size
      a <- labor
      
      
      b <- 1-(degradability*(1-K/max(kmax))) #  The use of max(kmax) here allows for patchiness and the productivity to be measured against the total prod     
      
      
      #######################
      ##### Agents act ######
      
      #individuals choose harvest patch
      for (i in 1:n){
        # For Leakage Types, they nominate a number of patches set by groups_sampled, which are sampled in accordance with their distance, 
        # the distance is scaled by travel costs and basically just means individuals will travel further away.  
        # Once a set of proposals have been nominated, the individual chooses the forest with the most remaining forest, and travel there to harvest
        # note that we have an linear travel costs
        # Also indiviudals who are not leakage types simply harvest from their own patches
        proposal <- sample((1:ngroups)[-gid[i]], groups_sampled,  softmax(-(distances[,gid[i]][-gid[i]]*travel_cost)), replace = FALSE)        
        loc[i] <- ifelse(leakage_type[i]==1, proposal[which.max(K[proposal])], gid[i])
      }
      
      
      
      #######################################################################
      #### When people are willing to exclude foreigners ... ################
      
      if(inst == TRUE){
        
        # Check to see if individuals who harvest outside their patch are caught
        # Check to see if individuals who are harvesting in their patch are not harvesting above the groups limit
        # prob = the proportion of punishers in the group - scaled by some elasticity that controls monitoring efficiency
        # The monitoring tech is such that p = plot(curve(pbeta(x, i, 1) 
        # we can also use(n_punish^a/n) where a is monitoring tech and any value below one will produce and increasing concave function 
        caught <- rep(0, n)
        for(i in 1:n){
          prob_caught <- pbeta(sum(punish_type[gid == loc[i]])/defensibility , 1, monitor_tech)
          if(loc[i] != gid[i]){
            caught[i] <- rbinom(1, 1, prob_caught)
          }else{
            if(self_policing ==TRUE){
              if(effort[i] >=  (mean(harv_limit[gid[loc[i]]]))) caught[i] <- rbinom(1, 1, prob_caught)
            }
          }
        }
        # calculate total harvest
        # first evaluate those caught and have their harvests removed
        X <- rep(0, ngroups)
        #note that the if else captures the case when no individuals harvest from the location and sum would result in na
        for (i in 1:ngroups) X[i] = ifelse(is.numeric(tech*sum(effort[loc == i])^a*(K[i]^b[i])), tech*sum(effort[loc == i])^a*(K[i]^b[i]), 0)
        
        #Calcualte the marignal amount of confiscated goods. 
        X_non_siezed <- rep(0, ngroups)
        effort2 <- ifelse(caught == 1, 0, effort)
        for (i in 1:ngroups) X_non_siezed[i] = ifelse(is.numeric(tech*sum(effort2[loc == i])^a*(K[i]^b[i])), tech*sum(effort2[loc == i])^a*(K[i]^b[i]), 0)
        X_siezed <- X-X_non_siezed
        
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
        for(i in 1:n){
          
          if(caught[i] == 1 ){ 
            payoff_round[i] <- w*(1-effort[i]) - punish_cost*punish_type[i] - fine*effort[i] + X_siezed[gid[i]]/sum(gid==gid[i])
            payoff[i]<- payoff_round[i] + payoff[i] 
          }else{
            payoff_round[i] <- ifelse(is.nan(effort2[i]/sum(effort2[loc == loc[i]])), 0, effort2[i]/sum(effort2[loc == loc[i]]))*X_non_siezed[loc[i]] + w*(1-effort[i]) - punish_cost*punish_type[i] + X_siezed[gid[i]]/sum(gid==gid[i])
            payoff[i]<- payoff_round[i] + payoff[i] 
          }
          
        }#end payoff loop
      }#End insitutions
      
      ##################################################################
      ############ In a world without boundaries .... ##################
      
      
      
      if(inst == FALSE){
        X_non_siezed <- 0 #just for reporting 
        # caclulate total production 
        X <- rep(0, ngroups)
        for (i in 1:ngroups) X[i] = tech * ifelse(is.numeric(sum(effort[loc == i])), sum(effort[loc == i]), 0)^a * (K[i]^b[i])
        #derive inv payoff
        for(i in 1:n){ 
          payoff_round [i] <- (effort[i]/sum(effort[loc == loc[i]]))*X[loc[i]] + w*(1-effort[i])
          payoff_round[i] <- ifelse(is.nan(effort[i]/sum(effort[loc == loc[i]])), 0, effort[i]/sum(effort[loc == loc[i]]))*X[loc[i]] + w*(1-effort[i])
          payoff [i]<- payoff_round[i] + payoff[i] 
        }
      }#end free travel
      
      
      
      #################################################################
      ######################## Diminishing Marginal Retruns ##########
      
      payoff <- payoff +1
      if(marginal == TRUE){
        
        payoff <- payoff^marginal_rate
      }
      
      #################################
      ####### Forest Dynamics #########
      
      #remove stock
      K <- K - X
      #regrow stock
      K <- K + K*regrow*(1-K/kmax)
      #Check to make sure stock follows logical constraints
      K <- ifelse(K > kmax, kmax, K)
      K <- ifelse(K <= 0, regrow*kmax, K) #note that if the forest is depleted it will regrow back to the regrowth rate* max.
      
      
      
      
      ######################################
      ############## ERROR CHECK ###########
      
      if(all(is.numeric(payoff)==FALSE)) {
        
        
        stock[year,] <- round(K/kmax,2)
        harvest[year] <- mean((effort/sum(effort))*sum(X_non_siezed))
        wage[year] <- mean(w*(1-effort))
        effort_h[year] <- mean(effort)
        payoff_h[year] <- mean(payoff_round)
        payoff_leakage_h[year] <- mean(payoff_round[leakage_type==1])
        payoff_punish_h[year] <- mean(payoff_round[punish_type==1])
        payoff_no_leakage_h[year] <- mean(payoff_round[leakage_type==0])
        payoff_no_punish_h[year] <- mean(payoff_round[punish_type==0])
        leakage_rate_h[year] <- mean(loc != gid)
        punish_h[year,] <- round(sapply(split(punish_type, as.factor(gid)), mean),2)
        leakage_h[year,] <- round(sapply(split(leakage_type, as.factor(gid)), mean),2)
        limit_h[year,] <-  round(sapply(split(harv_limit, as.factor(gid)), mean),2)
        seized[year,] <-  round(X-X_non_siezed,2)
        age_mean[year] <- median(age)
        age_h[year] <-max(age)
        forest_size <- kmax
        
        
        e[[sim]] <- effort_h
        p[[sim]] <- payoff_h
        pt[[sim]] <- punish_h
        lt[[sim]] <- leakage_h
        ppt1[[sim]] <- payoff_punish_h
        lpt1[[sim]] <- payoff_leakage_h
        ppt0[[sim]] <- payoff_no_punish_h
        lpt0[[sim]] <- payoff_no_leakage_h
        s[[sim]] <- stock
        wa[[sim]] <- wage
        h[[sim]] <- harvest
        lr[[sim]] <- leakage_rate_h
        lmr[[sim]] <- limit_h
        am[[sim]] <- age_h
        ma[[sim]] <- age_mean
        gs[[sim]] <- seized
        fm[[sim]] <- forest_max
        return(output)
        break
        
      }
      
      
      ###################################### 
      ######### Social Learning ############
      
      # Prestige Biased Transmission
      if(social_learning == TRUE){
        models <- rep(NA, n)
        for(i in 1:n){
          model_list <- ifelse(rbinom(1, 1, outgroup)==1, sample(id[-i], nmodels, replace = FALSE), sample(id[gid[i]==gid][-which(which(gid==gid[i])==i)], nmodels, replace = FALSE))
          model_temp<- model_list[which.max(payoff[model_list])] 
          models[i] <- ifelse(payoff[model_temp] > payoff[i], model_temp, i)
        } # End finding models
        
        for(i in 1:n){
          # Update Type and Account for Transmission Fidelity
          effort[i] <- ifelse(models[i] == id[i], effort[i], ifelse(runif(1,0, 1) < fidelity, inv_logit(logit(effort[models[i]])+rnorm(1, 0, 1)), effort[models[i]]))
          leakage_type[i] <- ifelse(models[i] == id[i], leakage_type[i], ifelse(runif(1,0, 1) < fidelity, ifelse(leakage_type[models[i]]==1, 0, 1), leakage_type[models[i]]))
          punish_type[i] <-  ifelse(models[i] == id[i], punish_type[i], ifelse(runif(1,0, 1) < fidelity, ifelse(punish_type[models[i]]==1, 0, 1), punish_type[models[i]]))
          harv_limit[i] <-  ifelse(models[i] == id[i], harv_limit[i], ifelse(runif(1,0, 1) < fidelity, inv_logit(logit(harv_limit[models[i]])+rnorm(1, 0, 1)), harv_limit[models[i]]))
        }#End updating
      } #End Social Learning Block
      
      #############################################
      ### Record the Year in the  History books ###
      
      
      
      
      stock[year,] <- round(K/kmax,2)
      harvest[year] <- mean((effort/sum(effort))*sum(X_non_siezed))
      wage[year] <- mean(w*(1-effort))
      effort_h[year] <- mean(effort)
      payoff_h[year] <- mean(payoff_round)
      payoff_leakage_h[year] <- mean(payoff_round[leakage_type==1])
      payoff_punish_h[year] <- mean(payoff_round[punish_type==1])
      payoff_no_leakage_h[year] <- mean(payoff_round[leakage_type==0])
      payoff_no_punish_h[year] <- mean(payoff_round[punish_type==0])
      leakage_rate_h[year] <- mean(loc != gid)
      punish_h[year,] <- round(sapply(split(punish_type, as.factor(gid)), mean),2)
      leakage_h[year,] <- round(sapply(split(leakage_type, as.factor(gid)), mean),2)
      limit_h[year,] <-  round(sapply(split(harv_limit, as.factor(gid)), mean),3)
      seized[year,] <-  round(X-X_non_siezed,2)
      age_mean[year] <- median(age)
      age_h[year] <-max(age)
      forest_size <- kmax
      
      
      
      if(all(payoff <= 0)) break
      
      ##############################################
      ###### Impose Insitutions ####################
      
      
      if(REDD == TRUE){
        if(year %in% REDD_dates){
          cofmas <-sample(gid, num_cofma, replace = FALSE)
          punish_type[gid %in% cofmas] <- 1
          harv_limit[gid %in% cofmas] <- law
        }
      }
      
      
      
      
      #########################################
      ############# GENERAL UPDATING ##########
      
      
      wages <- wages*wgrowth_rate + wages
      if(wages >=1) wages <-.99
      year <- 1 + year
      age <- age+1
      
      
      
      ####################################
      ###### Evolutionary dynamics #######
      
      
      
      #pick indiviudals to die and those to give birth
      mortality_risk <- softmax(standardize(age^5) - standardize(payoff^.25))
      died <- sample(id, round(mortality_rate*n, 0), prob = mortality_risk)
      sample_payoff <- ifelse(payoff >0, payoff, 0)
      if(all(sample_payoff <= 0)) break
      babies <- sample(id[-died], round(mortality_rate*n, 0), prob = sample_payoff[-died], replace = T)
      
      for(i in 1:length(died)){ 
        effort[died[i]] <- ifelse(runif(1,0, 1) < mutation, inv_logit(logit(effort[babies[i]])+rnorm(1, 0, 1)),  effort[babies[i]])
        harv_limit[died[i]] <- ifelse(runif(1,0, 1) < mutation, inv_logit(logit(harv_limit[babies[i]])+rnorm(1, 0, 1)),  harv_limit[babies[i]])
        leakage_type[died[i]] <- ifelse(runif(1,0, 1) < mutation, ifelse(leakage_type[babies[i]]==1, 0, 1),  leakage_type[babies[i]])
        punish_type[died[i]] <- ifelse(runif(1,0, 1) < mutation, ifelse(punish_type[babies[i]]==1, 0, 1),  punish_type[babies[i]])
      }#end evolutionary dynamics
      
      #reset the wealth of the dead
      payoff[died] <- 0
      age[died] <-0
      
    }# end rounds 
    
    
    #########################################
    
    e[[sim]] <- effort_h
    p[[sim]] <- payoff_h
    pt[[sim]] <- punish_h
    lt[[sim]] <- leakage_h
    ppt1[[sim]] <- payoff_punish_h
    lpt1[[sim]] <- payoff_leakage_h
    ppt0[[sim]] <- payoff_no_punish_h
    lpt0[[sim]] <- payoff_no_leakage_h
    s[[sim]] <- stock
    wa[[sim]] <- wage
    h[[sim]] <- harvest
    lr[[sim]] <- leakage_rate_h
    lmr[[sim]] <- limit_h
    am[[sim]] <- age_h
    ma[[sim]] <- age_mean
    gs[[sim]] <- seized
    fm[[sim]] <- forest_size
  }# end sims 
  
  
  #########################################################
  ####### Put all the little universes all in one place ###
  output <- list(effort =e,
                 payoff =p,
                 stock = s,
                 harvest= h,
                 wages = wa,
                 punish = pt,
                 leakage = lt,
                 payoff_punish = ppt1,
                 payoff_leakage = lpt1,
                 payoff_no_punish = ppt0,
                 payoff_no_leakage = lpt0,
                 leakage_rate = lr,
                 limit = lmr,
                 age_max = am,
                 age_mean = ma,
                 seized = gs,
                 forsize = fm)
  return(output)
}# END INSITITUIONS
