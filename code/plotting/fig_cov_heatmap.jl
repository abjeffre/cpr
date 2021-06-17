########################################################
############# COV LOW BASELINE #########################

using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_p2cont2.jld2")

punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)


pars = [:cel, :cep2, :clp2]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))
cols = [:RdBu_9, cgrad(:PuOr_9, rev = false), :PiYG_5]

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==punishcost[j], S[:,8])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = nanmean(mean(low[i][pars[r]][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-1,1), (-1,1)),
                             xlab = ifelse(r==3, "Wages", " "),
                             ylab = ifelse(k==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 3, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==3, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end
#
# for  r in 1:length(pars)
#         for j in 1:length(labor)
#                 fps = 3
#                 anim = @animate for i = 1:10
#                 #Define line settings
#                 plot(p_arr[i, j, r])
#                 end
#                 gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_pc2_", pars[r], "l", labor[j], ".gif")
#                 , fps = fps)
#         end
# end
#




fps = 1.5
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]
ps3 = [p_arr[i, 1, 3] p_arr[i, 2, 3] p_arr[i, 3, 3]]
l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
string.(-1:0.2:1)), title ="B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 30px, bottom_margin = 10px, top_margin = 20px, right_margin = 10px,
 layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",  
xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b{.05h}]
Plots.GridLayout(4, 1)
plot(set3, test, size = (1000, 350), left_margin = 30px, bottom_margin = 20px, right_margin = 10px, top_margin = 20px,
 layout = l)
end
gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\cov_baseline.gif")
, fps = fps)




########################################################
############# COV LOW BASELINE #########################

using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_p2cont2.jld2")

punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)


pars = [:cel, :cep2, :clp2]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))
cols = [:RdBu_9, cgrad(:PuOr_9, rev = false), :PiYG_5]

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==punishcost[j], S[:,8])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = nanmean(mean(high[i][pars[r]][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-1,1), (-1,1)),
                             xlab = ifelse(r==3, "Wages", " "),
                             ylab = ifelse(k==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 3, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==3, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end
#
# for  r in 1:length(pars)
#         for j in 1:length(labor)
#                 fps = 3
#                 anim = @animate for i = 1:10
#                 #Define line settings
#                 plot(p_arr[i, j, r])
#                 end
#                 gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_pc2_", pars[r], "l", labor[j], ".gif")
#                 , fps = fps)
#         end
# end
#




fps = 1.5
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]
ps3 = [p_arr[i, 1, 3] p_arr[i, 2, 3] p_arr[i, 3, 3]]
l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
string.(-1:0.2:1)), title ="B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 30px, bottom_margin = 10px, top_margin = 20px, right_margin = 10px,
 layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",  
xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b{.05h}]
Plots.GridLayout(4, 1)
plot(set3, test, size = (1000, 350), left_margin = 30px, bottom_margin = 20px, right_margin = 10px, top_margin = 20px,
 layout = l)
end
gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\cov_high.gif")
, fps = fps)






#############################################################################
##################### BASE  LOW ##################################################



punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)


pars = [:punish2, :limit]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))
cols = [:RdBu_9, cgrad(:PuOr_4, rev = true), :PiYG_5]

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==punishcost[j], S[:,8])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = nanmean(mean(low[i][pars[r]][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==2, (0,.2), (0,1)),
                             xlab = ifelse(r==2, "Wages", " "),
                             ylab = ifelse(k==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 3, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==3, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end
#
# for  r in 1:length(pars)
#         for j in 1:length(labor)
#                 fps = 3
#                 anim = @animate for i = 1:10
#                 #Define line settings
#                 plot(p_arr[i, j, r])
#                 end
#                 gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_pc2_", pars[r], "l", labor[j], ".gif")
#                 , fps = fps)
#         end
# end
#




fps = 1.5
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]
#ps3 = [p_arr[i, 1, 3] p_arr[i, 2, 3] p_arr[i, 3, 3]]
l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="R", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(0:0.04:.4)), title ="B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

# l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
# Plots.GridLayout(1, 3)
# set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
# legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
# string.(-1:0.2:1)), title ="B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
# plot(set1, set2, size = (1000, 550), left_margin = 30px, bottom_margin = 10px, top_margin = 20px, right_margin = 10px,
#  layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",  
xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b;c{.05h}]
Plots.GridLayout(4, 1)
plot(set1, set2, test, size = (1000, 700), left_margin = 30px, bottom_margin = 20px, right_margin = 10px, top_margin = 20px,
 layout = l)
end
gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\cov_base_low.gif"), fps = fps)









#############################################################################
##################### BASE  LOW ##################################################



punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)


