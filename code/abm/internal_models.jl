cd("c:/Users/Jeffrey Andrews/Documents/Work/")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/SplitGroupsTest.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/SocialTransmission.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/ResourceDynamics.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/MutateAgents.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/MakeBabies.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/KillAgents.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetSeizedPay.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetPollution.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetPolicy.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetPatch.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetModels.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetInspection.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetIndvHarvest.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetHarvest.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetGroupHarvest.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetGroupSeized.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetFinesPay.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetEcoSysServ.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/TransferWealth.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetModelsn1.jl")
include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/RWLearn.jl")

include("c:/Users/Jeffrey Andrews/Documents/Work/functions/utility.jl")


using Distributed
@everywhere using Statistics
@everywhere using Distributions
@everywhere using Random
@everywhere using Distributions
@everywhere using StatsBase

@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/SplitGroupsTest.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/SocialTransmission.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/ResourceDynamics.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/MutateAgents.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/MakeBabies.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/KillAgents.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetSeizedPay.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetPollution.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetPolicy.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetPatch.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetModels.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetInspection.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetIndvHarvest.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetHarvest.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetGroupHarvest.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetGroupSeized.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetFinesPay.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetEcoSysServ.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/TransferWealth.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/GetModelsn1.jl")
@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/cpr/code/abm/submodules/RWLearn.jl")

@everywhere include("c:/Users/Jeffrey Andrews/Documents/Work/functions/utility.jl")


