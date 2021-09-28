using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
@JLD2.load("cpr\\data\\leak_pun2.jld2")

punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)


pars = [:effort, :punish2, :limit]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))
cols = [:RdBu_9, cgrad(:PuOr_9, rev = false), :PiYG_9]

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==punishcost[j], S[:,8])
                        w = findall(x->x==true, S[:,20])
                        l=l[l.∈ Ref(v)]
                        l=l[l.∈ Ref(q)]
                        l=l[l.∈ Ref(w)]
                        h=h[h.∈ Ref(v)]
                        h=h[h.∈ Ref(q)]
                        h=h[h.∈ Ref(w)]
                        low = abm_dat[l]
                        high =abm_dat[h]
                        m = zeros(20,20)
                        for i = 1:length(high)
                            m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2)-mean(low[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-.1,.1), (-1,1)),
                             xlab = ifelse(r==3, "Wages", " "),
                             ylab = ifelse(k==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 3, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==1, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end

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





fps = 1
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
string.(-1:0.2:1)), title ="\\Delta B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b;c;d{.05h}]
Plots.GridLayout(4, 1)
plot(set1, set2, set3, test, size = (1000, 900), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
 layout = l)
end
gif(anim, string("cpr\\output\\pred_pc2.gif")
, fps = fps)





####################################################################################
#################### PLOTTING BASE TRAITS ##########################################




punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)


pars = [:effort, :punish2, :limit]

p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))

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
                            m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (0,.3), (-1,1)),
                             xlab = ifelse(r==3, "Wages", " "),
                             ylab = ifelse(k==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 3, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==1, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end


fps = 2
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]
ps3 = [p_arr[i, 1, 3] p_arr[i, 2, 3] p_arr[i, 3, 3]]
l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
string.(0:0.1:1)), title ="P", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b;c;d{.05h}]
Plots.GridLayout(4, 1)
plot(set1, set2, set3, test, size = (1000, 900), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
 layout = l)
end
gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_p2base_high.gif")
, fps = fps)






punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)


pars = [:effort, :punish2]

p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))

pars = [:effort, :punish2, :limit]

p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))

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
                            m[i]  = mean(mean(high[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (0,.3), (-1,1)),
                             xlab = ifelse(r==3, "Wages", " "),
                             ylab = ifelse(k==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 3, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==1, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end


fps = 2
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]
ps3 = [p_arr[i, 1, 3] p_arr[i, 2, 3] p_arr[i, 3, 3]]
l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
string.(0:0.1:1)), title ="P", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b;c;d{.05h}]
Plots.GridLayout(4, 1)
plot(set1, set2, set3, test, size = (1000, 900), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
 layout = l)
end
gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\pred_p2base_low.gif")
, fps = fps)
