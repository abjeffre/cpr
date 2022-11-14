#############################################################
############### CPR Groups ###################################


# production function
# assumption 1: for a given level of stock each additional unit of labor will decrease the total labor expenditure. 
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




cpr_group_abm <- function(
  nsim = 10,
  nrounds = 10,
  ngen = 100,
  n = 150,
  ngroups = 15,
  max_forest = 100,               # max stock    
  w = .05,                     # wage rate in other sectors - opportunity costs
  regrow = .05,               # the regrowth rate
  mutation = 0.01,
  tech = 0.05,
  labor = .5,
  labor_market = F,          # this controls labor market competition
  market_size = 1,           # this controls the demand for labor in the population and is exogenous
  lattice = c(3, 5)
){
  
  #check group size
  if(n%%ngroups != 0) stop("n is not evenly divisible by ngroups")
  
  #functions
  logit <- function (p) log(p/(1-p))
  inv_logit <- function (x) 1/(1+exp(-x))  
  
  #sim storage  
  e <- list()
  p <- list()
  s <- list() 
  wa <- list()
  h <- list()
  
  #simulations
  for (sim in 1:nsim){
    
    #create world
    world <- matrix(1:ngroups, lattice)
    if(length(world) != ngroups) stop("the world is not built for your groups, check lattice and group size")
    #make the forests and DIVIDE them amongst the groups
    kmax <- max_forest/ngroups
    K <- rep(kmax, ngroups) 
    
    
    # histories   
    effort <- rep(NA, n)
    stock <- matrix(NA, ncol = ngroups, nrow = ngen)
    harvest <- rep(NA, nrounds)
    wage <- rep(NA, nrounds)
    effort_h <- rep(NA, nrounds)
    payoff_h <- rep(NA, nrounds)
    id <- 1:n 
    gid <- rep(1:ngroups, n/ngroups)
    
    effort <- rbeta(n, 1, 1)
    
    for(g in 1:ngen){
      #reset payoffs
      payoff <- rep(0, n)
      
      for(t in 1:nrounds){
        
        # derive elasticities
        a <- labor
        b <- K/kmax
        if(labor_market == TRUE) c <- 1-(sum(effort)/n)^(1/market_size)
        # derive total production 
        X <- rep(0, ngroups)
        for (i in 1:ngroups) X[i] = tech*sum(effort[gid == i])^a*(K[i]^b[i])
        #derive inv payoff
        if(labor_market == FALSE)  for(i in 1:n) payoff[i] <- (effort[i]/sum(effort[gid == gid[i]]))*X[gid[i]] + w*(1-effort[i]) +payoff[i]
        if(labor_market == TRUE)   for(i in 1:n) payoff[i] <- (effort[i]/sum(effort[gid == gid[i]]))*X[gid[i]] + w^c*(1-effort[i]) +payoff[i]
        
        #remove stock
        K <- K - X
        #regrow stock
        K <- K + K*regrow
        #Check to make sure stock follows logical constraints
        K <- ifelse(K > kmax, kmax, K)
        K <- ifelse(K <= 0, 1/kmax, K)
        
      }# end rounds 
      
      # Record History for the generation
      stock[g,] <- round(K,2)
      harvest[g] <- mean((effort/sum(effort))*X)
      wage[g] <- mean(w*(1-effort))
      effort_h[g] <- mean(effort)
      payoff_h[g] <- mean(payoff)
      if(all(payoff <= 0)) break
      
      # Evolutionary dynamics
      if(g < ngen){
        # reproduce
        babies <- sample(id, prob = payoff, replace = T)
        effort <- effort[babies]
        #mutate
        for (i in 1:n) effort[i] <- ifelse(runif(1,0, 1) < mutation, inv_logit(logit(effort[i])+rnorm(1, 0, 1)), effort[i])
      }#end evolutionary dynamics
    }# end generations
    
    
    
    e[[sim]] <- effort_h
    p[[sim]] <- payoff_h
    s[[sim]] <- stock
    wa[[sim]] <- wage
    h[[sim]] <- harvest
    
    
  }# end sims 
  
  
  output <- list(effort =e,
                 payoff =p,
                 stock = s,
                 harvest= h,
                 wages = wa)
  return(output)
}


#########################################
###########PARAMETER SWEEP ##############

sweep <- expand.grid(nsim = 10,
                     nrounds = 10000,
                     n = 150,
                     ngroups = 15,
                     kmax = 100,
                     w = c(0.005, 0.05, 0.5),
                     regrow = c(0.005, 0.05, 0.5),
                     mutation =0.01,
                     tech = c(0.05),
                     labor= c(0.5),
                     labor_market = c(T, F),
                     market_size = c(1, 10, 100))



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
  plot(temp$stock[[1]], type = "l", col=col.alpha("black", 0.1), ylim = c(0, 1), xlim =c(0, 10000) , xlab = "time", ylab = "stock")
  for(i in 2:length(temp$stock)) lines(1:length(temp$stock[[i]]), temp$stock[[i]]/100, col=col.alpha("black", 0.1))
  
  
  plot(temp$effort[[1]], type = "l", col=col.alpha("darkblue", 0.1), ylim = c(0, 1), xlim = c(0,10000), xlab = "time", ylab = "average effort")
  for(i in 2:length(temp$stock)) lines(1:length(temp$stock[[i]]), temp$effort[[i]], col=col.alpha("darkblue", 0.1))
  mtext(paste(title), side = 3, line = 0, cex = 1.5, outer = T)
  dev.off()  
}