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
@everywhere include("cpr/code/abm/abm_heterogenity.jl")

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
@everywhere include("abm_heterogenity")

@everywhere include("cpr/code/abm/abm_heterogenity")