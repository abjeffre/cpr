#######################################################################################
################### WIP PLOTS #########################################################



cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm")
include("cpr_setup.jl")
include("abm_red.jl")

r1i1 = cpr_abm(nsim = 20, nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)



r1i0 = cpr_abm(nsim = 20,nrounds =2000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)



########################################################################################
################# INCREASE ECOSYSTEM SERVICES ##########################################
r2i1 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
   max_forest = 20000, ecosys = true, eco_C=.05, harvest_limit = .1,
   pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)

r2i0 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
      max_forest = 20000, ecosys = true, eco_C=.05, harvest_limit = .1,
      pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)




########################################################################################
################# DECREASE REGROW  ##########################################
r3i1 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
               max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
               pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.03, verbose = false)

r3i0 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
      max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
      pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.03, verbose = false, inst = false)




########################################################################################
################# Increase degradeability  ##########################################
r4i1 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  degradability = .5)

r4i0 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false, degradability = .5)




########################################################################################
################# Increase Volatility ##########################################
r5i1 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  volatility = .1)

r5i0 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false, volatility = .1)


########################################################################################
################# Increase Patchiness ##########################################
r6i1 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  var_forest = 3000)

r6i0 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  var_forest = 3000)



########################################################################################
################# Increase Pollution ##########################################
r7i1 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution =true, pol_C = 0.01,  punish_cost = .001, regrow = 0.05, verbose = false,  var_forest = 1)

r7i0 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.01,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  var_forest = 1)




########################################################################################
################# Increase Defensibility ##########################################
r8i1 = cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  defensibility = .51)

r8i0 = [cpr_abm(nsim = 20,nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  defensibility = .51)]
