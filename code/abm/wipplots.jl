#######################################################################################
################### WIP PLOTS #########################################################
cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm")
include("C:\\Users\\jeffr\\Documents\\work\\functions\\load.jl")
include("abm_cont.jl")
addprocs(3)


A1=[]
for i in 1:500 push!(A1,"#DFC27D") end
A2=[]
for i in 1:500 push!(A2,"#BF812D") end

B1=[]
for i in 1:500 push!(B1, "#99D8C9") end
B2=[]
for i in 1:500 push!(B2,"#006D2C") end

C1=[]
for i in 1:500 push!(C1, "red") end
C2=[]
for i in 1:500 push!(C2,"#8C6BB1") end
C3 = []
for i = 1:500 push!(C3, "#F768A1") end

D1=[]
for i in 1:500 push!(D1,"#FD8D3C") end
D2=[]
for i in 1:500 push!(D2,"#A63603") end

D3 = []
for i = 1:500 push!(D3, "brown4") end

H1 = []
for i = 1:500 push!(H1, "#4575B4") end
H2 = []
for i = 1:500 push!(H2, "#74ADD1") end
H3 = []
for i = 1:500 push!(H3, "#ABD9E9") end






r1i1 = cpr_abm(nsim = 10, nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 200000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)


r1i1sm = cpr_abm(nsim = 10, nrounds = 200, n=300, ngroups = 2, lattice = [2,1],
    max_forest = 1666.5, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)


r1i0 = cpr_abm(nsim = 10,nrounds =200, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)


r1i1l25 = cpr_abm(nsim = 10, nrounds = 200, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .25,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)


r1i1l025 = cpr_abm(nsim = 10, nrounds = 200, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .001, harvest_var = 0.001,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)

r1i1b = cpr_abm(nsim = 10, nrounds = 200, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.01, verbose = false)


########################################################################################
################# INCREASE ECOSYSTEM SERVICES ##########################################
r2i1 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
   max_forest = 20000, ecosys = true, eco_C=.05, harvest_limit = .1,
   pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)

r2i0 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
      max_forest = 20000, ecosys = true, eco_C=.05, harvest_limit = .1,
      pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)




########################################################################################
################# DECREASE REGROW  ##########################################
r3i1 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
               max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
               pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.03, verbose = false)

r3i0 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
      max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
      pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.03, verbose = false, inst = false)




########################################################################################
################# Increase degradeability  ##########################################
r4i1 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  degradability = .5)

r4i0 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false, degradability = .5)




########################################################################################
################# Increase Volatility ##########################################
r5i1 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  volatility = .1)

r5i0 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false, volatility = .1)


########################################################################################
################# Increase Patchiness ##########################################
r6i1 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  var_forest = 3000)

r6i0 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  var_forest = 3000)



########################################################################################
################# Increase Pollution ##########################################
r7i1 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution =true, pol_C = 0.01,  punish_cost = .001, regrow = 0.05, verbose = false,  var_forest = 1)

r7i0 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.01,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  var_forest = 1)




########################################################################################
################# Increase Defensibility ##########################################
r8i1 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
             pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  defensibility = .51)

r8i0 = cpr_abm(nsim = 20,nrounds = 3000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
    pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  defensibility = .51)



@JLD2.save("wip_data.jld2", r1i1, r1i0,
                            r2i1, r2i0,
                            r3i1, r3i0,
                            r4i1, r4i0,
                            r5i1, r5i0,
                            r6i1, r6i0,
                            r7i1, r7i0,
                            r8i1, r8i0)



@JLD2.load("wip_data.jld2")


###############################################################
################# labor #######################################

l07 = cpr_abm(nsim = 1,nrounds =1000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1, labor = .35,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)



l7 = cpr_abm(nsim = 1,nrounds =1000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)

s7 = cpr_abm(nsim = 20,nrounds =3000, n=300, ngroups = 2, lattice = [2,1],
       max_forest = 1650, ecosys = false, eco_C=.01, harvest_limit = .1,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)

m7 = cpr_abm(nsim = 20,nrounds =3000, n=900, ngroups = 6, lattice = [3,2],
       max_forest = 1650*3, ecosys = false, eco_C=.01, harvest_limit = .1,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)




savefig("ages.png")

x1 = mean(l7["effort"][:,:,1], dims = 2)
x2 = mean(l07["effort"][:,:,1], dims = 2)

x3 = mean(l7["stock"][:,:,1], dims = 2)
x4 = mean(l07["stock"][:,:,1], dims = 2)





animtime(200, 20, 2, [A1 B1 A2 B2], [0,1], x1,x2, x3, x4)

RGB(1.0, 133, 133)




###############################################################
################# DEGRADE #######################################

