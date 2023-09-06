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
@everywhere include("submodules/setupExperiments.jl")
@everywhere include("submodules/SetupExperiments.jl")
@everywhere include("submodules/RunExperiments.jl")
@everywhere include("submodules/SeedTraits.jl")
@everywhere include("submodules/getHistoryBook.jl")
@everywhere include("submodules/RecordHistory.jl")



#@everywhere include("CPR/code/abm/old_models/abm_group_policy.jl")
#@everywhere include("cpr/code/abm/old_models/abm_special_leakage.jl")
# @everywhere include("abm_popgrowth.jl")
# @everywhere include("abm_heterogenity.jl")
@everywhere include("abm_cleaned.jl")
