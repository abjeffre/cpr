#################################################################################
###################### DIVERSITY MATTERS ########################################
cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\output")
include("C:\\Users\\jeffr\\Documents\\work\\functions\\load.jl")
include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_cont.jl")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\abm_dat_env1.jld2")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\wip_data.jld2")
# s7 = cpr_abm(nsim = 20,nrounds =3000, n=300, ngroups = 2, lattice = [2,1],
#        max_forest = 1650, ecosys = false, eco_C=.01, harvest_limit = .1,
#        pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)
#
# m7 = cpr_abm(nsim = 20,nrounds =3000, n=900, ngroups = 6, lattice = [3,2],
#        max_forest = 1650*3, ecosys = false, eco_C=.01, harvest_limit = .1,
#        pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)
#
# @JLD2.save("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\diversitydat.jld2", s7, m7)

@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\diversitydat.jld2")
temp = zeros(200, 20)
for sim in 1:10
     temp[:,sim] = mean(r1i1["limit"][1:200,:,sim], dims =2)
 end
LB1=zeros(200)
LB1 = mean(temp, dims =2)


temp = zeros(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(s7["limit"][:,:,sim], dims =2)
 end
L1=zeros(3000)
L1 = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(m7["limit"][:,:,sim], dims =2)
 end
L2=zeros(3000)
L2 = mean(temp, dims =2)


animtime(200, 30, 1, [C1 C2 C3], [0, .2], "Sustainable Harvest Limit", LB1, L1, L2)




for sim in 1:20
     temp[:,sim] = mean(r1i1["punish2"][1:3000,:,sim], dims =2)
 end
PB1=zeros(3000)
PB1 = mean(temp, dims =2)


temp = zeros(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(s7["punish2"][:,:,sim], dims =2)
 end
P1=zeros(3000)
P1 = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(m7["punish"][:,:,sim], dims =2)
 end
P2=zeros(3000)
P2 = mean(temp, dims =2)


animtime(200, 30, 2, [D1 D2 D3], [0, 1], "In-group Enforcement", PB1, P1, P2)
