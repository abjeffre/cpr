#########################################################
################## MONITORING AND ENFORECEMENT ##########
cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\output")
include("C:\\Users\\jeffr\\Documents\\work\\functions\\load.jl")
include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_cont.jl")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\abm_dat_env1.jld2")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\wip_data.jld2")


for sim in 1:20
     temp[:,sim] = mean(r8i1["seized2"][:,:,sim], dims =2)
 end
L1=zeros(3000)
L1 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r8i1["punish2"][:,:,sim], dims =2)
 end
P1=zeros(3000)
P1 = mean(temp, dims =2)

for sim in 1:20
     temp[:,sim] = mean(r8i1["stock"][:,:,sim], dims =2)
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
     temp[:,sim] = mean(r1i1["seized2"][:,:,sim], dims =2)
 end
LB1=zeros(3000)
LB1 = mean(temp, dims =2)


smax=maximum([maximum(P1), maximum(P0)])
mean((P1.-P0).- (PB1.-PB0))

animtime(200, 30, 2, [B1 B2 D1 D2 ], [0, 1], "Stock and In-group Enforcement",  SB1, S1, PB1, P1)
