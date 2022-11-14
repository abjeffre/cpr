############################################################################
######################## PLOTS FOR Evolving Ostroms First Principle ########

##################################################
#### Process:
#### Using sweeps find one price wage combination that allows for the evolution of insitutions
#### Using that price wage combination get the Maximum sustainable yield
#### Get Harvest or Tree Stock
#### Then using only that parameter combo - run the model without leakage but with the full model ie. pun1_on pun2_on etc 
#### Make plot that shows the timing of the evolution of borders and the timing of the evolution of in_group regulation

##################################################

# Price = 0.07847599703514611
# wage =  3.79269019073225
# max forest = 350000

 pay = []
 stock = []
 cnt =1 
 for i in collect(0.0:0.01:1.0)  
   print(cnt) 
   ok  = cpr_abm(n = 150, ngroups = 150, lattice = (1,150), max_forest = 210000, 
   leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01, 
   fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
   price = 0.0784,
   wages =  3.792,
   regrow = .025,
   nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = i)
   push!(pay, ok[:payoffR][:,1,1])
   push!(stock, ok[:stock][:,1,1])
   cnt = cnt +1
 end

 plot(stock[1], alpha = .7, label = false)
 for i in 2:length(stock)
    display(plot!(stock[i], label = false, xlab = "Time", ylab = "Stock", ylim = (0, 1.1), alpha = .7))
 end
 means = [mean(pay[i]) for i in 1:length(stock)] 
 q=findmax(means)[2]
 a=plot!(stock[q], xlab = "Time", ylab = "Stock", ylim = (0, 1.1), lw = 3, lc =:black, label = "Stock level for max long-run payoff")


 plot(pay[1], alpha = .7, label = false)
 for i in 2:length(pay)
    display(plot!(pay[i], label = false, xlab = "Time", ylab = "Payoff", ylim = (0, 25), alpha = .7))
 end
 b=plot!(pay[q], xlab = "Time", ylab = "Payoff", ylim = (0, 25), lw = 3, lc =:black, label = "Max long-run payoff")
 out=plot(a,b, layout = (2,1))


findmax(means)[2]
 ##

 ok  = cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 420000, 
 leak = false, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
 fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true,
 punish_cost = .000001,
 price = 0.0784,
 wages =  3.792,
 regrow = .025,
 harvest_limit = 2,
 nmodels = 3, var_forest = 0, mutation = .01,
  social_learning = true, experiment_effort = 1, experiment_leak = .001)

a = plot(ok[:stock][:,:,1])
b = plot(ok[:punish][:,:,1])
c = plot(ok[:punish2][:,:,1])  
low=plot(a,b,c, layout = (1,3))

 #high leakage 
 ok  = cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 420000, 
 leak = false, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
 fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true,
 punish_cost = .000001,
 price = 0.0784,
 wages =  3.792,
 regrow = 0.025,
 harvest_limit = 2,
 nmodels = 3, var_forest = 0, mutation = .01,
  social_learning = true, experiment_effort = 1, experiment_leak = .9)
  a = plot(ok[:stock][:,:,1])
  b = plot(ok[:punish][:,:,1])
  c = plot(ok[:punish2][:,:,1])  
  low=plot(a,b,c, layout = (1,3))
  

# turn borders off
  ok  = cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 420000, 
 leak = false, pun1_on = false, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
 fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true,
 punish_cost = .000001,
 price = 0.0784,
 wages =  3.792,
 harvest_limit = 2,
 nmodels = 3, var_forest = 0, mutation = .01,
  social_learning = true, experiment_effort = 1, experiment_leak = .9)

  a = plot(ok[:stock][:,:,1])
  b = plot(ok[:punish][:,:,1])
  c = plot(ok[:punish2][:,:,1])  
  low=plot(a,b,c, layout = (1,3))


# make multigroup low
ok  = cpr_abm(n = 150*9, ngroups = 9, lattice = (3,3), max_forest = 210000*9, 
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, nsim = 1,
punish_cost = .000001,
price = 0.1784,
wages =  1.792,
regrow = 0.01,
travel_cost = .001,
harvest_limit = 1.5,
nmodels = 3, var_forest = 0, mutation = .01,
 social_learning = true, experiment_effort = 1, experiment_leak = .001)

a = plot(ok[:stock][:,:,1], ylim = (0,1))
b = plot(ok[:punish][:,:,1], ylim = (0,1))
c = plot(ok[:punish2][:,:,1], ylim = (0,1))  
d = plot(ok[:limit][:,:,1], ylim = (0,5))  
low=plot(a,b,c,d, layout = (1,4), size = (1200, 300))


# make multigroup high
ok  = cpr_abm(n = 150*9, ngroups = 9, lattice = (3,3), max_forest = 210000*9, 
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, nsim = 1,
punish_cost = .000001,
price = 0.1784,
wages =  1.792,
regrow = 0.01,
travel_cost = .01,
harvest_limit = 1.5,
nmodels = 3, var_forest = 0, mutation = .01,
 social_learning = true, experiment_effort = 1, experiment_leak = .9)

a = plot(ok[:stock][:,:,1], ylim = (0,1))
b = plot(ok[:punish][:,:,1], ylim = (0,1))
c = plot(ok[:punish2][:,:,1], ylim = (0,1))  
d = plot(ok[:limit][:,:,1], ylim = (0,5))  
low=plot(a,b,c,d, layout = (1,4), size = (1200, 300))