d1 = cpr_abm(nsim = 1,nrounds =1000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = false, eco_C=.01, harvest_limit = .1,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05,
       verbose = false, inst = false, degradability = .5)


x1 = mean(l7["effort"][:,:,1], dims = 2)
x2 = mean(d1["effort"][:,:,1], dims = 2)

x3 = mean(l7["stock"][:,:,1], dims = 2)
x4 = mean(d1["stock"][:,:,1], dims = 2)



animtime(200, 20, 2, [A B C D], x1,x2, x3, x4)



###########################################################################
################# EcoSystem Services #######################################

e1 = cpr_abm(nsim = 1,nrounds =1000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = true, eco_C=1, harvest_limit = .1,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05,
       verbose = false, inst = false)


x1 = mean(l7["effort"][:,:,1], dims = 2)
x2 = mean(e1["effort"][:,:,1], dims = 2)

x3 = mean(l7["stock"][:,:,1], dims = 2)
x4 = mean(e1["stock"][:,:,1], dims = 2)


animtime(200, 20, 2, [A B C D], x1,x2, x3, x4)



###########################################################################
################# Pollution Services #######################################

p1 = cpr_abm(nsim = 1,nrounds =1000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = false, eco_C=1, harvest_limit = .1,
       pollution = true, pol_C = 2,  punish_cost = .001, regrow = 0.05,
       verbose = false, inst = false)


x1 = mean(l7["effort"][:,:,1], dims = 2)
x2 = mean(p1["effort"][:,:,1], dims = 2)

x3 = mean(l7["stock"][:,:,1], dims = 2)
x4 = mean(p1["stock"][:,:,1], dims = 2)


animtime(200, 20, 2, [A B C D], x1,x2, x3, x4)



###########################################################################
################# REGROWTH Services #######################################

r1 = cpr_abm(nsim = 1,nrounds =1000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = false, eco_C=1, harvest_limit = .1,
       pollution = false, pol_C = .2,  punish_cost = .001, regrow = 0.01,
       verbose = false, inst = false)


x1 = mean(l7["effort"][:,:,1], dims = 2)
x2 = mean(r1["effort"][:,:,1], dims = 2)

x3 = mean(l7["stock"][:,:,1], dims = 2)
x4 = mean(r1["stock"][:,:,1], dims = 2)




animtime(200, 20, 2, [A1 A2 B1 B2], [0, 1], x1,x2, x3, x4)




###########################################################################
################# VOLATILITY Services #######################################

v1 = cpr_abm(nsim = 1,nrounds =1000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = false, eco_C=1, harvest_limit = .1,
       pollution = false, pol_C = .2,  punish_cost = .001, regrow = 0.05,
       verbose = false, inst = false, volatility = .3)


x1 = mean(l7["effort"][:,:,1], dims = 2)
x2 = mean(v1["effort"][:,:,1], dims = 2)

x3 = mean(l7["stock"][:,:,1], dims = 2)
x4 = mean(v1["stock"][:,:,1], dims = 2)


animtime(200, 20, 2, [A B C D], x1,x2, x3, x4)


###########################################################
############ EQUILIBRIUM PLOTS ############################

#start with regrowth


for sim in 1:20
     temp[:,sim] = mean(r3i1["limit"][:,:,sim], dims =2)
 end
L1=zeros(3000)
L1 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r3i1["punish2"][:,:,sim], dims =2)
 end
P1=zeros(3000)
P1 = mean(temp, dims =2)




for sim in 1:20
     temp[:,sim] = mean(r3i1["stock"][:,:,sim], dims =2)
 end
S1=zeros(3000)
S1 = mean(temp, dims =2)



for sim in 1:20
     temp[:,sim] = mean(r1i1["payoffR"][:,:,sim], dims =2)
 end
Z1=zeros(3000)
Z1 = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(r1i0["payoffR"][:,:,sim], dims =2)
 end
Z0=zeros(3000)
Z0 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r1i0["payoffR"][:,:,sim], dims =2)
 end
ZS0=zeros(3000)
ZS0 = mean(temp, dims =2)



for sim in 1:20
     temp[:,sim] = mean(r1i1["stock"][:,:,sim], dims =2)
 end
SB1=zeros(3000)
SB1 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r1i1["punish2"][:,:,sim], dims =2)
 end
PB1=zeros(3000)
PB1 = mean(temp, dims =2)

temp = rand(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(r1i1["limit"][:,:,sim], dims =2)
 end
LB1=zeros(3000)
LB1 = mean(temp, dims =2)


animtime(300, 30, 3, [D1], [0, 1], SB1, S1, PB1, P1)


animtime(200, 30, 2, [D1 D2 B1 B2], [0, 1], SB1, ZS0, Z1, Z0)

################################################
############ VOLATILITY #######################


for sim in 1:20
     temp[:,sim] = mean(r5i1["limit"][:,:,sim], dims =2)
 end
L1=zeros(3000)
L1 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r5i1["punish2"][:,:,sim], dims =2)
 end
