include("C:\\Users\\jeffr\\Documents\\work\\functions\\load.jl")
include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_cont.jl")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\abm_dat_env1.jld2")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\wip_data.jld2")
# s7 = cpr_abm(nsim = 10,nrounds =500, n=300, ngroups = 2, lattice = [2,1],
#        max_forest = 1650, ecosys = false, eco_C=.01, harvest_limit = .1,
#        pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)
#
# m7 = cpr_abm(nsim = 10,nrounds =500, n=900, ngroups = 6, lattice = [3,2],
#        max_forest = 1650*3, ecosys = false, eco_C=.01, harvest_limit = .1,
#        pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)
#
# @JLD2.save("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\diversitydat.jld2", s7, m7)

@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\diversitydat.jld2")



################################################################################
################### NO INSITUTIONS #############################################



temp=zeros(200, 10)

for sim in 1:10
     temp[:,sim] = mean(r1i0["stock"][1:200,:,sim], dims =2)
 end
S=zeros(200)
S = mean(temp, dims =2)


temp = zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i0["effort"][1:200,:,sim], dims =2)
 end
E=zeros(200)
E = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i0["harvest"][:,:,sim]./150, dims =2)
 end
H=zeros(200)
H = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i0["limit"][:,:,sim], dims =2)
 end
L=zeros(200)
L = mean(temp, dims =2)




animtime(200, 20, 1, ["forestgreen" "royalblue3"], [0, 1], "Stock and Effort", S ,E)


################################################################################
################# WITH INSITUTIONS #############################################


temp=zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i1["stock"][1:200,:,sim], dims =2)
 end
S=zeros(200)
S = mean(temp, dims =2)


temp = zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i1["effort"][1:200,:,sim], dims =2)
 end
E=zeros(200)
E = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i1["harvest"][1:200,:,sim]./150, dims =2)
 end
H=zeros(200)
H = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i1["punish2"][1:200,:,sim]./150, dims =2)
 end
P2=zeros(200)
P2 = mean(temp, dims =2)



for sim in 1:10
     temp[:,sim] = mean(r1i1["limit"][1:200,:,sim], dims =2)
 end
L=zeros(200)
L = mean(temp, dims =2)

animtime(200, 20, 1, ["forestgreen" "royalblue3"], [0, 1], "Stock and Effort", S ,E)

animtime(200, 20, 1, ["red" "blue"], [0, .2], "Harvest and Sustainability Belief", L ,H)



#################################################################
################# PAYOFFS #######################################


for sim in 1:10
     temp[:,sim] = mean(r1i1["payoffR"][1:200,:,sim], dims =2)
 end
PR1=zeros(200)
PR1 = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i0["payoffR"][1:200,:,sim], dims =2)
 end
PR2=zeros(200)
PR2 = mean(temp, dims =2)


animtime(200, 20, 1, ["goldenrod" "turquoise"], [0, .25], "Payoffs", PR1 ,PR2)

#################################################################
################# HARVEST #######################################



for sim in 1:10
     temp[:,sim] = mean(r1i1["harvest"][1:200,:,sim]./150, dims =2)
 end
PR1=zeros(200)
PR1 = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i0["harvest"][1:200,:,sim]./150, dims =2)
 end
PR2=zeros(200)
PR2 = mean(temp, dims =2)


animtime(200, 20, 1, ["goldenrod" "turquoise"], [0, .25], "Harvest", PR1 ,PR2)

################################################################
############# EFFORT PER UNIT HARVESTED #######################


for sim in 1:10
     temp[:,sim] = mean((r1i1["harvest"][1:200,:,sim]./150), dims =2)
 end
PR1=zeros(200)
PR1 = mean(temp, dims =2)

for sim in 1:10
     temp[:,sim] = mean((r1i1["effort"][1:200,:,sim]./150), dims =2)
 end
E1=zeros(200)
E1 = mean(temp, dims =2)



for sim in 1:10
     temp[:,sim] = mean(r1i0["harvest"][1:200,:,sim]./150, dims =2)
 end
PR2=zeros(200)
PR2 = mean(temp, dims =2)

for sim in 1:10
     temp[:,sim] = mean((r1i0["effort"][1:200,:,sim]./150), dims =2)
 end
E2=zeros(200)
E2 = mean(temp, dims =2)

animtime(200, 20, 1, ["goldenrod" "turquoise"], [0, 100], "Return on Energy Invested", PR1./E1 ,PR2./E2)




###################################################################
#################### GROUP SIZE #######################################



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


animtime(200, 30, 1, [C1 C2 C3], [0, .2], "Sustainable Harvest Limit", L, L1, L2)



temp=zeros(200, 10)
temp=zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i1l25["stock"][1:200,:,sim], dims =2)
 end
S=zeros(200)
S = mean(temp, dims =2)


temp = zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i1l25["effort"][:,:,sim], dims =2)
 end
E=zeros(200)
E = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i1l25["harvest"][:,:,sim]./150, dims =2)
 end
H=zeros(200)
H = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i1l25["limit"][:,:,sim], dims =2)
 end
L=zeros(200)
L = mean(temp, dims =2)

animtime(200, 20, 2, ["forestgreen" "royalblue3"], [0, 1], "Harvest and Effort", S ,E)

animtime(200, 20, 2, ["red" "blue"], [0, 1], "Harvest and Effort", L ,H)








temp=zeros(200, 10)
temp=zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i1l025["stock"][1:200,:,sim], dims =2)
 end
S=zeros(200)
S = mean(temp, dims =2)


temp = zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i1l025["effort"][:,:,sim], dims =2)
 end
E=zeros(200)
E = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i1l025["harvest"][:,:,sim]./150, dims =2)
 end
H=zeros(200)
H = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i1l025["limit"][:,:,sim], dims =2)
 end
L=zeros(200)
L = mean(temp, dims =2)

animtime(200, 20, 2, ["forestgreen" "royalblue3"], [0, 1], "Harvest and Effort", S ,E)

animtime(200, 20, 2, ["red" "blue"], [0, 1], "Harvest and Effort", L ,H)


for sim in 1:10
     temp[:,sim] = mean(r1i1l025["punish2"][:,:,sim], dims =2)
 end
L=zeros(200)
L = mean(temp, dims =2)




temp=zeros(200, 10)
temp=zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i1sm["stock"][1:200,:,sim], dims =2)
 end
S=zeros(200)
S = mean(temp, dims =2)


temp = zeros(200, 10)
for sim in 1:10
     temp[:,sim] = mean(r1i1sm["effort"][:,:,sim], dims =2)
 end
E=zeros(200)
E = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i1sm["harvest"][:,:,sim]./150, dims =2)
 end
H=zeros(200)
H = mean(temp, dims =2)


for sim in 1:10
     temp[:,sim] = mean(r1i1sm["limit"][:,:,sim], dims =2)
 end
L=zeros(200)
L = mean(temp, dims =2)

animtime(200, 20, 2, ["forestgreen" "royalblue3"], [0, 1], "Harvest and Effort", S ,E)

animtime(200, 20, 2, ["red" "blue"], [0, 1], "Harvest and Effort", L ,H)