# make multigroup high and remove borders
ok  = cpr_abm(n = 150*9, ngroups = 9, lattice = (3,3), max_forest = 210000*9, 
leak = true, pun1_on = false, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, 
punish_cost = .000001,
price = 0.1784,
wages =  1.792,
harvest_limit = 1.5,
nmodels = 3, var_forest = 0, mutation = .01,
 social_learning = true, experiment_effort = 1, experiment_leak = .9)

a = plot(ok[:stock][:,:,1], ylim = (0,1))
b = plot(ok[:punish][:,:,1], ylim = (0,1))
c = plot(ok[:punish2][:,:,1], ylim = (0,1))  
d = plot(ok[:limit][:,:,1], ylim = (05))  
low=plot(a,b,c,d, layout = (1,4), size = (1200, 300))

############### SWEEEP ###################################
@everywhere include("abm_invpun.jl")
S =expand_grid( collect(0:.1:1))
                @everywhere function g(el)
                    cpr_abm(nrounds = 1000,
                            nsim = 20,
                            fines1_on = false,
                            fines2_on = false,
                            leak = true,
                            pun1_on = true,
                            pun2_on = true,
                            full_save = true,
                            control_learning = false,
                            harvest_var = 1,
                            experiment_effort = 1,
                            experiment_leak = el,
                            n = 150*9,
                            ngroups = 9,
                            lattice = [3,3],
                            harvest_limit = 1.5,
                            nmodels = 3,
                            punish_cost = 0.000001,
                            max_forest = 210000*9,
                            groups_sampled =3,
                            var_forest = 0,
                            price = 0.1784,
                            wages =  1.792,
                            regrow = 0.025
                            )
                end
                

abm_dat2 = pmap(g, S[:,1])


put = []
for i in 1:11 
 push!(put, mean([mean(abm_dat2[i][:punish2][200:1000,2:end,j]) for j in 1:10]))
end










# make multigroup high and remove borders
ok  = cpr_abm(n = 150*9, ngroups = 9, lattice = (3,3), max_forest = 210000*9, 
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
fines1_on = true, fines2_on = true, nrounds = 1000, seized_on = true, 
punish_cost = .000001,
price = 0.0784,
wages =  3.792,
harvest_limit = 1.5,
nmodels = 3, var_forest = 0, mutation = .01,
 social_learning = true, experiment_effort = 1, experiment_leak = .9)

a = plot(ok[:stock][:,:,1], ylim = (0,1))
b = plot(ok[:punish][:,:,1], ylim = (0,1))
c = plot(ok[:punish2][:,:,1], ylim = (0,1))  
d = plot(ok[:limit][:,:,1], ylim = (0,5))  
low=plot(a,b,c,d, layout = (1,4), size = (1200, 300))




# make 16 groups
ok  = cpr_abm(n = 150*16, ngroups = 16, lattice = (4,4), max_forest = 210000*16, 
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, 
punish_cost = .000001,
price = 0.0784,
wages =  3.792,
harvest_limit = 1.5,
nmodels = 3, var_forest = 0, mutation = .01,
 social_learning = true, experiment_effort = 1, experiment_leak = .001)

a = plot(ok[:stock][2:end,:,1], ylim = (0,1))
b = plot(ok[:punish][2:end,:,1], ylim = (0,1))
c = plot(ok[:punish2][2:end,:,1], ylim = (0,1))  
d = plot(ok[:limit][2:end,:,1], ylim = (0,5))  
low=plot(a,b,c,d, layout = (1,4), size = (1200, 300))




# make 16 groups
ok  = cpr_abm(n = 150*16, ngroups = 16, lattice = (4,4), max_forest = 210000*16, 
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, 
punish_cost = .000001,
price = 0.0784,
wages =  3.792,
harvest_limit = 1.5,
nmodels = 3, var_forest = 0, mutation = .01,
 social_learning = true, experiment_effort = 1, experiment_leak = .9)

a = plot(ok[:stock][2:end,:,1], ylim = (0,1))
b = plot(ok[:punish][2:end,:,1], ylim = (0,1))
c = plot(ok[:punish2][2:end,:,1], ylim = (0,1))  
d = plot(ok[:limit][2:end,:,1], ylim = (0,5))  
low=plot(a,b,c,d, layout = (1,4), size = (1200, 300))



















# make multigroup low
ok  = cpr_abm(n = 150*9, ngroups = 9, lattice = (3,3), max_forest = 210000*9, 
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, 
punish_cost = .000001,
price =  0.0784,
wages =  2,
harvest_limit = 10,
nmodels = 3, var_forest = 0, mutation = .01,
 social_learning = true, experiment_effort = 1, experiment_leak = .001)

a = plot(ok[:stock][:,:,1], ylim = (0,1))
b = plot(ok[:punish][:,:,1], ylim = (0,1))
c = plot(ok[:punish2][:,:,1], ylim = (0,1))  
d = plot(ok[:limit][:,:,1], ylim = (0,5))  
low=plot(a,b,c,d, layout = (1,4), size = (1200, 300))


# make multigroup high
ok  = cpr_abm(n = 150*9, ngroups = 9, lattice = (3,3), max_forest = 210000*9, 
leak = true, pun1_on = true, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = true, 
punish_cost = .000001,
price = 0.0784,
wages =  2,
harvest_limit = 10,
nmodels = 3, var_forest = 0, mutation = .01,
 social_learning = true, experiment_effort = 1, experiment_leak = .9)

a = plot(ok[:stock][:,:,1], ylim = (0,1))
b = plot(ok[:punish][:,:,1], ylim = (0,1))
c = plot(ok[:punish2][:,:,1], ylim = (0,1))  
d = plot(ok[:limit][:,:,1], ylim = (0,5))  
low=plot(a,b,c,d, layout = (1,4), size = (1200, 300))
