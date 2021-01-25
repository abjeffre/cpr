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
  nrounds = 45,               # Number of rounds per generation
  ngen = 100,                 # Number of generations per simulation
  n = 150,                    # Size of the population
  ngroups = 15,               # Number of Groups in the population
  max_forest = 100,           # Average max stock
  var_forest = 10,            # Controls the heterogeneity in forest size across diffrent groups
  w = .05,                    # Wage rate in other sectors - opportunity costs
  regrow = .05,               # the regrowth rate
  mutation = 0.01,            # Rate of mutation on traits
  tech = 0.05,                # Used for scaling Cobb Douglas production function
  labor = .5,                 # The elasticity of labor on production
  labor_market = F,           # This controls labor market competition
  market_size = 1,            # This controls the demand for labor in the population and is exogenous
  lattice = c(3, 5),          # This controls the dimensions of the lattice that the world exists on
  inst = TRUE,                # Toggles whether or not punishment is active
  monitor_tech = 1,           # This controls the efficacy of monitnoring
  punish_cost = 0.05,         # This is the cost that must be paid for individuals wish to monitor their forests - For the default conditions this is about 10 percent of mean payoffs 
  travel_cost =1,             # This basically controls the travel time for individuals who travel to neightboring communities to steal from Note that higher values mean less leakage
  social_learning = TRUE,     # Toggels wether Presitge Biased Tranmission is on
  nmodels = 3,                # The number of models sampled to copy from in social learning
  fidelity = 0.01,            # This is the fidelity of social transmission
  fine = 0                    # This controls the size of the fine issued when caught, note that in a real world situation this could be recouped by the injured parties but it is not
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
  
  ################################################
  ##### The multiverse will be recorded  #########
  
  e <- list()
  p <- list()
  s <- list() 
  wa <- list()
  h <- list()
  lt <- list()
  pt <- list()
  lr <- list()
  
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
    stock <- matrix(NA, ncol = ngroups, nrow = ngen*nrounds)
    harvest <- rep(NA, ngen*nrounds)
    wage <- rep(NA, ngen*nrounds)
    effort_h <- rep(NA, ngen*nrounds)
    payoff_h <- rep(NA, ngen*nrounds)
    punish_h <- rep(NA, ngen*nrounds)
    leakage_h <-rep(NA, ngen*nrounds)
    leakage_rate_h <- rep(NA, ngen*nrounds)
    
    ################################
    ### Give birth to humanity #####
    
    # agent values
    id <- 1:n
    gid <- rep(1:ngroups, n/ngroups)
    effort <- rep(NA, n)
    leakage_type <- rep(NA, n)
    punish_type <- rep(NA, n)
    loc <- rep(NA, n)
    
    
    #assign agent values
    effort <- rbeta(n, 1, 1)
    leakage_type <- rbinom(n, 1, 0.5)
    punish_type <- rbinom(n, 1, .1)
    
    
    ##############################################  
    ########## begin generations #################
    year <- 1
    for(g in 1:ngen){
      #reset payoffs
      payoff <- rep(0, n)
      
      
      ############################################
      ############# begin years ##################
      
      
      for(t in 1:nrounds){
        
        
        ############################
        #### Set up the economy ###
        
        # derive production elasticities
        a <- labor
        b <- K/kmax     
        if(labor_market == TRUE) c <- 1-(sum(effort)/n)^(1/market_size)
        
        
        #######################
        ##### Agents act ######
        
        #individuals choose harvest patch
        for (i in 1:n){
          #individuals nominate a single alternative patch, if the patch has a higher value than their current patch they will then travel there FREELY
          # and harvest
          # note that we have an linear travel costs
          proposal <- which(rmultinom(1, 1,  softmax(-(distances[,gid[i]]*travel_cost))) ==1) 
          loc[i] <- ifelse(leakage_type[i]==1, ifelse(K[proposal] > K[gid[i]], proposal, gid[i]), gid[i])
        }
        
        
        
        #######################################################################
        #### In a world where people are willing to exclude foreigners ... ####
        
        if(inst == TRUE){
          
          # Check to see if individuals who harvest outside their patch are caught
          # prob = the proportion of punishers in the group - scaled by some elasticity that controls monitoring efficiency
          # note that we can play around with the shape of the probability - right now I have it set as some sigmoidal 
          # we can also use(n_punish^a/n) where a is monitoring tech and any value below one will produce and increasing concave function 
          caught <- rep(0, n)
          for(i in 1:n){
            prob_caught <- sigmoid01(sum(punish_type[gid == loc[i]])/sum(gid == loc[i]), monitor_tech)
            if(loc[i] != gid[i]) caught[i] <- rbinom(1, 1, prob_caught)
          }
          
          # calculate total harvest
          # first evaluate those caught and have their harvests removed
          X <- rep(0, ngroups)
          for (i in 1:ngroups) X[i] = tech*sum(effort[loc == i])^a*(K[i]^b[i])
          
          #Calcualte the marignal amount of confiscated goods. 
          X_non_siezed <- rep(0, ngroups)
          effort2 <- ifelse(caught == 1, 0, effort)
          for (i in 1:ngroups) X_non_siezed[i] = tech*sum(effort2[loc == i])^a*(K[i]^b[i])
          X_siezed <- X-X_non_siezed
          
          
          
          
          
          ################################
          ##### Calculate payoffs ########
          
          for(i in 1:n){
            
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
            
            # for labor market off
            if(labor_market == FALSE){  
              if(caught[i] == 1 ){ payoff[i] <- w*(1-effort[i]) + payoff[i] - punish_cost*punish_type[i] - fine*effort[i] + X_siezed[gid[i]]/sum(gid==gid[i])
              }else{
                payoff[i] <- (effort2[i]/sum(effort2[loc == loc[i]]))*X_non_siezed[loc[i]] + w*(1-effort[i]) + payoff[i] - punish_cost*punish_type[i] + X_siezed[gid[i]]/sum(gid==gid[i])
              }
            }
            
            
            ##########################      
            # for labor market off  
            if(labor_market == TRUE)  {
              if(caught[i] == 1 ){ payoff[i] <- w^c*(1-effort[i]) + payoff[i] - punish_cost*punish_type[i]
              }else{
                payoff[i] <- (effort2[i]/sum(effort2[loc == loc[i]]))*X_non_siezed[loc[i]] + w^c*(1-effort[i]) + payoff[i] - punish_cost*punish_type[i] + X_siezed[gid[i]]/sum(gid==gid[i])
              }
            }
            
          }
        }#End insitutions
        
        ##################################################################
        ############ In a world without boundaries .... ##################
        
        
        
        if(inst == FALSE){
          # caclulate total production 
          X <- rep(0, ngroups)
          for (i in 1:ngroups) X[i] = tech*sum(effort[loc == i])^a*(K[i]^b[i])
          #derive inv payoff
          if(labor_market == FALSE)  for(i in 1:n) payoff[i] <- (effort[i]/sum(effort[loc == loc[i]]))*X[loc[i]] + w*(1-effort[i]) +payoff[i]
          if(labor_market == TRUE)   for(i in 1:n) payoff[i] <- (effort[i]/sum(effort[loc == loc[i]]))*X[loc[i]] + w^c*(1-effort[i]) +payoff[i]
        }#end freee travel
        
        #################################
        ####### Forest Dynamics #########
        
        #remove stock
        K <- K - X
        #regrow stock
        K <- K + K*regrow
        #Check to make sure stock follows logical constraints
        K <- ifelse(K > kmax, kmax, K)
        K <- ifelse(K <= 0, 1/kmax, K)
        
        
        ###################################### 
        ######### Social Learning ############
        
        # Prestige Biased Transmission
        if(social_learning == TRUE){
          models <- rep(NA, n)
          for(i in 1:n){
            model_list <- sample(id[-i], nmodels, replace = FALSE)
            model_temp<- model_list[which.max(payoff[model_list])] 
            models[i] <- ifelse(payoff[model_temp] > payoff[i], model_temp, i)
          } # End finding models
          
          for(i in 1:n){
            # Update Type and Account for Transmission Fidelity
            effort[i] <- ifelse(models[i] == id[i], effort[i], ifelse(runif(1,0, 1) < fidelity, inv_logit(logit(effort[models[i]])+rnorm(1, 0, 1)), effort[models[i]]))
            leakage_type[i] <- ifelse(models[i] == id[i], leakage_type[i], ifelse(runif(1,0, 1) < fidelity, ifelse(punish_type[models[i]]==1, 0, 1), punish_type[models[i]]))
            punish_type[i] <-  ifelse(models[i] == id[i], punish_type[i], ifelse(runif(1,0, 1) < fidelity, ifelse(punish_type[models[i]]==1, 0, 1), punish_type[models[i]]))
          }#End updating
        } #End Social Learning Block
        
        ############################################
        ### Record the Year in the  History books ###
        
        
        
        stock[year,] <- round(K/kmax,2)
        harvest[year] <- mean((effort/sum(effort))*X_non_siezed)
        wage[year] <- mean(w*(1-effort))
        effort_h[year] <- mean(effort)
        payoff_h[year] <- mean(payoff)
        leakage_rate_h[year] <- mean(loc != gid)
        punish_h[year,i] <- mean(punish_type)
        leakage_h[year,i] <-mean(leakage_type)
        if(all(payoff <= 0)) break
        
        
        year <- 1 + year
      }# end rounds 
      
      
      
      ####################################
      ###### Evolutionary dynamics #######
      
      
      if(g < ngen){
        # reproduce
        payoff <- ifelse(payoff < 0, 0, payoff)
        babies <- sample(id, prob = payoff, replace = T)
        effort <- effort[babies]
        leakage_type <- leakage_type[babies]
        punish_type <- punish_type[babies]
        #mutate
        for (i in 1:n) effort[i] <- ifelse(runif(1,0, 1) < mutation, inv_logit(logit(effort[i])+rnorm(1, 0, 1)), effort[i])
        for (i in 1:n) punish_type[i] <- ifelse(runif(1,0, 1) < mutation, ifelse(punish_type[i]==1, 0, 1), punish_type[i])
        for (i in 1:n) leakage_type[i] <- ifelse(runif(1,0, 1) < mutation, ifelse(leakage_type[i]==1, 0, 1), leakage_type[i])
      }#end evolutionary dynamics
    }# end generations
    
    
    #########################################
    ####### Record history of the world ####
    e[[sim]] <- effort_h
    p[[sim]] <- payoff_h
    pt[[sim]] <- punish_h
    lt[[sim]] <- leakage_h
    s[[sim]] <- stock
    wa[[sim]] <- wage
    h[[sim]] <- harvest
    lr[[sim]] <- leakage_rate_h
    
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
                 leakage_rate = lr)
  return(output)
}# END INSITITUIONS



