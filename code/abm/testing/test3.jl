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


####################################
############ WEALTH ################

test=cpr_abm()

using(Plots)

histogram(test[:wealth][:,1:1])

anim = @animate for i = 1:500

       h= histogram(test[:wealth][:,i,1],
            nbins =300,
            ylim = (0, 50),
            xlim =(0, 20),
            label = "Wealth",
            xlabel = "Wealth",
            xticks = ([1000], ""),
            #title = "year: $i",
             top_margin = 20px)

            age=histogram(test[:age][:,i,1],
             xlim = (0,100),
             ylim = (0,100),
             nbins = 10,
             #orientation = :horizontal,
             label = "age", 
             xlabel = "age",
             xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:10:100),
             yticks = collect(0:10:100),
              size = (400, 400))

            timer=bar([i], xlim = (0,500)
            , orientation = :horizontal,
             label = false, 
             xlabel = "Time",
            xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:50:500),
              yticks = ([10], ("")),
              size = (1000, 100))
              
            # stock=plot(test[:stock][:,:,i],
            #  xlim = (0,500),
            #  label = false, 
            #  xlabel = "Time",
            #  ylabel = "Stock",
            # xguidefontsize=9,
            #  bottom_margin = 20px,
            #  left_margin = 20px, 
            #  xticks = collect(0:50:500),
            #   yticks = ([10], ("")),
            #   size = (1000, 200))



              set1 = plot(h, age, layout = (1,2), size = (1000, 400))

            l = @layout[a;b{.05h}]
            Plots.GridLayout(2, 1)
            plot(set1, timer, 
                size = (1000, 700), 
                left_margin = 20px,
                bottom_margin = 20px, 
                right_margin = 10px,
                layout = l)   
    
 

end

fps = 50
gif(anim, string("test.gif")
, fps = fps)

#############################################
#############################################

histogram(test[:wealth][:,1:1])

test=cpr_abm(inher = true, wages = .05)

using(Plots)

histogram(test[:wealth][:,100,1])

anim = @animate for i = 1:500

       h= histogram(test[:wealth][:,i,1],
            nbins =300,
            ylim = (0, 60),
            xlim =(0, 150),
            label = "Wealth",
            xlabel = "Wealth",
            xticks = ([1000], ""),
            #title = "year: $i",
             top_margin = 20px)

            age=histogram(test[:age][:,i,1],
             xlim = (0,100),
             ylim = (0,100),
             nbins = 10,
             #orientation = :horizontal,
             label = "age", 
             xlabel = "age",
             xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:10:100),
             yticks = collect(0:10:100),
              size = (400, 400))

            timer=bar([i], xlim = (0,500)
            , orientation = :horizontal,
             label = false, 
             xlabel = "Time",
            xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:50:500),
              yticks = ([10], ("")),
              size = (1000, 100))
              
             stock=plot(test[:stock][1:i,:,1],
             xlim = (0,500),
             ylim = (0,1),
             label = false, 
             xlabel = "Time",
             ylabel = "Stock",
            xguidefontsize=9,
             bottom_margin = 20px,
             left_margin = 20px, 
             xticks = collect(0:50:500),
              yticks = ([10], ("")),
              size = (1000, 200))

            group=quantile(test[:wealth][:,1,1], collect(0.1:.1:1))
            wealth = test[:wealth][:,1,1]
            avAge = zeros(10)
            avAge[1] =mean(test[:age][:,1,1][agents.payoff.>= group[1]])
            length(test[:age][(wealth.<= group[1]),1,1])
            for i in 2:10
                avAge[i] = mean(test[:age][:,1,1][(wealth .>= group[i-1]) .& 
                (wealth.<= group[i])])
                println(length(test[:age][:,1,1][(wealth.>= group[i-1]) .& 
                (wealth.<= group[i])]))
            end

            wealth_age=bar(avAge, xticks = collect(1:10), 
            ylab = "Mean age",
            ylim = (0, 70),
            xlab = "Wealth Quantile")


              set1 = plot(h, wealth_age, layout = (1,2), size = (1000, 400))

            l = @layout[a;b{.2h};c{.05h}]
            Plots.GridLayout(3, 1)
            plot(set1, stock, timer,
                size = (1000, 700), 
                left_margin = 20px,
                bottom_margin = 20px, 
                right_margin = 10px,
                layout = l)   
    
 

end

fps = 50
gif(anim, string("test.gif")
, fps = fps)

plot(test[:effort][:,:,1])


cpr_abm()



