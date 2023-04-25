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
using JLD2
using MixedModels
using StatsModels
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
nsample = 3000

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
# density(wage_prior)
# wage_prior=WAGE[sample(1:nrow(WAGE), nsample),:]
LAND_prior=LAND./mean(LAND)
# Parameters to Estimate
regrow_prior = rand(Gamma(3, .0075), nsample)
# density(regrow_prior)
α_prior = rand(Gamma(5, .06), nsample)
# density(α_prior)
travel_cost_prior  = rand(Gamma(4, .01), nsample)
# density(travel_cost_prior)

#############################################################
######### COMPILE MATRIX FOR DISTRIBUTED PROCESSSING ########


priors = Dict(
:regrow=>median(S[best, 1]),
:iota=>median(S[best, 2]),
:travel_cost=>median(S[best, 3]),
:wage => median(S[best, 4]),
:gsize=>Int.(round.(POP[:,2]/10)),
:land => LAND./mean(LAND),
:beta =>  median.(eachcol(BETA)),
:tech =>  median.(eachcol(TECH)),
:labor  => median.(eachcol(ALPHA))) 



S2=Matrix(undef, nsample, 11)
S2[:,1] = fill(median(S[best, 1]), nsample)
S2[:,2] = fill(median(S[best, 2]), nsample)
S2[:,3] = fill(median(S[best, 3]), nsample)
S2[:,4] = fill(median(S[best, 4]), nsample)
S2[:,5] = fill(LAND_prior, nsample)
S2[:,6] = fill(GSIZE, nsample)
S2[:,7] =  fill(median.(eachcol(BETA)), nsample)
S2[:,8] =  fill(median.(eachcol(TECH)), nsample)
S2[:,9] = fill(median.(eachcol(ALPHA)), nsample)
S2[:, 10] = rand(Gamma(1, 1), nsample) # Insitutional cost
S2[:, 11] = rand(Gamma(40, 1), nsample) # Limit cost
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
    labor_data,
    inst_cost_prior,
    harvest_limit_prior) 
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
                harvest_limit = harvest_limit_prior,
                punish_cost= inst_cost_prior,
                harvest_var_ind = 4,
                # Model Settings                
                n = 100*24,
                nrounds = 600,
                ngroups = 24, 
                lattice = [6, 4], 
                pun1_on = false,
                pun2_on = true,
                leak = true,
                full_save = true,
                social_learning = true,
                fidelity = .2,        
                distance_adj = .1,
                groups_sampled = 23,
                mutation = .03,
                invasion = true,
                )
end

a=pmap(g, S2[:,1],S2[:,2],S2[:,3],S2[:,4],S2[:,5],S2[:,6],S2[:,7],S2[:,8],S2[:,9], S2[:,10], S2[:,11])
using JLD2
# Save the output
# jldsave("test_ABC_punish2.JDL2"; a)


#####################################################
############## GENERATE KL divergences ##############
# Calculate Deforesation rate for all sets
deforesation_rate=[[(a[i][:stock][k,:,1].+.0001 .-a[i][:stock][k-1,:,1].+ .0001)./(a[i][:stock][k-1,:,1].+.0001) for k in 2:600 ] for i in 1:nsample]
# Get KL of stock level
KL_stock_levels=[[kl_divergence(FOREST[:,1]./LAND[:,1], Float64.(a[i][:stock][k,:,1]).+.001) for k in 2:600] for i in 1:nsample]
# Get KL of deforestation Rate
KL_deforest_rate=[[kl_divergence(deforest_data[:,1].+1.1, deforesation_rate[i][k].+1.1) for k in 1:599] for i in 1:nsample]
# get KL of effort
# This one does not use the exact group information
KL_effort=[[kl_divergence(e[:,1].+ .0001, Float64.(sample(a[i][:effortfull][k,:,1], size(e)[1])).+ .0001) for k in 2:600] for i in 1:nsample]

