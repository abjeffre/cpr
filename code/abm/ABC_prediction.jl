
############################################################
############## GENERATE PREDICTIONS ########################

# Now we shall sample rerun the model using the median parameter values given by the ABC
# Then for each time point in each for each simulaton we shall run two simple linear models 
# The first predicts the relationship between the intesity of leakage and effort given population size, and forest size.
# The second predicts the relationship between the intesity of leakage in and leakage out given population size, and forest size.
# The coefficents from these estimates are then plotted on a scatter plot, to show the range of expectations given the data generating PROCESS


# Make parallel

function cpr_par(nsim, priors = priors)
    nprocs() == 1 ? addprocs(29) : printl("Please stop this should only be done when one core active before begining") 
    include("C:/Users/jeffr/Documents/Work/cpr/code/abm/initalize_home.jl")
    
    function sims(priors)  
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
        # Model Settings                
        n = 100*24,
        nrounds = 600,
        ngroups = 24, 
        lattice = [6, 4], 
        pun1_on = false,
        pun2_on = false,
        leak = true,
        full_save = true,
        social_learning = true,
        fidelity = .2,        
        distance_adj = .1,
        groups_sampled = 23,
        mutation = .03,
        zero = true,
        nsim = 1
        )
    end
    S=fill(priors, nsim)
    output=pmap(sims, S[:])
    return(output)
    rmprocs(29)
end


include("ABC_processing.jl")

###################################
####### WRITE OUT PRIORS ##########

priors = Dict(
:regrow=>median(S[best_moving, 1]),
:iota=>median(S[best_moving, 2]),
:travel_cost=>median(S[best_moving, 3]),
:wage => median(S[best_moving, 4]),
:gsize=>Int.(round.(POP[:,2]/10)),
:land => LAND./mean(LAND),
:beta =>  median.(eachcol(BETA)),
:tech =>  median.(eachcol(TECH)),
:labor  => median.(eachcol(ALPHA))) 


a=cpr_par(nsim, priors)





jldsave("post_abc_predictive_sims.JLD2"; a)
loaded=load("post_abc_predictive_sims.JLD2")
a=loaded["a"]
deforest_data =DataFrame(CSV.File("cpr/data/abc_data_deforesation.csv"))[:,2:end]
e=DataFrame(CSV.File("cpr/data/abc_data_effort_firewood.csv"))[:,2:end]

deforesation_rate=[[(a[i][:stock][k,:,1].+.0001 .-a[i][:stock][k-1,:,1].+ .0001)./(a[i][:stock][k-1,:,1].+.0001) for k in 2:600 ] for i in 1:100]
# Get KL of stock level
KL_stock_levels=[[kl_divergence(FOREST[:,1]./LAND[:,1], Float64.(a[i][:stock][k,:,1]).+.001) for k in 2:600] for i in 1:100]
# Get KL of deforestation Rate
KL_deforest_rate=[[kl_divergence(deforest_data[:,1].+1.1, deforesation_rate[i][k].+1.1) for k in 1:599] for i in 1:100]
# get KL of effort
# This one does not use the exact group information
KL_effort=[[kl_divergence(e[:,1].+ .0001, Float64.(sample(a[i][:effortfull][k,:,1], size(e)[1])).+ .0001) for k in 2:600] for i in 1:100]


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

