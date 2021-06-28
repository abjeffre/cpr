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
                             ylab = "Price",
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = true,
                             xticks = ([2,19], ("Low", "High")),
                             yticks = ([2,19], ("Low", "High")),
                             title = string("Δ Effort \n \n Labor Elasticity = :", round(labor[k], digits = 5)),
                             titlefontsize = 9,
                             top_margin = 20px,
                             right_margin = 20px)
                end
        end

                fps = 1.5
                anim = @animate for i = 1:10
                #Define line settings
                  
                    test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, 
                        xlabel = "Labor Elasticity",
                        xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), 
                        yticks = ([10], ("")),  size = (1000, 100))
                    
                    l = @layout[a;b{.05h}]
                    Plots.GridLayout(2, 1)
                    plot(p_arr[i, 1], test, size = (400, 400), left_margin = 20px, bottom_margin = 20px,
                     right_margin = 20px, layout = l)
                end
                gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\test2.gif")
                , fps = fps)