#####################################
######## SAVE THE OUTPUT ############
time_stamp = now()
time_stamp=replace(string(time_stamp), "." => "_")
time_stamp=replace(string(time_stamp), ":" => "_")
time_stamp=replace(string(time_stamp), "-" => "_")
filename=string("cpr/data/KL_punish2", time_stamp, ".JLD2")
jldsave(filename; KL_effort, KL_stock_levels, KL_deforest_rate, deforesation_rate, S2)

# This one uses exactly the right information from each shehia!
# BUT IT TAKES A DAMN LONG TIME!
# KL_effort = []
# for i in 1:nsample 
#     temp = []
#     for k in 2:600
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

KL=load("cpr/data//KL_punish22022_12_12T17_39_18_847.JLD2")
#Assign Data
KL_effort = KL["KL_effort"]
KL_deforest_rate = KL["KL_deforest_rate"]
deforesation_rate = KL["deforesation_rate"]
KL_stock_levels = KL["KL_stock_levels"]
S2 = KL["S2"]

nsample = size(S2)[1]


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
use_effort = false # For the time-step by time-step evaluation only score on deforesation and stock
#output_plots = []
for j in 1:nsample
    arr= [KL_effort[j] KL_deforest_rate[j] KL_stock_levels[j]]
    # Note that the best KL are those closes to invasion!
    # Thus you need to reorder these
    for i in 1:size(arr)[2]
        tempx=abs.(0 .-arr[:,i])
        maxx = findmax(tempx)[1]
        arr[:,i]= -(tempx) # Mpte that this just has to become postiive!
    end
    n = size(arr)[1]
    if use_effort
        fronts=nds4(arr);
    else
        fronts=nds4(arr[:,2:3])
    end
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

best=nds4(output)[2]
best_moving=nds4(output_moving)[2]



# Plot 
punish=density(S2[best,10], xlab = "r", label = nothing, yaxis = nothing, ylab = "Density");
density!(S2[:,10],label = nothing);
vline!([median(S2[best,10])], l = :dash, c = :red, label = nothing);
limit =density(S2[best,11], xlab = "ι", label = nothing, yaxis = nothing);
density!(S2[:,11], label = nothing) ;
vline!([median(S2[best,11])], l = :dash, c = :red, label = nothing);

# densities=Plots.plot(limit, punish) 


cores_current = nprocs()
cores_current >= ncores ? nothing : addprocs(ncores - current_cores)
# nprocs() == 1 ? addprocs(ncores) : println("Please stop this should only be done when one core active before begining") 
# include("C:/Users/jeffr/Documents/Work/cpr/code/abm/initalize_home.jl")
@everywhere include("cpr/code/abm/initalize_work.jl")

@everywhere function sims(priors)  
    cpr_abm(    # Data
    tech = priors[:tech],
    degrade = priors[:beta],
    kmax_data = 1000000 .*priors[:land],
    population_data = priors[:gsize],
    labor = priors[:labor], 
    # Priors
    regrow = priors[:regrow],
    travel_cost = priors[:travel_cost],
    wages = priors[:wage],
    α = priors[:iota],
    harvest_limit = priors[:limit],
    punish_cost= priors[:cost],
    harvest_var_ind = 4,                
    # Model Settings                
    n = 100*24,
    nrounds = 600,
    monitor_tech =  1,
    ngroups = 24, 
    lattice = [6, 4], 
    pun1_on = false,
    pun2_on = true,
    leak = true,
    full_save = true,
    social_learning = true,
    fidelity = .2,        
    distance_adj = .1,
    groups_sampled = 23,
    mutation = .03,
    invasion = true,
    nsim = 1
    )
end



priors = Dict(
:regrow=>median(S2[best, 1]),
:iota=>median(S2[best, 2]),
:travel_cost=>median(S2[best, 3]),
:wage => median(S2[best, 4]),
:gsize=>Int.(round.(POP[:,2]/10)),
:land => LAND./mean(LAND),
:beta =>  median.(eachcol(BETA)),
:tech =>  median.(eachcol(TECH)),
:labor  => median.(eachcol(ALPHA)),
:limit => 20,
:cost => .15) 

