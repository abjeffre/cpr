using Plots.PlotMeasures
using Statistics
using JLD2
using Plots

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leakcont.jld2")

travelcost = unique(S[:,4])
sort!(travelcost)
labor = unique(S[:,6])
sort!(travelcost)


pars = ["effort", "leakage"]
cols = [:RdBu_6, cgrad(:roma, rev = false)]

p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(travelcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(travelcost), length(labor), length(pars))

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(travelcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==travelcost[j], S[:,4])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2)-mean(low[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                            c=cols[r], clim= (-1, 1), xlab = "Wages", ylab= "Price",
                             yguidefontsize=9,  xguidefontsize=9, legend = true,
                               xticks = ([2,19],["Low","High"]), yticks = ([2,19], ["Low","High"]),
                               title = string("Cost = :", round(travelcost[j], digits = 5)), titlefontsize = 9)
                end
        end
end
for  r in 1:length(pars)
        for j in 1:length(labor)
                fps = 3
                anim = @animate for i = 1:10
                #Define line settings
                plot(p_arr[i, j, r])
                end
                gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_tc_", pars[r], "l", labor[j], ".gif")
                , fps = fps)
        end
end


##############
##FULL PLOT##
#############

travelcost = unique(S[:,4])
sort!(travelcost)
labor = unique(S[:,6])
sort!(travelcost)


p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(travelcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(travelcost), length(labor), length(pars))


pars = ["effort", "leakage"]
cols = [:RdBu_9, cgrad(:roma, rev = false)]
xt = [[[" "  " "], [" " " "], [" " " "]],
                [["Low" "High"], ["Low" "High"], ["Low" "High"]]]


yt = [[["Low" "High"], [" "  " "], [" " " "]], [["Low" "High"], [" "  " "], [" " " "]]]

xl  = [[[" "  " "], [" " " "], [" " " "]],
                ["Wage", "Wages", "Wages"]]
yl = [["Price" "Price"], [" "  " "], [" " " "]]

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(travelcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==travelcost[j], S[:,4])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2)-mean(low[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                            c=cols[r], clim= (-1, 1),
                             xlab = xl[r][k], ylab= yl[k],
                             yguidefontsize=9,  xguidefontsize=9, legend = false,
                               xticks = ([2,19],xt[r][k]), yticks = ([2,19], yt[r][k]),
                               title = string("Cost = :", round(travelcost[j], digits = 5)), titlefontsize = 9)
                end
        end
end


fps = 3
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]
l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta L", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 20px, to_margin = 20px, right_margin = 10px,
 layout = (2,1))
end
gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_tc.gif")
, fps = fps)

+

####################################################################################
#################### PLOTTING BASE TRAITS ##########################################




travelcost = unique(S[:,4])
labor = unique(S[:,6])
sort!(travelcost)


p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(travelcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(travelcost), length(labor), length(pars))

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(travelcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==travelcost[j], S[:,4])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                            c=:diverging_cwm_80_100_c22_n256, clim= (0, 1), xlab = "Wages", ylab= "Price",
                             yguidefontsize=9,  xguidefontsize=9, legend = true,
                               xticks = ([2,19],["Low","High"]), yticks = ([2,19], ["Low","High"]),
                               title = string("Cost = :", round(travelcost[j], digits = 5)), titlefontsize = 9)
                end
        end
end
for  r in 1:length(pars)
        for j in 1:length(labor)
                fps = 3
                anim = @animate for i = 1:10
                #Define line settings
                plot(p_arr[i, j, r])
                end
                gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\tc_base", pars[r], "l", labor[j], ".gif")
                , fps = fps)
        end
end