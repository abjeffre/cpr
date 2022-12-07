
############################################################
############## GENERATE PREDICTIONS ########################

# Now we shall sample rerun the model using the median parameter values given by the ABC
# Then for each time point in each for each simulaton we shall run two simple linear models 
# The first predicts the relationship between the intesity of leakage and effort given population size, and forest size.
# The second predicts the relationship between the intesity of leakage in and leakage out given population size, and forest size.
# The coefficents from these estimates are then plotted on a scatter plot, to show the range of expectations given the data generating PROCESS

include("ABC_processing.jl")

regrowth_prior_round2=median(S[best_moving, 1])
alpha_prior_round2=median(S[best_moving, 2])
travel_prior_round2=median(S[best_moving, 3])
wage_prior_round2=median(S[best_moving, 4])
S[:,6] = fill(GSIZE, nsample)
S[:,7] =  fill(median.(eachcol(BETA)), nsample)
S[:,8] =  fill(median.(eachcol(TECH)), nsample)
S[:,9] = fill(median.(eachcol(ALPHA)), nsample)


a=cpr_abm(    # Data
tech = median.(eachcol(TECH)),
degrade = median.(eachcol(BETA)),
kmax_data = 1000000 .*LAND_prior,
population_data = GSIZE,
labor = median.(eachcol(ALPHA)), 
# Priors
regrow = regrowth_prior_round2,
travel_cost = travel_prior_round2,
wages = wage_prior_round2,
α = alpha_prior_round2,                
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
nsim = 100
)

jldsave("post_abc_predictive_sims.JLD2"; a)
loaded=load("post_abc_predictive_sims.JLD2")
a=loaded["a"]

deforesation_rate=[[(a[:stock][k,:,i].+.0001 .-a[:stock][k-1,:,i].+ .0001)./(a[:stock][k-1,:,i].+.0001) for k in 2:400 ] for i in 1:100]
# Get KL of stock level
KL_stock_levels=[[kl_divergence(FOREST[:,1]./LAND[:,1], Float64.(a[:stock][k,:,i]).+.001) for k in 2:400] for i in 1:100]
# Get KL of deforestation Rate
KL_deforest_rate=[[kl_divergence(deforest_data[:,1].+1.1, deforesation_rate[i][k].+1.1) for k in 1:399] for i in 1:100]
# get KL of effort
# This one does not use the exact group information
KL_effort=[[kl_divergence(e[:,1].+ .0001, Float64.(sample(a[:effortfull][k,:,i], size(e)[1])).+ .0001) for k in 2:400] for i in 1:100]


font_out = []
for j in 1:100
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
        frontrank_moving=moving_average(frontrank, 2)
    end
    push!(font_out, fronts[1])
 #   push!(output_plots, plot(frontrank))
end

out=reduce(vcat, font_out)
out=out[out .> 50]
hpdi_bounds=hpdi(out, alpha = .50)

