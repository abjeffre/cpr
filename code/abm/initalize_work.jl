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
@everywhere include("cpr/code/abm/submodules/setupExperiments.jl")
@everywhere include("cpr/code/abm/submodules/SetupExperiments.jl")
@everywhere include("cpr/code/abm/submodules/RunExperiments.jl")
@everywhere include("cpr/code/abm/submodules/SeedTraits.jl")
@everywhere include("cpr/code/abm/submodules/getHistoryBook.jl")
@everywhere include("cpr/code/abm/submodules/RecordHistory.jl")

@everywhere include("functions/utility.jl")
#@everywhere include("cpr/code/abm/abm_popgrowth.jl")
@everywhere include("cpr/code/abm/abm_heterogenity.jl")
@everywhere include("cpr/code/abm/abm_cleaned.jl")