pars = [:punish2, :limit]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))
cols = [:RdBu_9, cgrad(:PuOr_4, rev = true), :PiYG_5]

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==punishcost[j], S[:,8])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = nanmean(mean(high[i][pars[r]][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==2, (0,.2), (0,1)),
                             xlab = ifelse(r==2, "Wages", " "),
                             ylab = ifelse(k==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 3, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==3, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end
#
# for  r in 1:length(pars)
#         for j in 1:length(labor)
#                 fps = 3
#                 anim = @animate for i = 1:10
#                 #Define line settings
#                 plot(p_arr[i, j, r])
#                 end
#                 gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_pc2_", pars[r], "l", labor[j], ".gif")
#                 , fps = fps)
#         end
# end
#




fps = 1.5
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]
#ps3 = [p_arr[i, 1, 3] p_arr[i, 2, 3] p_arr[i, 3, 3]]
l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="R", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(0:0.04:.4)), title ="B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

# l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
# Plots.GridLayout(1, 3)
# set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
# legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
# string.(-1:0.2:1)), title ="B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
# plot(set1, set2, size = (1000, 550), left_margin = 30px, bottom_margin = 10px, top_margin = 20px, right_margin = 10px,
#  layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",  
xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b;c{.05h}]
Plots.GridLayout(4, 1)
plot(set1, set2, test, size = (1000, 700), left_margin = 30px, bottom_margin = 20px, right_margin = 10px, top_margin = 20px,
 layout = l)
end
gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\cov_base_high.gif"), fps = fps)












 #  using Distributed
 #  addprocs(25)
 #  @everywhere using(Distributions)
 #  @everywhere using(DataFrames)
 #  @everywhere using(JLD2)
 #  @everywhere using(Random)
 #  @everywhere using(Dates)
 #
 #  @everywhere cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm")
 #  @everywhere include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\setup_utilies.jl")
 #  @everywhere include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_rewrite.jl")
 #
 #
 #
 #  S =expand_grid( [300],           #Population Size
 #                  [2],             #ngroups
 #                  [[1, 2]],        #lattice, will be replaced below
 #                  [0.0001],        #travel cost
 #                  [1],             #tech
 #                  [.9],      #labor
 #                  [0.1],           #limit seed values
 #                  [.00015],         #Punish Cost
 #                  [15000],         #max forest
 #                  [0.001,.9],      #experiment leakage
 #                  [0.5],           #experiment punish
 #                  [1],             #experiment_group
 #                  [1],             #groups_sampled
 #                  [1],          #Defensibility
 #                  [1],             #var forest
 #                  10 .^(collect(range(-2, stop = 1, length = 10))),          #price
 #                  [.025],        #regrowth
 #                  [[1, 1]], #degrade
 #                  10 .^(collect(range(-4, stop = 0, length = 10)))       #wages
 #                  )
 #
 #  #set up a smaller call function that allows for only a sub-set of pars to be manipulated
 #  @everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
 #      cpr_abm(nrounds = 500,
 #              nsim = 5,
 #              fine_start = nothing,
 #              leak = false,
 #              experiment_effort = 1,
 #              pun1_on = false,
 #              pun2_on = true,
 #              n = n,
 #              ngroups = ng,
 #              lattice = l,
 #              travel_cost = tc,
 #              tech = te,
 #              labor = la,
 #              harvest_limit = ls,
 #              punish_cost = pc,
 #              max_forest = mf,
 #              experiment_leak = el,
 #              experiment_punish1 = ep,
 #              experiment_punish2 = ep,
 #              experiment_group = eg,
 #              groups_sampled =gs,
 #              defensibility = df,
 #              var_forest = vf,
 #              price = pr,
 #              regrow = rg,
 #              degrade=dg,
 #              wages = wg
 #              )
 #  end
 #
 #
 #  abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 #   S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 #   S[:,16], S[:,17], S[:,18], S[:,19])
 #
 #  @JLD2.save("test.jld2", abm_dat, S)
 #
 # @JLD2.load("test.jld2")