P1=zeros(3000)
P1 = mean(temp, dims =2)




for sim in 1:20
     temp[:,sim] = mean(r5i1["stock"][:,:,sim], dims =2)
 end
S1=zeros(3000)
S1 = mean(temp, dims =2)





for sim in 1:20
     temp[:,sim] = mean(r1i1["stock"][:,:,sim], dims =2)
 end
SB1=zeros(3000)
SB1 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r1i1["punish2"][:,:,sim], dims =2)
 end
PB1=zeros(3000)
PB1 = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(r1i1["limit"][:,:,sim], dims =2)
 end
LB1=zeros(3000)
LB1 = mean(temp, dims =2)


smax=maximum([maximum(P1), maximum(P0)])
mean((P1.-P0).- (PB1.-PB0))

animtime(300, 30, 3, [C1 C2 D1 D2 B1 B2], [0, 1], normalize(LB1), normalize(L1), SB1, S1, PB1, P1)




################################################
############ Degrade #######################


for sim in 1:20
     temp[:,sim] = mean(r4i1["limit"][:,:,sim], dims =2)
 end
L1=zeros(3000)
L1 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r4i1["punish2"][:,:,sim], dims =2)
 end
P1=zeros(3000)
P1 = mean(temp, dims =2)




for sim in 1:20
     temp[:,sim] = mean(r4i1["stock"][:,:,sim], dims =2)
 end
S1=zeros(3000)
S1 = mean(temp, dims =2)



for sim in 1:20
     temp[:,sim] = mean(r4i1["comp"][:,:,sim], dims =2)
 end
C1=zeros(3000)
C1 = mean(temp, dims =2)




for sim in 1:20
     temp[:,sim] = mean(r1i1["stock"][:,:,sim], dims =2)
 end
SB1=zeros(3000)
SB1 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r1i1["punish2"][:,:,sim], dims =2)
 end
PB1=zeros(3000)
PB1 = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(r1i1["limit"][:,:,sim], dims =2)
 end
LB1=zeros(3000)
LB1 = mean(temp, dims =2)


smax=maximum([maximum(P1), maximum(P0)])
mean((P1.-P0).- (PB1.-PB0))

animtime(300, 30, 3, [C1 C2 D1 D2 B1 B2], [0, 1], normalize(LB1), normalize(L1), SB1, S1, PB1, P1)




###############################################################################
################## Diversity Plots ############################################



for sim in 1:20
     temp[:,sim] = mean(r1i1["limit"][1:3000,:,sim], dims =2)
 end
LB1=zeros(3000)
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


animtime(200, 30, 2, [C1 C2 C3], [0, .2], LB1, L1, L2)




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




animtime(200, 30, 3, [D1 D2 D3], [0, 1], PB1, P1, P2)


############################################################
########## LIMITS AFTER COLLAPSE ###########################



temp=zeros(3000, 20)



for sim in 1:20
     temp[:,sim] = mean(r1i1["stock"][1:3000,:,sim], dims =2)
 end
S=zeros(3000)
S = mean(temp, dims =2)


temp = zeros(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(r1i1["effort"][:,:,sim], dims =2)
 end
E=zeros(3000)
E = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(r1i1["harvest"][:,:,sim]./150, dims =2)
 end
H=zeros(3000)
H = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(r1i1["limit"][:,:,sim], dims =2)
 end
L=zeros(3000)
L = mean(temp, dims =2)



animtime(200, 20, 2, ["goldenrod" "pink" "blue" "red" ], [0, 1],S ,H, E, L)




#####################################################################
#############BORDERS ARE EASIER ####################################
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\abm_dat_env1.jld2")
dat=collate(abm_dat)


animtime(2000, 30, 20, [D1 D2 ], [0, 1], "Enforcement", dat["punish"],dat["punish2"])


animtime(2000, 30, 20, [B2], [0, 1], dat["limit"])




border7 = cpr_abm(nsim = 30,nrounds =3000, n=300, ngroups = 2, lattice = [2,1],
       max_forest = 1650, ecosys = false, eco_C=.01, harvest_limit = .1,
       pollution = false, pol_C = 0.1,  punish_cost = .001, regrow = 0.05,
       defensibility = 1, verbose = false, inst = true)


temp=zeros(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(r1i1["leakage"][:,:,sim], dims =2)
 end
L=zeros(3000)
L = mean(temp, dims =2)


temp=zeros(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(r1i1["punish"][:,:,sim], dims =2)
 end
P=zeros(3000)
P = mean(temp, dims =2)

animtime(2000, 30, 10, [C1 D1 ], [0, 1], "Out Group Enforce / Roamers", L,P)
