
abm_dat <- nothing
@JLD2.load("cpr\\data\\leak_all5.jld2")

punishcost = unique(S[:,8])
labor = .1
sort!(punishcost)


pars = [:effort, :leakage, :punish, :punish2, :limit]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*3*length(pars))
p_arr=reshape(p_arr, length(punishcost), 3, length(pars))
punishcost = unique(S[:,8])
cols = [:RdBu_9, cgrad(:roma, rev = true),  :lighttemperaturemap, cgrad(:PuOr_9, rev = false), :PiYG_9]

labor = .5

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.001, S[:,10])
                        h=findall(x->x==0.9, S[:,10])
                        q=findall(x->x==labor[k], S[:,6])
                        v=findall(x->x==punishcost[j], S[:,8])
                        w = findall(x->x==false, S[:,20])
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
                            m[i]  = mean(mean(high[i][pars[r]][:,2:12,:], dims =2)-mean(low[i][pars[r]][:,2:12,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,2,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==5, (-.1,.1), (-1,1)),
                             xlab = ifelse(r==5, "Wages", " "),
                             ylab = ifelse(k==1, " ", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 5, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, (" ", " "), (" ", " "))),
                             title = ifelse(r==1, string("Labor: ", labor[k]), " "),
                             titlefontsize = 9)
                end
        end
end

@JLD2.save("p_arr.jld2", p_arr)

@JLD2.load("cpr\\data\\p_arr.jld2")



fps = 2
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 2, 1]]
ps2 = [p_arr[i, 2, 2]]
ps3 = [p_arr[i, 2, 3]]
ps4 = [p_arr[i, 2, 4]]
ps5 = [p_arr[i, 2, 5]]
l = @layout[grid(1,1) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1,1)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,1) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1,1)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta L", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

l = @layout[grid(1,1) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1,1)
set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

 l = @layout[grid(1,1) a{0.05w}] # Stack a layout that rightmost one is for color bar
 Plots.GridLayout(1,1)
 set4 = plot(ps4..., heatmap((0:0.01:1).*ones(101,1),
 legend=:none, xticks=:none, c=cols[4], yticks=(1:10:101,
 string.(-1:0.2:1)), title ="\\Delta R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
 

  l = @layout[grid(1,1) a{0.05w}] # Stack a layout that rightmost one is for color bar
  Plots.GridLayout(1,1)
  set5 = plot(ps5..., heatmap((0:0.01:1).*ones(101,1),
  legend=:none, xticks=:none, c=cols[5], yticks=(1:10:101,
  string.(-1:0.2:1)), title ="\\Delta B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
  
test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b;c;d;e;f{.05h}]
Plots.GridLayout(6, 1)
plot(set1, set2, set3, set4, set5, test, size = (1000, 1500), left_margin = 42px, bottom_margin = 20px, right_margin = 10px,
 layout = l)
end
gif(anim, string("cpr\\output\\pred_full_nc.gif")
, fps = fps)