#
# using Plots.PlotMeasures
#
# p_arr = Plots.Plot{Plots.GRBackend}[]
# resize!(p_arr, 3)
#
# elast=[.1, .5.9]
# for j in 1:length(elast)
#
#
#         yt = [["Low", "High"], ["", ""], ["", ""]]
#
#         l=findall(x->x==0.001, S[:,10])
#         h=findall(x->x==0.9, S[:,10])
#         #Choose Labor Elasticity
#         q=findall(x->x==elast[j], S[:,6])
#         v=findall(x->x==1, S[:,14])
#         l=l[l.∈ Ref(q)]
#         l=l[l.∈ Ref(v)]
#         h=h[h.∈ Ref(q)]
#         h=h[h.∈ Ref(v)]
#         low = abm_dat[l]
#         high =abm_dat[h]
#         m = zeros(10,10)
#
#         for i = 1:length(high)
#             m[i]  = nanmean(mean(high[i][:limit][:,2,:], dims =2)- mean(low[i][:limit][:,2,:], dims = 2))[1]
#             end
#         using Plots
#         gr()
#          p_arr[j]=p1=heatmap(m,
#             c=:temperaturemap, clim= (-.1, .1), xlab = " ", ylab= " ",
#              yguidefontsize=9,  xguidefontsize=9, legend = true,
#                xticks = ([2,19],[" "," "]), yticks = ([2,19],yt[j])
#             )
#         title!(string("Labor = ", elast[j]), titlefontsize = 9)
#         if j == 1 ylabel!("Price",  yguidefontsize=9) end
# end
# ps = [p_arr[1] p_arr[2] p_arr[3]]
#
#
# l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
# Plots.GridLayout(1, 3)
#
# eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
# legend=:none, xticks=:none, c=:temperaturemap, yticks=(1:10:101,
# string.(-1:0.2:1)), title ="Cor[E, L]", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
#
# plot(eff, size = (1000, 400), left_margin = 20px, bottom_margin = 20px)
#
#
# p_arr = Plots.Plot{Plots.GRBackend}[]
# resize!(p_arr, 3)
# ##########################
#
# elast=[.1, .5, .9]
# for j in 1:length(elast)
#
#
#         yt = [["Low", "High"], ["", ""], ["", ""]]
#
#         l=findall(x->x==0.001, S[:,10])
#         h=findall(x->x==0.9, S[:,10])
#         #Choose Labor Elasticity
#         q=findall(x->x==elast[j], S[:,6])
#         v=findall(x->x==1, S[:,14])
#         l=l[l.∈ Ref(q)]
#         l=l[l.∈ Ref(v)]
#         h=h[h.∈ Ref(q)]
#         h=h[h.∈ Ref(v)]
#         low = abm_dat[l]
#         high =abm_dat[h]
#         m = zeros(20,20)
#
#         for i = 1:length(high)
#             m[i]  = nanmean(mean(low[i]["clp2"][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
#             end
#         using Plots
#         gr()
#          p_arr[j]=p1=heatmap(m,
#             c=:diverging_cwm_80_100_c22_n256, clim= (-1, 1), xlab = "Wages", ylab= " ",
#              yguidefontsize=9,  xguidefontsize=9, legend = false,
#                xticks = ([2,19],["Low","High"]), yticks = ([2,19],yt[j])
#             )
#         title!(string(" "), titlefontsize = 9)
#         if j == 1 ylabel!("Price",  yguidefontsize=9) end
# end
# ps = [p_arr[1] p_arr[2] p_arr[3]]
#
#
# l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
# Plots.GridLayout(1, 3)
#
# eff2 = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
# legend=:none, xticks=:none, c=:diverging_cwm_80_100_c22_n256, yticks=(1:10:101,
# string.(-1:0.2:1)), title ="\\Delta Cor[R, L]", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
#
# plot(eff, eff2, size = (1000, 600), left_margin = 20px, bottom_margin = 20px, right_margin = 10px, layout = (2,1))
#
# png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish_cov.png")
#
#
#
#
# ###################################################################
# ############## CORRELATION BETWEEN BELIEFS AND P2 #################
#
#
#
#
# elast=[.1, .5, .9]
# for j in 1:length(elast)
#
#
#         yt = [["Low", "High"], ["", ""], ["", ""]]
#
#         l=findall(x->x==0.001, S[:,10])
#         h=findall(x->x==0.9, S[:,10])
#         #Choose Labor Elasticity
#         q=findall(x->x==elast[j], S[:,6])
#         v=findall(x->x==1, S[:,14])
#         l=l[l.∈ Ref(q)]
#         l=l[l.∈ Ref(v)]
#         h=h[h.∈ Ref(q)]
#         h=h[h.∈ Ref(v)]
#         low = abm_dat[l]
#         high =abm_dat[h]
#         m = zeros(20,20)
#
#         for i = 1:length(high)
#             m[i]  = nanmean(mean(high[i]["clp2"][:,2,:], dims =2)-mean(low[i]["clp2"][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
#             end
#         using Plots
#         gr()
#          p_arr[j]=p1=heatmap(m,
#             c=:diverging_cwm_80_100_c22_n256, clim= (-1, 1), xlab = "Wages", ylab= " ",
#              yguidefontsize=9,  xguidefontsize=9, legend = false,
#                xticks = ([2,19],["Low","High"]), yticks = ([2,19],yt[j])
#             )
#         title!(string(" "), titlefontsize = 9)
#         if j == 1 ylabel!("Price",  yguidefontsize=9) end
# end
# ps = [p_arr[1] p_arr[2] p_arr[3]]
#
#
# l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
# Plots.GridLayout(1, 3)
#
# eff2 = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
# legend=:none, xticks=:none, c=:diverging_cwm_80_100_c22_n256, yticks=(1:10:101,
# string.(-1:0.2:1)), title ="\\Delta Cor[R, L]", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
#
# plot(eff2, size = (1000, 333), left_margin = 20px, bottom_margin = 20px, right_margin = 10px)
#
#
#
# png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\fig_cov_SI.png")
