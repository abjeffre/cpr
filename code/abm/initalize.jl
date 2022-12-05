include("cpr/code/abm/submodules/SplitGroupsTest.jl")
include("cpr/code/abm/submodules/SocialTransmission.jl")
include("cpr/code/abm/submodules/ResourceDynamics.jl")
include("cpr/code/abm/submodules/MutateAgents.jl")
include("cpr/code/abm/submodules/MakeBabies.jl")
include("cpr/code/abm/submodules/KillAgents.jl")
include("cpr/code/abm/submodules/GetSeizedPay.jl")
include("cpr/code/abm/submodules/GetPollution.jl")
include("cpr/code/abm/submodules/GetPolicy.jl")
include("cpr/code/abm/submodules/GetPatch.jl")
include("cpr/code/abm/submodules/GetModels.jl")
include("cpr/code/abm/submodules/GetInspection.jl")
include("cpr/code/abm/submodules/GetIndvHarvest.jl")
include("cpr/code/abm/submodules/GetHarvest.jl")
include("cpr/code/abm/submodules/GetGroupHarvest.jl")
include("cpr/code/abm/submodules/GetGroupSeized.jl")
include("cpr/code/abm/submodules/GetFinesPay.jl")
include("cpr/code/abm/submodules/GetEcoSysServ.jl")
include("cpr/code/abm/submodules/TransferWealth.jl")
include("cpr/code/abm/submodules/GetModelsn1.jl")
include("cpr/code/abm/submodules/RWLearn.jl")

include("functions/utility.jl")


using Distributed
@everywhere using Statistics
@everywhere using Distributions
@everywhere using Random
@everywhere using Distributions
@everywhere using StatsBase

@everywhere include("cpr/code/abm/submodules/SplitGroupsTest.jl")
@everywhere include("cpr/code/abm/submodules/SocialTransmission.jl")
@everywhere include("cpr/code/abm/submodules/ResourceDynamics.jl")
@everywhere include("cpr/code/abm/submodules/MutateAgents.jl")
@everywhere include("cpr/code/abm/submodules/MakeBabies.jl")
@everywhere include("cpr/code/abm/submodules/KillAgents.jl")
@everywhere include("cpr/code/abm/submodules/GetSeizedPay.jl")
@everywhere include("cpr/code/abm/submodules/GetPollution.jl")
@everywhere include("cpr/code/abm/submodules/GetPolicy.jl")
@everywhere include("cpr/code/abm/submodules/GetPatch.jl")
@everywhere include("cpr/code/abm/submodules/GetModels.jl")
@everywhere include("cpr/code/abm/submodules/GetInspection.jl")
@everywhere include("cpr/code/abm/submodules/GetIndvHarvest.jl")
@everywhere include("cpr/code/abm/submodules/GetHarvest.jl")
@everywhere include("cpr/code/abm/submodules/GetGroupHarvest.jl")
@everywhere include("cpr/code/abm/submodules/GetGroupSeized.jl")
@everywhere include("cpr/code/abm/submodules/GetFinesPay.jl")
@everywhere include("cpr/code/abm/submodules/GetEcoSysServ.jl")
@everywhere include("cpr/code/abm/submodules/TransferWealth.jl")
@everywhere include("cpr/code/abm/submodules/GetModelsn1.jl")
@everywhere include("cpr/code/abm/submodules/RWLearn.jl")

@everywhere include("functions/utility.jl")
#@everywhere include("cpr/code/abm/abm_group_policy.jl")


using Distributed
@everywhere using Statistics
@everywhere using Distributions
@everywhere using Random
@everywhere using Distributions
@everywhere using StatsBase

