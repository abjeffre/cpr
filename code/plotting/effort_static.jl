using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")


labor = unique(S[:,6])
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
                        l=l[l.∈ Ref(q)]
                        h=h[h.∈ Ref(q)]
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
                             ylab = ifelse(k == 1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ("Low", "High")),
                             yticks = ([2,19], ("Low", "High")),
                             title = string("Lab Elast = :", round(labor[k], digits = 3)),
                             #legendtitle = "Δ E",
                             titlefontsize = 9)
                            # top_margin = 30px,
                             #right_margin = 20px)
                             #annotate!([23.5], [22.5], text("Δ E", :black, :right, 9))
                end
        end

fps = 1.5
#Define line settings

Plots.GridLayout(1, 3)
ps1 = [p_arr[1, 1] p_arr[8, 1] p_arr[10, 1]]
l = @layout[grid(1,3) a{0.05w}] 
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), 
layout=l, left_margin = 20px, bottom_margin = 10px,
 top_margin = 10px, right_margin = 10px, size = (1000, 250)) # Plot them set y values of color bar accordingly

png(string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\laborElast.png"))
