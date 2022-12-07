# Using abm_heterogentiy.jl


#########################################################
################## INTIAL ABC ###########################
using DataFrames
using CSV
using Distances
using SparseArrays
using StaticArrays
using CategoricalArrays
using Distributions
using StatsPlots
using Dates
using GLM
using OnlineStats
# Non-dominance sorting algorthim


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

########################################
############ LOAD DATA #################
   
SHEHIA=DataFrame(CSV.File("cpr/data/abc_priors_shehia.csv"))[:,2]
ALPHA=DataFrame(CSV.File("cpr/data/abc_priors_alpha.csv"))[:,2:end]
BETA=DataFrame(CSV.File("cpr/data/abc_priors_beta.csv"))[:,2:end]
TECH=DataFrame(CSV.File("cpr/data/abc_priors_tech.csv"))[:,2:end]
WAGE =DataFrame(CSV.File("cpr/data/abc_priors_wage.csv"))[:,2:end]
FOREST = DataFrame(CSV.File("cpr/data/abc_priors_forest_2017.csv"))[:,2]
LAND = DataFrame(CSV.File("cpr/data/abc_priors_land_total.csv"))[:,2]
POP = DataFrame(CSV.File("cpr/data/wards_households2.csv"))
e=DataFrame(CSV.File("cpr/data/abc_data_effort_firewood.csv"))[:,2:end]
deforest_data =DataFrame(CSV.File("cpr/data/abc_data_deforesation.csv"))[:,2:end]
ward_id =DataFrame(CSV.File("cpr/data/ward_id.csv"))[:,2:end]

######################################
############ GENERATE PRIORS #########
nsample = 4000

# Rearrange Pop
POP[:,1]=POP[reduce(vcat, [findall(unique(SHEHIA)[i] .== POP[:,1] ) for i in 1:24]),1];
POP[:,2]=POP[reduce(vcat, [findall(unique(SHEHIA)[i] .== POP[:,1] ) for i in 1:24]),2];
# Derive appropiate scales
GSIZE=Int.(round.(POP[:,2]/10))
# Using Population for each group - sample an appropiate number of ALPHA, WAGE priors
labor_data=reduce(vcat, [sample(ALPHA[:,i], GSIZE[i])  for i in 1:24])
# Labor  means
# Note that Wage just has a single prior for the whole model as we are doing a first pass calibration
wage_prior=sample( reduce(vcat, Vector.(eachrow(WAGE))) , nsample) 
# wage_prior=reduce(vcat, [sample(WAGE[:,i], GSIZE[i])  for i in 1:24])
# wage_prior = [reduce(vcat, WAGE[sample(1:nrow(WAGE)),:]) for i in 1:nsample]
# fill(median.(eachcol(WAGE)), nsample)
#  wage_prior = [reduce(vcat, wage_prior[i,:]) for i in 1:nsample]
# wage_prior=rand(Gamma(3,.3), nsample) 
 # EACH SHEHIA WITH ITS OWN UNIQUE WAGE
density(wage_prior)
# wage_prior=WAGE[sample(1:nrow(WAGE), nsample),:]
LAND_prior=LAND./mean(LAND)
# Parameters to Estimate
regrow_prior = rand(Gamma(3, .0075), nsample)
# density(regrow_prior)
α_prior = rand(Gamma(5, .06), nsample)
# density(α_prior)
travel_cost_prior  = rand(Gamma(4, .02), nsample)
# density(travel_cost_prior)

#############################################################
######### COMPILE MATRIX FOR DISTRIBUTED PROCESSSING ########

S=Matrix(undef, nsample, 9)
S[:,1] = regrow_prior
S[:,2] = α_prior 
S[:,3] = travel_cost_prior
S[:,4] = wage_prior
S[:,5] = fill(LAND_prior, nsample)
S[:,6] = fill(GSIZE, nsample)
S[:,7] =  fill(median.(eachcol(BETA)), nsample)
S[:,8] =  fill(median.(eachcol(TECH)), nsample)
S[:,9] = fill(median.(eachcol(ALPHA)), nsample)

###########################################################
################# DETERMINE FUNCTION ######################

@everywhere function g(
    regrow_prior, 
    α_prior, 
    travel_cost_prior,
    wage_prior,
    land_data,
    population_data,
    degrade_data,
    tech_data,
    labor_data) 
    cpr_abm(    # Data
                tech = tech_data,
                degrade = degrade_data,
                kmax_data = 1000000 .*land_data,
                population_data = population_data,
                labor = labor_data, 
                # Priors
                regrow = regrow_prior,
                travel_cost = travel_cost_prior,
                wages = wage_prior,
                α = α_prior,                
                # Model Settings                
                n = 100*24,
                nrounds = 400,
                ngroups = 24, 
                lattice = [6, 4], 
                pun1_on = false,
                pun2_on = false,
                leak = true,
                full_save = true,
                social_learning = true,
                fidelity = .2,        
                distance_adj = .1,
                groups_sampled = 8,
                mutation = .03,
                zero = true,
                )
end

a=pmap(g, S[:,1],S[:,2],S[:,3],S[:,4],S[:,5],S[:,6],S[:,7],S[:,8],S[:,9])
using JLD2
# Save the output
# jldsave("test_ABC.JDL2"; a)


#####################################################
############## GENERATE KL divergences ##############
# Calculate Deforesation rate for all sets
deforesation_rate=[[(a[i][:stock][k,:,1].+.0001 .-a[i][:stock][k-1,:,1].+ .0001)./(a[i][:stock][k-1,:,1].+.0001) for k in 2:400 ] for i in 1:nsample]
# Get KL of stock level
KL_stock_levels=[[kl_divergence(FOREST[:,1]./LAND[:,1], Float64.(a[i][:stock][k,:,1]).+.001) for k in 2:400] for i in 1:nsample]
# Get KL of deforestation Rate
KL_deforest_rate=[[kl_divergence(deforest_data[:,1].+1.1, deforesation_rate[i][k].+1.1) for k in 1:399] for i in 1:nsample]
# get KL of effort
# This one does not use the exact group information
KL_effort=[[kl_divergence(e[:,1].+ .0001, Float64.(sample(a[i][:effortfull][k,:,1], size(e)[1])).+ .0001) for k in 2:400] for i in 1:nsample]

#####################################
######## SAVE THE OUTPUT ############
time_stamp = now()
time_stamp=replace(string(time_stamp), "." => "_")
time_stamp=replace(string(time_stamp), ":" => "_")
time_stamp=replace(string(time_stamp), "-" => "_")
filename=string("cpr/data/KL_", time_stamp, ".JLD2")
jldsave(filename; KL_effort, KL_stock_levels, KL_deforest_rate, deforesation_rate, S)

# This one uses exactly the right information from each shehia!
# BUT IT TAKES A DAMN LONG TIME!
# KL_effort = []
# for i in 1:nsample 
#     temp = []
#     for k in 2:400
#         # We want to make a vector that matches up people to exactly the correct shehia
#         e_synth=ones(size(e)[1])
#         for j in 1:24
#             ind = ward_id[:,1] .== j
#             e_synth[ind]=sample(a[i][:effortfull][k,a[i][:gid].==j,1], sum(ind)).+.0001
#         end
#         push!(temp, kl_divergence(e[:,1].+ .0001, e_synth)) 
#     end
#     push!(KL_effort, temp)
# end