@everywhere include("submodules/SplitGroupsTest.jl")
@everywhere include("submodules/SocialTransmission.jl")
@everywhere include("submodules/ResourceDynamics.jl")
@everywhere include("submodules/MutateAgents.jl")
@everywhere include("submodules/MakeBabies.jl")
@everywhere include("submodules/KillAgents.jl")
@everywhere include("submodules/GetSeizedPay.jl")
@everywhere include("submodules/GetPollution.jl")
@everywhere include("submodules/GetPolicy.jl")
@everywhere include("submodules/GetPatch.jl")
@everywhere include("submodules/GetModels.jl")
@everywhere include("submodules/GetInspection.jl")
@everywhere include("submodules/GetIndvHarvest.jl")
@everywhere include("submodules/GetHarvest.jl")
@everywhere include("submodules/GetGroupHarvest.jl")
@everywhere include("submodules/GetGroupSeized.jl")
@everywhere include("submodules/GetFinesPay.jl")
@everywhere include("submodules/GetEcoSysServ.jl")
@everywhere include("submodules/TransferWealth.jl")
@everywhere include("submodules/GetModelsn1.jl")
@everywhere include("submodules/RWLearn.jl")

@everywhere include("C:/Users/jeffr/OneDrive/Documents/functions/utility.jl")
#@everywhere include("CPR/code/abm/old_models/abm_group_policy.jl")
#@everywhere include("cpr/code/abm/old_models/abm_special_leakage.jl")
@everywhere include("abm_popgrowth.jl")
@everywhere include("abm_heterogenity.jl")



forest_sizes = [0.4459207, 0.5240663, 0.4853531, 1.4513511, 1.1013632, 0.6290888, 0.9362437, 0.5443384, 1.4728656, 2.5388508, 1.2165871,
0.4421278, 2.0060871, 0.5110529, 0.7614460, 0.5303441, 1.1125455, 0.7853801, 1.1305288, 1.5895937, 1.2332626, 0.6283695, 0.3262499, 1.5969832]


 a=cpr_abm(tech = 50, wages = 1.6, max_forest = 1000000, 
labor = .5, pun1_on = false, pun2_on = false, leak = false, degrade = .001, α = .04)

lb=rand(Uniform(.40, .6), 150*24)
tc=rand(Uniform(13, 14), 24)
dg=rand(Uniform(.03, .16), 24)
wg = rnad(Uniform(1.3, 2), 150*24)
a=cpr_abm(tech = tc, wages = 1.6, n = 100*24, nrounds = 200, kmax_data = 1000000 .*forest_sizes, ngroups = 24, lattice = [4, 6], 
labor = lb, pun1_on = false, pun2_on = false, leak = true, full_save = true, social_learning = true, fidelity = .2,
travel_cost = .01, degrade = dg, α = .1, distance_adj = .1, groups_sampled = 8, mutation = .03, zero = true)


out = zeros(100, 24)
for i in 2:100 
    out[i-1, :]=1 .-a[:stock][i,:,1]./a[:stock][i-1,:,1] 
end
plot(out)
plot(plot(a[:stock][:,:,1], label = ""), plot(out, ylim=(0, .1), label = ""), plot(a[:effort][:,:,1], label = ""), plot(a[:harvest][:,:,1], label = ""),
plot(a[:leakage][:,:,1], label = ""))


sort(countmap(a[:loc][1:30,:,1]))
scatter(collect(1:1:50), a[:effortfull][1:50,a[:gid].==1,1], label = false, alpha = .2, c= :orange) 
scatter!(collect(1:1:50), a[:effortfull][1:50,a[:gid].==10,1], label = false, alpha = .2, c= :blue)
scatter!(collect(1:1:50), a[:effortfull][1:50,a[:gid].==2,1], label = false, alpha = .2, c= :orange) 
scatter!(collect(1:1:50), a[:effortfull][1:50,a[:gid].==3,1], label = false, alpha = .2, c= :blue)




plot(mean(a[:leakfull][1:50,a[:gid].==1,1], dims = 2))
plot!(mean(a[:leakfull][1:50,a[:gid].==10,1], dims = 2))


scatter(a[:effortfull][46,a[:gid].==1,1], label = false, alpha = .2, c= :orange) 
scatter(a[:effortfull][46,:,1], label = false, alpha = .2, c= :orange) 