# Run
S3=fill(priors, nsim)
output=pmap(sims, S3[:])

# Save
jldsave("post_abc_predictive_sims_punish.JLD2"; output)
loaded=load("cpr/data/post_abc_predictive_sims_punish.JLD2")
a=loaded["output"]
deforest_data =DataFrame(CSV.File("cpr/data/abc_data_deforesation.csv"))[:,2:end]
e=DataFrame(CSV.File("cpr/data/abc_data_effort_firewood.csv"))[:,2:end]



LAND_prior=LAND./mean(LAND)
# get average leakage into a group at each time step 
# Scatter that against effort
nsim = 100
nround = 400
output = zeros(nsim, nround)
for k in 1:nsim 
    theft=[[mean((a[k][:loc][i,:,1].==j) .& (a[k][:gid][:,1].!=j)  ) for j in 1:24] for i in 1:nround] 
    coefs = zeros(nround, 4)
    for i in 2:nround
        df=DataFrame(:effort => Float64.(a[k][:punish2full][i, :, 1]),
                :theft => theft[i-1][Int.(a[k][:gid][:,1])][:,1],
                :stock => (LAND_prior.*a[k][:stock][i-1,:,1])[Int.(a[k][:gid][:,1])][:,1],
                :land => LAND[Int.(a[k][:gid][:,1])],
                :gid =>  categorical(Int.(a[k][:gid][:,1])),
                :pop => POP[:, 2][Int.(a[k][:gid][:,1])])
        fm = @formula(log1p(effort) ~ log1p(theft) + log1p(land) + log1p(pop)) 
       # fm = @formula(log1p(effort) ~ (1|gid) + log1p(theft) + log(pop) + log(land)) 
        m1=lm(fm, df)
    #    m1=fit(MixedModel, fm, df)
        typeof(m1)
        coefs[i,:]=coef(m1)
    end
    output[k,:] = coefs[:, 2]
    println(k)
end



effort_plot=plot(title = "Effort", titlefontsize = 8)
for i in 2:nround
    scatter!(fill(i, nsim), output[:,i], color = :firebrick, alpha = .1, label = false)
