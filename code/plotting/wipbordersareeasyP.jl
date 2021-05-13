
#####################################################################
#############BORDERS ARE EASIER ####################################
cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\output")
include("C:\\Users\\jeffr\\Documents\\work\\functions\\load.jl")
include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_cont.jl")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\abm_dat_env1.jld2")
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\wip_data.jld2")



A1=[]
for i in 1:1 push!(A1,"#DFC27D") end
A2=[]
for i in 1:1 push!(A2,"#BF812D") end

B1=[]
for i in 1:1 push!(B1, "#99D8C9") end
B2=[]
for i in 1:1 push!(B2,"#006D2C") end

C1=[]
for i in 1:1 push!(C1, "#810F7C") end
C2=[]
for i in 1:1 push!(C2,"#8C6BB1") end
C3 = []
for i = 1:1 push!(C3, "#F768A1") end

D1=[]
for i in 1:1 push!(D1,"#FD8D3C") end
D2=[]
for i in 1:1 push!(D2,"#A63603") end

D3 = []
for i = 1:1 push!(D3, "#brown4") end

H1 = []
for i = 1:1 push!(H1, "#4575B4") end
H2 = []
for i = 1:1 push!(H2, "#74ADD1") end
H3 = []
for i = 1:1 push!(H3, "#ABD9E9") end




dat=collate(abm_dat)
animtime(2000, 30, 20, [D1 D2 ], [0, 1], "Enforcement", dat["punish"],dat["punish2"])
animtime(2000, 30, 20, [B2], [0, 1], dat["limit"])



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