group=quantile(test[:wealth][:,1,1], collect(0.1:.1:1))
wealth = test[:wealth][:,1,1]
avAge = zeros(10)
avAge[1] =mean(test[:age][:,1,1][agents.payoff.>= group[1]])
length(test[:age][(wealth.<= group[1]),1,1])
for i in 2:10
    avAge[i] = mean(test[:age][:,1,1][(wealth .>= group[i-1]) .& 
    (wealth.<= group[i])])
    println(length(test[:age][:,1,1][(wealth.>= group[i-1]) .& 
    (wealth.<= group[i])]))
end







using FileIO
using LinearAlgebra
using JuliaDB
using JLD2
using Plots
using StatsPlots
using DataFrames
using IndexedTables 

using RDatasets
using Query

import RDatasets
singers=DataFrame(rand(100))
singers = RDatasets.dataset("lattice", "singer")
@df singers violin(string.(:VoicePart), :Height, linewidth=0)
@df singers boxplot!(string.(:VoicePart), :Height, fillalpha=0.75, linewidth=2)
@df singers dotplot!(string.(:VoicePart), :Height, marker=(:black, stroke(0)))

load


y = rand(100, 4) # Four series of 100 points each
violin(["Series 1" "Series 2" "Series 3" "Series 4"], y, leg = false)


using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none_crash.jld2")


labor = unique(S[:,6])
tech = unique(S[:,5])
pars = [:effort]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(labor)*length(pars))
p_arr=reshape(p_arr, length(labor), length(pars))
cols = [:RdBu_9, :PuOr9]