end
plot!(mean(output, dims = 1)', ylim = (-2, 2), lw = 2, c= :orange, label = false, xlab = "Time step", ylab = "Coefficent estimate")
hline!([0], c=:grey, lw = 2, label = "")
vspan!(effort_plot, hpdi_bounds, label = nothing, color = :grey, alpha = .3)


# Examine overall leakage 
nsim = 100
output = zeros(nsim, nround)
for k in 1:nsim 
    theft=[[mean((a[1][:loc][i,:,1].==j) .& (a[k][:gid][:,1].!=j)) for j in 1:24] for i in 1:nround] 
    coefs = zeros(nround, 3)
    for i in 2:nround
        df=DataFrame(:leak => Float64.(a[k][:limitfull][i, :, 1]),
        :theft => theft[i-1][Int.(a[k][:gid][:,1])][:,1],
        #:stock => (LAND_prior.*a[k][:stock][i-1,:,1])[Int.(a[k][:gid][:,1])][:,1],
        :stock => LAND[Int.(a[k][:gid][:,1])][:,1],
        :pop => POP[:, 2][Int.(a[k][:gid][:,1])][:,1])
        # fm = @formula(leak ~ theft + stock + pop)
        fm = @formula(leak ~ theft +  pop) 
         
        # m1=glm(fm, df, Binomial(), LogitLink())
        m1=lm(fm, df)
        typeof(m1)
        coefs[i,:]=coef(m1)
    end
    output[k,:] = coefs[:, 2]
end

leakage_plot=plot()
for i in 2:nround
    scatter!(fill(i, nsim), output[:,i], color = :firebrick, alpha = .1, label = false)
end
plot!(moving_average(mean(output, dims = 1)', 10), lw = 2, c= :orange, label = false, xlab = "Time step", ylab = "", title = "Leakage", titlefontsize = 8)
hline!([0], c=:grey, lw = 2, label = nothing)
vspan!(leakage_plot, [hpdi_bounds], label = nothing, color = :grey, alpha = .3)



###########################################################
############## PUNISH 1 ###################################


@everywhere function sims(priors)  
    cpr_abm(    # Data
    tech = priors[:tech],
    degrade = priors[:beta],
    kmax_data = 1000000 .*priors[:land],
    population_data = priors[:gsize],
    labor = priors[:labor], 
    # Priors
    regrow = priors[:regrow],
    travel_cost = priors[:travel_cost],
    wages = priors[:wage],
    α = priors[:iota],
    harvest_limit = priors[:limit],
    punish_cost= priors[:cost],
    harvest_var_ind = 4,                
    # Model Settings                
    n = 100*24,
    nrounds = 600,
    ngroups = 24, 
    lattice = [6, 4], 
    pun1_on = true,
    inspect_timing = "after",
    pun2_on = false,
    leak = true,
    monitor_tech =  1,
    defensibility = 100, 
    full_save = true,
    social_learning = true,
    fidelity = .2,        
    distance_adj = .1,
    groups_sampled = 23,
    mutation = .03,
    invasion = true,
    nsim = 1
    )
end



priors = Dict(
:regrow=>median(S2[best, 1]),
:iota=>median(S2[best, 2]),
:travel_cost=>median(S2[best, 3]),
:wage => median(S2[best, 4]),
:gsize=>Int.(round.(POP[:,2]/10)),
:land => LAND./mean(LAND),
:beta =>  median.(eachcol(BETA)),
:tech =>  median.(eachcol(TECH)),
:labor  => median.(eachcol(ALPHA)),
:limit => 20,
:cost => .0015) 


# Run
S3=fill(priors, nsim)
output=pmap(sims, S3[:])

# Save
jldsave("post_abc_predictive_sims_punish1.JLD2"; output)
loaded=load("cpr/data/post_abc_predictive_sims_punish1.JLD2")
a=loaded["output"]
deforest_data =DataFrame(CSV.File("cpr/data/abc_data_deforesation.csv"))[:,2:end]
e=DataFrame(CSV.File("cpr/data/abc_data_effort_firewood.csv"))[:,2:end]



LAND_prior=LAND./mean(LAND)
# get average leakage into a group at each time step 
# Scatter that against effort
nsim = 100
nround = 600
output = zeros(nsim, nround)
for k in 1:nsim 
    theft=[[mean((a[k][:loc][i,:,1].==j) .& (a[k][:gid][:,1].!=j)  ) for j in 1:24] for i in 1:nround] 
    coefs = zeros(nround, 4)
    for i in 2:nround
        df=DataFrame(:effort => Float64.(a[k][:punishfull][i, :, 1]),
                :theft => theft[i-1][Int.(a[k][:gid][:,1])][:,1],
                 :stock => (LAND_prior.*a[k][:stock][i-1,:,1])[Int.(a[k][:gid][:,1])][:,1],
                :land => LAND[Int.(a[k][:gid][:,1])],
                :pop => POP[:, 2][Int.(a[k][:gid][:,1])])
        # fm = @formula(effort ~ theft + stock + pop) 
        fm = @formula(log1p(effort) ~ log1p(theft) + log(pop) + log(land)) 
        m1=lm(fm, df)
        typeof(m1)
        coefs[i,:]=coef(m1)
    end
    output[k,:] = coefs[:, 2]
end


effort_plot=plot(title = "Effort", titlefontsize = 8)
for i in 2:nround
    scatter!(fill(i, nsim), output[:,i], color = :firebrick, alpha = .1, label = false)
end
plot!(mean(output, dims = 1)', ylim = (-2, 10), lw = 2, c= :orange, label = false, xlab = "Time step", ylab = "Coefficent estimate")
hline!([0], c=:grey, lw = 2, label = "")
vspan!(effort_plot, hpdi_bounds, label = nothing, color = :grey, alpha = .3)
