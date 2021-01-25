###########################################################
############### CPR ABM ###################################


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




cpr_abm <- function(
  nsim = 10,
  nrounds = 10000,
  n = 150,
  ngroups = 15,
  kmax = 100,               # max stock    
  w = .01,                     # wage rate in other sectors - opportunity costs
  regrow = .05,               # the regrowth rate
  mutation = 0.01,
  tech = 0.05,
  labor = .5
  ){
  
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

    
    # histories   
    effort <- matrix(nrow = nrounds, ncol = n)
    payoff <- matrix(nrow = nrounds, ncol = n)
    stock <- rep(NA, nrounds)
    harvest <- rep(NA, nrounds)
    wage <- rep(NA, nrounds)
    id <- 1:n 
    
    effort[1, ] <- rbeta(n, 1, 1)
    
    K <- kmax
    
    for(t in 1:nrounds){
      
      # derive elasticities
      a <- labor
      b <- K/kmax
      # derive total production 
      X = tech*sum(effort[t, ])^a*(K^b)
      #derive inv payoff
      payoff[t, ] <- (effort[t,]/sum(effort[t,]))*X + w*(1-effort[t,])
      #remove stock
      K <- K - X
      #regrow stock
      K <- K + K*regrow
      #Check to make sure stock follows logical constraints
      if(K > kmax ) K <- kmax
      if(K <= 0 ) K <- 1
      #if(K <= 0 ) break
      stock[t] <- round(K,2)
      harvest[t] <- mean((effort[t,]/sum(effort[t,]))*X)
      wage[t] <- mean(w*(1-effort[t,]))
      if(all(payoff[t, ]<=0)) break
      
      #evolutionary dynamics
      if(t < nrounds){
      #reproduce
      babies <- sample(id, prob = payoff[t,], replace = T)
      effort[t+1,] <- effort[t, babies]
      #mutate
      for (i in 1:n) effort[t+1,i] <- ifelse(runif(1,0, 1) < mutation, inv_logit(logit(effort[t+1,i])+rnorm(1, 0, 1)), effort[t+1,i])
      }#end evolutionary dynamics
    }# end rounds
    
    
    
    e[[sim]] <- effort
    p[[sim]] <- payoff
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
                     w = c(0.02, 0.2, 2),
                     regrow = c(0.005, 0.05, 0.5),
                     mutation =0.01,
                     tech = c(0.005, 0.05, 0.5),
                     labor= c(0.5))



results <- list()
for(i in 1:nrow(sweep)){
  results[i] <- cpr_abm(nsim = sweep$nsim[i], nrounds = sweep$nrounds[i], n = sweep$n[i], kmax = sweep$kmax[i], w = sweep$w, regrow = sweep$regrow[i],
          mutation = sweep$mutation[i], tech = sweep$tech[i], labor = sweep$labor[i])
}