for r in 1:length(pars)
        for k in 1:length(labor)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v = findall(x->x==tech[j], S[:,5])
                        l=l[l.∈ Ref(q)]
                        l=l[l.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                            p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-.1,.1), (0,1)),
                             xlab = "Wages",
                             ylab = "Price",
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ("Low", "High")),
                             yticks = ([2,19], ("Low", "High")),
                             title = string("Effort | Y = 0 \n \n Labor Elasticity = ", round(labor[k], digits = 5)),
                             titlefontsize = 9,
                             top_margin = 20px,
                             right_margin = 20px)

                             for i = 1:length(high)
                                m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                                end
                    
                            gr()
                                p2=heatmap(m,
                                    c=cols[r],
                                    clim= ifelse(r==3, (-.1,.1), (0,1)),
                                    xlab = "Wages",
                                    ylab = " ",
                                    yguidefontsize=9,
                                    xguidefontsize=9,
                                    legend = false,
                                    xticks = ([2,19], ("Low", "High")),
                                    yticks = ([2,19], ("Low", "High")),
                                    title = string("Effort | Y = 1 \n \n Labor Elasticity = ", round(labor[k], digits = 5)),
                                    titlefontsize = 9,
                                    top_margin = 20px,
                                    right_margin = 20px)

                                set1 = [p2 p1]
                                l = @layout[grid(1,2) a{0.05w}] # Stack a layout that rightmost one is for color bar
                                Plots.GridLayout(1, 2)
                                
                                set2 = plot(set1..., heatmap((0:0.01:1).*ones(101,1),
                                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                                string.(0:0.1:1)), title ="\\E", titlefont = 8), layout=l, 
                                size = (800, 340), bottom_margin = 20px, left_margin = 20px)
    
                end
        end

        fps = 1.5
        anim = @animate for i = 1:10
        #Define line settings
        plot(p_arr[i, 1])
        end
        gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\test2.gif")
        , fps = fps)



        for r in 1:length(pars)
            for k in 1:length(labor)
                            l=findall(x->x==0.001, S[:,10])
                            h=findall(x->x==0.9, S[:,10])
                            q=findall(x->x==labor[k], S[:,6])
                            v = findall(x->x==tech[j], S[:,5])
                            l=l[l.∈ Ref(q)]
                            l=l[l.∈ Ref(v)]
                            h=h[h.∈ Ref(q)]
                            h=h[h.∈ Ref(v)]
                            low = abm_dat[l]
                            high =abm_dat[h]
                            m = zeros(20,20)
                            for i = 1:length(high)
                                m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2)-mean(low[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                                end
                            using Plots
                            gr()
                                p_arr[k,r]=p1=heatmap(m,
                                    c=cols[r],
                                    clim= ifelse(r==3, (-.1,.1), (-1,1)),
                                    xlab = "Wages",
                                    ylab = "Price",
                                    yguidefontsize=9,
                                    xguidefontsize=9,
                                    legend = true,
                                    xticks = ([2,19], ("Low", "High")),
                                    yticks = ([2,19], ("Low", "High")),
                                    title = string("Effort \n \n Labor Elasticity = ", round(labor[k], digits = 5)),
                                    titlefontsize = 9,
                                    top_margin = 20px,
                                    right_margin = 20px)
                    end
            end
    
                    fps = 1.5
                    anim = @animate for i = 1:10
                    #Define line settings
                    plot(p_arr[i, 1])
                    end
                    gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\test2.gif")
                    , fps = fps)
    


                    @everywhere function g()
                        cpr_abm(
                        ngroups = 2,
                        n = 150*2,
                        tech = 1,
                        wages = .1,
                        price = 1,
                        max_forest=10000*2,
                        nrounds = 1000,
                        nsim =1,
                        regrow = .01,
                        labor = .7,
                        lattice =[2,1],
                        var_forest = 0,
                        pun1_on = true,
                        pun2_on =true,
                        travel_cost = .00001,
                        outgroup = 0.01,
                        harvest_var = .07,
                        defensibility = 1,
                        seized_on = true,
                        leak = true,
                        invasion = true,
                        og_on = true,
                        power = "wealth",
                        fines_on = true,
                        fines1_on = true,
                        fines_evolve = true,
                        fines2_on = true,
                        verbose = false,
                        fine_start = .1,
                        fine_var = .2,
                        glearn_strat = "wealth",
                        monitor_tech = [1,1],
                        harvest_type = "individual",
                        policy_weight = "min"
                    )
                    end
                    
using LatinHypercubeSampling



                    S =expand_grid(
                        [false, true],                          # Seized 
                        [false, true],                          # Og
                        [false, true],                          # Fine2
                        ["wealth", "income", "env", false],     # Glearn_strat
                        ["equal", "min", "max"],                # Policy weight
                        ["income", "wealth"]                    # Learn Strategy
                        )
        


                    #set up a smaller call function that allows for only a sub-set of pars to be manipulated
function getBaseline()
    cpr_abm(
    ngroups = 2,
    n = 150*2,
    tech = .01,
    wages = .1,
    price = 1,
    max_forest=10000*2,
    nrounds = 10000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[1,2],
    var_forest = 0,
    travel_cost = .00001,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    harvest_limit = .1,
    seized_on = false,
    fines_on = false,
    fines1_on = false,
    fines_evolve = false,
    fines2_on = false,
    verbose = false,
    pun1_on = false,
    pun2_on =false,
    leak = false,
    invasion = true,
    og_on = false,
    fine_start = .1,
    fine_var = .2,
    glearn_strat = "income",
    monitor_tech = [1,1],
    harvest_type = "individual",
    policy_weight = "equal",
    learn_type = "income"
)
end

tech_data = [collect(.001:.001:1); ones(1000) ; collect(1.001:.001:2); ones(1000)*2; collect(2.001:.001:3); ones(1000)*3]
tech_data = collect(.0005:.0005:3)

test=cpr_abm(max_forest = 10000*15, lattice = [3,5], wages = .2, ngroups = 15,
 n = 150*15, tech = .5, nrounds = 6000, leak = true, pun2_on = true,
 harvest_limit = .1, fines_on = true, fines2_on = true, fines_evolve = true, tech_data = tech_data, invasion = true)
using Plots



plot(test[:stock][:,:,1])
plot(test[:effort][:,:,1])
plot(test[:punish][:,:,1])
plot(test[:punish2][:,:,1])
plot(test[:leakage][:,:,1])
plot(test[:payoffR][:,:,1])

test=cpr_abm(max_forest = 10000*15, lattice = [3,5], wages = .2, ngroups = 15,
 n = 150*15, tech = .5, nrounds = 3000, leak = true, pun2_on = true,
 harvest_limit = .1, fines_on = true, fines2_on = true, fines_evolve = true,
  tech_data = tech_data, invasion = true, rec_history = true)
using Plots

v = Matrix{Float64}[]
x = rand(3, 5)
push!(v, x)
for i in 1:2999 push!(v,x) end



anim = @animate for i = 1:30:3000
    for g in 1:15
        x[g] = test[:stock][i,g,1]
    end
    heatmap(x, clim = (0,1))
end
fps = 30
gif(anim, 
string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\test.gif")
                , fps = fps)

png("cpr/output/test.png")
plot(test[:stock][:,:,1], legend = false)

png("cpr/output/saviour_effort.png")
plot(test[:effort][:,:,1])
histogram(test[:wealth][:,3000,1], bins = 40)
plot(test[:punish2][:,:,1])
plot(test[:limit][:,:,1])
plot(mean(test[:leakage][:,:,1], dims = 3), alpha = .1)
plot(test[:payoffR][:,:,1], alpha = .1)
plot(tech_data[1:3000])



tech_data = [ones(1000) *.5; collect(.501:.001:1.5); ones(1000)*1.5]

test=cpr_abm(max_forest = 10000*15, lattice = [3,5], wages = .2, ngroups = 15,
 n = 150*15, tech = .5, nrounds = 3000, leak = true, pun2_on = true,
 harvest_limit = .1, fines_on = true, fines2_on = true, fines_evolve = true,
  tech_data = tech_data, invasion = true, rec_history = true, inher = true)

plot(test[:stock][:,:,1])


#see baseline
test1=cpr_abm(max_forest = 10000*15, lattice = [3,5], wages = .2, ngroups = 15,
 n = 150*15, tech = .5, nrounds = 3000, leak = false, pun2_on = false,
 harvest_limit = .1, fines_on = false, fines2_on = true, fines_evolve = true,
  tech_data = tech_data, invasion = true, rec_history = true, inher = true)

plot(test1[:stock][:,:,1])
plot(test1[:punish2][:,:,1])
plot(test1[:limit][:,:,1] , legend = false)
plot(test1[:payoffR][:,:,1] , legend = false)
plot(test1[:effort][:,:,1] , legend = false)




#see add self regulation
test2=cpr_abm(max_forest = 10000*15, lattice = [3,5], wages = .2, ngroups = 15,
 n = 150*15, tech = .5, nrounds = 3000, leak = false, pun2_on = true,
 harvest_limit = .1, fines_on = false, fines2_on = true, fines_evolve = true,
  tech_data = tech_data, invasion = true, rec_history = true, inher = true)

plot(test2[:stock][:,:,1])
plot(test2[:punish2][:,:,1])
plot(test2[:limit][:,:,1] , legend = false)
plot(test2[:payoffR][:,:,1] , legend = false)
plot(test2[:effort][:,:,1] , legend = false)


# add fine
test3=cpr_abm(max_forest = 10000*15, lattice = [3,5], wages = .2, ngroups = 15,
 n = 150*15, tech = .5, nrounds = 3000, leak = false, pun2_on = true,
 harvest_limit = .1, fines_on = true, fines2_on = true, fines_evolve = true,
  tech_data = tech_data, invasion = true, rec_history = true, inher = true)

plot(test3[:stock][:,:,1])
plot(test3[:punish2][:,:,1])
plot(test3[:limit][:,:,1] , legend = false)
plot(test3[:payoffR][:,:,1] , legend = false)
plot(test3[:effort][:,:,1] , legend = false)
plot(test3[:fine2][:,:,1] , legend = false)


# add glearn strat
test4=cpr_abm(max_forest = 10000*15, lattice = [3,5], wages = .2, ngroups = 15,
 n = 150*15, tech = .5, nrounds = 3000, leak = false, pun2_on = true,
 harvest_limit = .1, fines_on = true, fines2_on = true, fines_evolve = true,
  tech_data = tech_data, invasion = true, rec_history = true, inher = true, glearn_strat = "income")

plot(test4[:stock][:,:,1], legend = false)
plot(test4[:punish2][:,:,1])
plot(test4[:limit][:,:,1] , legend = false)
plot(test4[:payoffR][:,:,1] , legend = false)
plot(test4[:effort][:,:,1] , legend = false)
plot(test4[:fine2][:,:,1] , legend = false)

# turn leak on
test5=cpr_abm(max_forest = 10000*15, lattice = [3,5], wages = .2, ngroups = 15,
 n = 150*15, tech = .5, nrounds = 3000, leak = true, pun2_on = true,
 harvest_limit = .05, fines_on = true, fines2_on = true, fines_evolve = true,
 tech_data = tech_data, invasion = true, rec_history = true, inher = true, glearn_strat = "income")

plot(test5[:stock][:,:,1], legend = false)
plot(test5[:punish2][:,:,1])
plot(test5[:limit][:,:,1] , legend = false)
plot(test5[:payoffR][:,:,1] , legend = false)
plot(test5[:effort][:,:,1] , legend = false)
plot(test5[:fine2][:,:,1] , legend = false)
plot(test5[:harvest][:,:,1] , legend = false)
plot(test5[:fstLimit][:,:,1] , legend = false)
