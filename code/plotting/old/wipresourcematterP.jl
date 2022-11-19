
#####################################################################
#############BORDERS ARE EASIER ####################################
cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\output")
include("C:\\Users\\jeffr\\Documents\\work\\functions\\load.jl")
include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_cont.jl")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\abm_dat_env1.jld2")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\wip_data.jld2")


## Volatiltiy
r5i1 = cpr_abm(nsim = 10,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05,
             verbose = false,  volatility = .2)

r5i0 = cpr_abm(nsim = 10,nrounds =3000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,
     inst = false, volatility = .2)


## Degradeability
#
 r4i0 = cpr_abm(nsim = 10,nrounds =3000, n=3600, ngroups = 24, lattice = [6,4],
     max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
     pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,
     inst = false, degrade = [1, 2])
#
#
 r4i1 = cpr_abm(nsim = 10,nrounds =1000, n=3600, ngroups = 24, lattice = [6,4],
     max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
     pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,
      inst = true, degrade = [1, 2])
 #@JLD2.save("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\wipresourcedat.jld2", r4i0)
#
  @JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\wipresourcedat.jld2")

temp=rand(3000, 10)
for sim in 1:10
     temp[:,sim] = mean(r4i0["harvest"][:,:,sim]./30, dims =2)
 end
H1=zeros(3000)
H1 = mean(temp, dims =2)

temp=rand(3000, 10)
for sim in 1:10
     temp[:,sim] = mean(r4i0["stock"][:,:,sim], dims =2)
 end
S1=zeros(3000)
S1 = mean(temp, dims =2)



temp=rand(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(r1i1["harvest"][1:3000,:,sim]./30, dims =2)
 end
HB=zeros(3000)
HB = mean(temp, dims =2)


temp=rand(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(r1i1["stock"][1:3000,:,sim], dims =2)
 end
SB=zeros(3000)
SB = mean(temp, dims =2)



animtime(250, 30, 2, [A1 A2], [0, 1], "Harvest", H1, HB)


################################
#######PUNISHMENT PLOT ########

temp=rand(3000, 10)
for sim in 1:10
     temp[:,sim] = mean(r4i1["punish2"][:,:,sim]./15, dims =2)
 end
P1=zeros(1000)
P1 = mean(temp, dims =2)

temp=rand(1000, 20)
for sim in 1:20
     temp[:,sim] = mean(r1i1["punish2"][1:1000,:,sim], dims =2)
 end
PB=zeros(1000)
PB = mean(temp, dims =2)



animtime(300, 30, 3, [D1 D2], [0, 1], "In-group Enforcement", PB, P1 )



#
v
