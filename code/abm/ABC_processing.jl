#####################################
########### PROCESS ABC DATA ########
using CSV
using Distances
using SparseArrays
using StaticArrays
using CategoricalArrays
using Distributions
using StatsPlots
using Dates
using GLM
using DataFrames
using JLD2
using StatsBase
using StatisticalRethinking

# Load data
SHEHIA=DataFrame(CSV.File("cpr/data/abc_priors_shehia.csv"))[:,2]
ALPHA=DataFrame(CSV.File("cpr/data/abc_priors_alpha.csv"))[:,2:end]
BETA=DataFrame(CSV.File("cpr/data/abc_priors_beta.csv"))[:,2:end]
TECH=DataFrame(CSV.File("cpr/data/abc_priors_tech.csv"))[:,2:end]
WAGE =DataFrame(CSV.File("cpr/data/abc_priors_wage.csv"))[:,2:end]
FOREST = DataFrame(CSV.File("cpr/data/abc_priors_forest_2017.csv"))[:,2]
LAND = DataFrame(CSV.File("cpr/data/abc_priors_land_total.csv"))[:,2]
POP = DataFrame(CSV.File("cpr/data/wards_households2.csv"))
KL=load("cpr/data/KL_2022_12_07T11_17_23_315.JLD2")
#Assign Data
KL_effort = KL["KL_effort"]
KL_deforest_rate = KL["KL_deforest_rate"]
deforesation_rate = KL["deforesation_rate"]
KL_stock_levels = KL["KL_stock_levels"]
S = KL["S"]

nsample = size(S)[1]


# Non-dominated sorting algorthim
function dominates2(x, y)
    strict_inequality_found = false
    for i in eachindex(x)
        y[i] > x[i] && return false
        strict_inequality_found |= x[i] > y[i]
    end
    return strict_inequality_found
   end


function nds4(arr)
    fronts = Vector{Int64}[]
    o = size(arr)[2]
    ind = collect(axes(arr, 1))
    a = SVector{o}.(eachrow(arr))
    while !isempty(a)
        red = [all(x -> !dominates2(x, y), a) for y in a]
        push!(fronts, ind[red])
        deleteat!(ind, red)
        deleteat!(a, red)
    end
    return fronts
end

function normalize(X)
    dt = fit(UnitRangeTransform, X)
    StatsBase.transform(dt, X)
end
 
# Note that all KL divergences should be calculated on the server if at work 


# Construct Fronts for all simulations
moving_average(vs,n) = [sum(@view vs[i:(i+n-1)])/n for i in 1:(length(vs)-(n-1))]
output = ones(nsample, 3)
output_moving = ones(nsample, 3)
#output_plots = []
for j in 1:nsample
    arr= [KL_effort[j] KL_deforest_rate[j] KL_stock_levels[j]]
    # Note that the best KL are those closes to zero!
    # Thus you need to reorder these
    for i in 1:size(arr)[2]
        tempx=abs.(0 .-arr[:,i])
        maxx = findmax(tempx)[1]
        arr[:,i]= -(tempx) # Mpte that this just has to become postiive!
    end
    n = size(arr)[1]
    fronts=nds4(arr);
    frontrank =zeros(n);
    frontrank_moving =zeros(n);
    for i in 1:length(fronts)
        frontrank[fronts[i]] .= i
        frontrank_moving=moving_average(frontrank, 1)
    end
    output[j,:] =mean(arr[fronts[1], :], dims = 1)
    output_moving[j,:] =mean(arr[frontrank_moving .<=2, :], dims = 1)
 #   push!(output_plots, plot(frontrank))
end

best=nds4(output)[1]
best_moving=nds4(output_moving)[1]