##
plot(apply(temp2$stock[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(temp2$stock[[i]],1, mean), col = col.alpha("black", .2))

##
plot(temp2$leakage_rate[[1]], type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,temp2$leakage_rate[[i]], col = col.alpha("black", .2))
##
plot(apply(temp2$leakage[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(temp2$leakage[[i]],1, mean), col = col.alpha("black", .2))



leak_high_good_tech <- cpr_institution_abm(max_forest = 200, regrow = 0.05, w = 0.05, monitor_tech = .5, ngen = 4500, inst = TRUE, leakage_rate = .5, var_forest = 50)
leak_high <- cpr_institution_abm(max_forest = 200, regrow = 0.05, w = 0.05, monitor_tech = 1, ngen = 4500, inst = TRUE, leakage_rate = .5, var_forest = 50)

plot(apply(leak_high$stock[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high$stock[[i]],1, mean), col = col.alpha("black", .2))

##
plot(leak_high$leakage_rate[[1]], type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,leak_high$leakage_rate[[i]], col = col.alpha("black", .2))
##
plot(apply(leak_high$leakage[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high$leakage[[i]],1, mean), col = col.alpha("black", .2))

plot(apply(leak_high$punish[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high$punish[[i]],1, mean), col = col.alpha("black", .2))


leak_high_good_tech <- cpr_institution_abm(max_forest = 200, regrow = 0.025, w = 0.05, monitor_tech = .5, ngen = 4500, inst = TRUE, leakage_rate = .5, var_forest = 50)



plot(apply(leak_high_good_tech$stock[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high_good_tech$stock[[i]],1, mean), col = col.alpha("black", .2))

##
plot(leak_high_good_tech$leakage_rate[[1]], type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,leak_high_good_tech$leakage_rate[[i]], col = col.alpha("black", .2))
##
plot(apply(leak_high_good_tech$leakage[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high_good_tech$leakage[[i]],1, mean), col = col.alpha("black", .2))

plot(apply(leak_high_good_tech$punish[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high_good_tech$punish[[i]],1, mean), col = col.alpha("black", .2))



leak_high_good_tech_slow <- cpr_institution_abm(max_forest = 200, regrow = 0.04, w = 0.05, monitor_tech = .5, ngen = 4500, inst = TRUE, leakage_rate = .5, var_forest = 50)

plot(apply(leak_high_good_tech_slow$stock[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high_good_tech_slow$stock[[i]],1, mean), col = col.alpha("black", .2))


plot(leak_high_good_tech_slow$effort[[1]], type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(leak_high_good_tech_slow$effort[[i]], col = col.alpha("black", .2))

##
plot(leak_high_good_tech_slow$leakage_rate[[1]], type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,leak_high_good_tech_slow$leakage_rate[[i]], col = col.alpha("black", .2))
##
plot(apply(leak_high_good_tech_slow$leakage[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high_good_tech_slow$leakage[[i]],1, mean), col = col.alpha("black", .2))

plot(apply(leak_high_good_tech_slow$punish[[1]],1, mean), type = "l", ylim =c(0,1), col = col.alpha("black", .2))
for(i in 2:10)lines(1:4500,apply(leak_high_good_tech_slow$punish[[i]],1, mean), col = col.alpha("black", .2))



#########################################
###########PARAMETER SWEEP ##############



results <- list()
for(i in 1:nrow(sweep)){
  results[[i]] <- cpr_market(nsim = sweep$nsim[i], nrounds = sweep$nrounds[i], n = sweep$n[i], kmax = sweep$kmax[i], w = sweep$w[i], regrow = sweep$regrow[i],
                             mutation = sweep$mutation[i], tech = sweep$tech[i], labor = sweep$labor[i], labor_market = sweep$labor_market[i],
                             market_size=sweep$market_size[i])
}

results2 <- list()
for(i in 51:nrow(sweep)){
  results2[[i]] <- cpr_market(nsim = sweep$nsim[i], nrounds = sweep$nrounds[i], n = sweep$n[i], kmax = sweep$kmax[i], w = sweep$w[i], regrow = sweep$regrow[i],
                              mutation = sweep$mutation[i], tech = sweep$tech[i], labor = sweep$labor[i], labor_market = sweep$labor_market[i],
                              market_size=sweep$market_size[i])
}


col.alpha <- function (acol, alpha = 0.2) 
{
  acol <- col2rgb(acol)
  acol <- rgb(acol[1]/255, acol[2]/255, acol[3]/255, alpha)
  acol
}



for(j in 51:length(results2)){
  temp <-results2[[j]]
  jpeg(paste0("REDD+/figures/cpr_abm/abm_market_", j,".jpg"), width = 600, height = 500)
  
  par(mfrow=c(1,2),oma=c(0,0,1,0))
  title <- paste("wage = ", sweep$w[j], "regrow =", sweep$regrow[j], "Labor market =" sweep$labor_market[j], "market size =", sweep$market_size[j] )
  plot(temp$stock[[1]], type = "l", col=col.alpha("black", 0.1), ylim = c(0, 1), xlim =c(0, 45000) , xlab = "time", ylab = "stock")
  for(i in 2:length(temp$stock)) lines(1:length(temp$stock[[i]]), temp$stock[[i]]/100, col=col.alpha("black", 0.1))
  
  
  plot(temp$effort[[1]], type = "l", col=col.alpha("darkblue", 0.1), ylim = c(0, 1), xlim = c(0,45000), xlab = "time", ylab = "average effort")
  for(i in 2:length(temp$stock)) lines(1:length(temp$stock[[i]]), temp$effort[[i]], col=col.alpha("darkblue", 0.1))
  mtext(paste(title), side = 3, line = 0, cex = 1.5, outer = T)
  dev.off()  
}