using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
@JLD2.load("cpr\\data\\leak_tech.jld2")


labor = unique(S[:,6])
tech = unique(S[:,5])
pars = [:effort]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(tech)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(tech), length(labor), length(pars))
cols = [:RdBu_9, :lighttemperaturemap]

for r in 1:length(pars)
    for k in 1:length(labor)
            for j in 1:length(tech)
                    l=findall(x->x==0.001, S[:,10])
                    h=findall(x->x==0.9, S[:,10])
                    q=findall(x->x==labor[k], S[:,6])
                    v=findall(x->x==tech[j], S[:,5])
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
                         xlab = ifelse(r==2, "Wages", " "),
                         ylab = ifelse(k==1, "Price", " "),
                         yguidefontsize=9,
                         xguidefontsize=9,
                         legend = false,
                         xticks = ([2,19], ifelse(r == 2, ("Low", "High"), (" ", " "))),
                         yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                         title = ifelse(r==1, string("Labor: ", labor[k]), " "),
                         titlefontsize = 9)
            end
    end
end

fps = 1.5
anim = @animate for i = 1:9
    #Define line settings
    ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
    l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
    Plots.GridLayout(1, 3)
    set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
    legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
    string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly
    test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
    vline!([10], label = false)
    l = @layout[a;b{.05h}]
    Plots.GridLayout(2, 1)
    plot(set1, test, size = (1000, 400), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
    layout = l)
end

gif(anim, string("cpr\\output\\tech_gif.gif"), fps = fps)
