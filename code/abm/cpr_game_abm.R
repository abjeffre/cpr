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




cpr_game_abm <- function(
  nsim = 10,
  nrounds = 10,
  ngen = 1000,
  n = 5,
  ngroups = 1,
  kmax = 100,               # max stock    
  regrow = .1,               # the regrowth rate
  mutation = 0.001,
  institution = TRUE,
  punishment = 1500,
  limit = 1
){
  
  
  #sim storage  
  e <- list()
  p <- list()
  s <- list() 
  h <- list()
  
  #simulations
  for (sim in 1:nsim){
    
    
    # histories   
    stock <- rep(NA, ngen)
    harvest <- rep(NA, ngen)
    id <- 1:n 
    
    #fail safe installed on rbinom incase sampling results in all zeros
    effort <- rbinom(n, 5, .5)
    if(sum(effort == 0)){
      while(sum(effort ==0)){
        effort <- runif(n, 0, 5)
      }
    }
    
    K <- kmax
    
    
    for (g in 1: ngen){
      max_har <-5
      K <- kmax
      payoff <- rep(0, n)
      
      for(t in 1:nrounds){
        
        
        if(K < 5*n) max_har <- 4  
        if(K < 4*n) max_har <- 3
        if(K < 3*n) max_har <- 2
        if(K < 2*n) max_har <- 1
        if(K < 1*n)  max_har <- 0
        
        
        X = sum(ifelse(effort > max_har, max_har, effort))
        
        H <- ifelse(effort > max_har, max_har, effort)
        
        if(institution == TRUE){
          caught <- rbinom(n, 1, prob =.25) #
          for(i in 1:n){
            if(caught[i] == 1){
              if(H[i] > limit){
                payoff[i] <- payoff[i]-(H[i]-limit)*punishment + limit*500
            }else{
              payoff[i] <- H[i]*500 + payoff[i]
            } 
          }else payoff[i] <- H[i]*500 + payoff[i]
          }
        }
        
        if(institution == F){
          payoff <- H*500 + payoff
        }
        
        
        
        #remove stock
        K <- K - X
        #regrow stock
        K <- K + floor(K*regrow)
        #Check to make sure stock follows logical constraints
        if(K <= 0 ) break
        if(K > kmax) K <- kmax
        if(all(payoff<=0)) break
        
      }
      stock[g] <- round(K,2)
      harvest[g] <- mean(effort)
      #evolutionary dynamics
      if(g < ngen){

        # Players cannot go into the negative
        error_check <- payoff
        payoff <- ifelse(payoff < 0, 0, payoff)
        #reproduce
        babies <- sample(id, prob = payoff, replace = T)
        effort <- effort[babies]
        #mutate
        for (i in 1:n) effort[i] <- ifelse(runif(1,0, 1) < mutation, runif(1, 0,5), effort[i])
      }#end evolutionary dynamics
      
    }# end generations 
    
    
    p[[sim]] <- payoff
    s[[sim]] <- stock
    h[[sim]] <- harvest
    
    
  }# end sims 
  
  
  output <- list(
                 payoff =p,
                 stock = s,
                 harvest= h)
  return(output)
}

res <- cpr_game_abm(nsim = 20, ngen =1000, n = 50, kmax = 1000, mutation = 0.01, institution = TRUE, punishment = 1500)

#########################################
###########PARAMETER SWEEP ##############

plot(res$harvest[[1]],  type = "l", col = col.alpha("black", 0.2), ylim = c(0, 5))
for(i in 2:length(res$harvest)) lines(1:length(res$harvest[[1]]), res$harvest[[i]], col = col.alpha("black", 0.2))

plot(res$stock[[1]],  type = "l", col = col.alpha("black", 0.2), ylim = c(0, 1000))
for(i in 2:length(res$harvest)) lines(1:length(res$harvest[[1]]), res$stock[[i]], col = col.alpha("black", 0.2))

temp <- rep(NA, 20)
for(i in 1:20) temp[i] <- res$stock[[i]][[1000]]