#####################################################
############## Heatmaps #############################

using Distributed
@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)

@everywhere include("setup_utilies.jl")
@everywhere include("abm_neigh.jl")

addprocs(15)

S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0.0],             #travel cost
                [1],             #tech
                [.9],            #labor
                [0.1],           #limit seed values
                [.0015],         #Punish Cost
                [45000],         #max forest
                [0.001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],       #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],           #var forest
                10 .^(collect(range(-2, stop = 0, length = 10))),          #price
                [.01],        #regrowth
                [[1, 1]], #degrade
                10 .^(collect(range(-3, stop = 1, length = 10)))       #wages
                )



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 1,
            fine_start = nothing,
            leak = false,
            pun1_on = false,
            pun2_on = false,
            experiment_effort = .75,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            max_forest = mf,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_punish2 = ep,
            experiment_group = eg,
            groups_sampled =gs,
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("abm_dat_effort_hm_leak6.jld2", abm_dat, S)





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 5,
            fine_start = nothing,
            leak = true,
            pun1_on = true,
            pun2_on = false,
            experiment_effort = 1
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            max_forest = mf,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_punish2 = ep,
            experiment_group = eg,
            groups_sampled =gs,
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("abm_dat_effort_hm_leakp16.jld2", abm_dat, S)



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 5,
            fine_start = nothing,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            max_forest = mf,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_punish2 = ep,
            experiment_group = eg,
            groups_sampled =gs,
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("abm_dat_effort_hm_leakp1p26.jld2", abm_dat, S)


using MakieLayout
using ColorSchemes

using AbstractPlotting




scene, layout = layoutscene(30, resolution = (1200, 900))


ncols = 4
nrows = 4

# create a grid of LAxis objects
axes = [LAxis(scene) for i in 1:nrows, j in 1:ncols]
# and place them into the layout
layout[1:nrows, 1:ncols] = axes

# link x and y axes of all LAxis objects
linkxaxes!(axes...)
linkyaxes!(axes...)

lineplots = [lines!(axes[i, j], (1:0.1:8pi) .+ i, sin.(1:0.1:8pi) .+ j,
        color = get(ColorSchemes.rainbow, ((i - 1) * nrows + j) / (nrows * ncols)), linewidth = 4)
    for i in 1:nrows, j in 1:ncols]

for i in 1:nrows, j in 1:ncols
    # remove unnecessary decorations in some of the facets, this will have an
    # effect on the layout as the freed up space will be used to make the axes
    # bigger
    i > 1 && (axes[i, j].titlevisible = false)
    j > 1 && (axes[i, j].ylabelvisible = false)
    j > 1 && (axes[i, j].yticklabelsvisible = false)
    j > 1 && (axes[i, j].yticksvisible = false)
    i < nrows && (axes[i, j].xticklabelsvisible = false)
    i < nrows && (axes[i, j].xticksvisible = false)
    i < nrows && (axes[i, j].xlabelvisible = false)
end

autolimits!(axes[1]) # hide

legend = LLegend(scene, permutedims(lineplots, (2, 1)), ["Line $i" for i in 1:length(lineplots)],
    ncols = 2)
# place a legend on the side by indexing into one column after the current last
layout[:, end+1] = legend

# index into the 0th row, thereby adding a new row into the layout and place
# a text object across the first four columns as a super title
layout[0, 1:4] = LText(scene, text="MakieLayout Facets", textsize=50)

scene




#####################################################
############## Heatmaps #############################

using(Distributed)
addprocs(25)
@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)
@everywhere using(Statistics)

@everywhere include("functions/utility.jl")
@everywhere include("cpr/code/abm/abm_indv.jl")



S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0],             #travel cost
                [1],             #tech
                [.5],     #labor
                [0.1],           #limit seed values
                [.0015],         #Punish Cost
                [15000],          #max forest
                [0.001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],           #var forest
                10 .^(collect(range(-2, stop = 1, length = 10))),          #price
                [.025],        #regrowth
                [[1, 1]], #degrade
                10 .^(collect(range(-4, stop = 0, length = 10)))       #wages
                )





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 1,
            fine_start = nothing,
            leak = false,
            pun1_on = false,
            pun2_on = false,
            necessity = .15,
            experiment_effort = 1,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            max_forest = mf,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_punish2 = ep,
            experiment_group = eg,
            groups_sampled =gs,
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("abm_dat_effort_hm_none.jld2", abm_dat, S)


test1 = cpr_abm(max_forest = 7500, nrounds = 1000, ngroups = 2, lattice = [1,2],
nsim = 1, wages = .1, experiment_leak= .01, experiment_effort = .50
tech =1,
leak = false, pun1_on = false, pun2_on = false, necessity = .00, travel_cost = .00001, back_leak = true, 
regrow = .01, price = 1)

test2 = cpr_abm(n = 300, max_forest = 7500, nrounds = 1000, ngroups = 2, lattice = [1,2],
 experiment_leak= 1, experiment_effort = .50, nsim = 1,  wages = .1,
 tech =1,
 leak = true, pun1_on = false, pun2_on = true, necessity = .00, travel_cost = .000001 , back_leak = true, 
regrow = .01, price = 1, fidelity = .01)


plot(test1[:effort][:,2,:], color = "goldenrod")
plot!(test2[:effort][:,2,:], color = "blue")

plot(test1[:stock][:,2,:], color = "goldenrod")
plot!(test2[:stock][:,2,:], color = "blue")

plot(test1[:payoffR][:,2,:], color = "goldenrod")
plot!(test2[:payoffR][:,2,:], color = "blue")

plot(test1[:leakage][:,2,:], color = "goldenrod")
plot!(test2[:leakage][:,2,:], color = "blue")


plot(test2[:effort][:,1,:], color = "goldenrod")
plot!(test2[:stock][:,1,:], color = "blue")
plot!(test2[:leakage][:,1,:], color = "blue")