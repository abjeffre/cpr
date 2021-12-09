using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
@JLD2.load("cpr\\data\\leak_travel.jld2")


travelcost = unique(S[:,4])
sort!(travelcost)
labor = unique(S[:,6])
sort!(travelcost)


pars = [:effort,:leakage]
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
                    w = findall(x->x==false, S[:,20])
                    l=l[l.∈ Ref(v)]
                    l=l[l.∈ Ref(q)]
                    l=l[l.∈ Ref(w)]
                    h=h[h.∈ Ref(v)]
                    h=h[h.∈ Ref(q)]
                    h=h[h.∈ Ref(w)]
                    low = abm_dat[l]
                    high =abm_dat[h]
                    means = zeros(500, 400)
                    for sim in 1:400
                        means[:,sim] = mean(high[sim][:effort][1:500,2,1:5], dims =2)
                    end

                    means2 = mean(means, dims = 1)

                    a=findall(x->x .>= .975, means2)
                    temp1=zeros(length(a))
                    for i in 1:length(a) temp1[i]= a[i][2] end
                    b=findall(x->x .<= .025, means2)
                    temp2=zeros(length(b))
                    for i in 1:length(b) temp2[i]= b[i][2] end

                    ex=[temp1; temp2]
                    dat=collect(1:400)
                    use=dat[dat .∉ Ref(ex)]

                    highs_tl = zeros(500, length(use))
                    highs_stock = zeros(500, length(use))
                    for i in 1:length(use)
                        highs_tl[:,i] = mean(high[use[i]][pars[r]][1:500,2,1:5], dims =2)
                        highs_stock[:,i] = mean(high[use[i]][:stock][1:500,2,1:5], dims =2)
                    end

                    lows_tl = zeros(500, length(use))
                    lows_stock = zeros(500, length(use))
                    for i in 1:length(use)
                        lows_tl[:,i] = mean(low[use[i]][pars[r]][1:500,2,1:5], dims =2)
                        lows_stock[:,i] = mean(low[use[i]][:stock][1:500,2,1:5], dims =2)
                    end
                    
                    plot(mean(highs_tl, dims = 2), label = "leakage", ylim = (0, 1), 
                    ylabel = ifelse(k==1, pars[r], ""),
                    xlabel = "time")
                    plot!(mean(lows_stock, dims=2), color = :green1, label = "low stock")
                    plot!(mean(highs_stock, dims=2), color = :green2, label = "high stock")
                    p_arr[j,k,r]=p1=plot!(mean(lows_tl, dims = 2), label = "no leakage")

                    #  p1=heatmap(m,
                    #      clim= ifelse(r==3, (-.1,.1), (-1,1)),
                    #      xlab = ifelse(r==2, "Wages", " "),
                    #      ylab = ifelse(k==1, "Price", " "),
                    #      yguidefontsize=9,
                    #      xguidefontsize=9,
                    #      legend = false,
                    #      #xticks = ([2,19], ifelse(r == 2, ("Low", "High"), (" ", " "))),
                    #      #yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                    #      title = ifelse(r==1, string("Labor: ", labor[k]), " "),
                    #      titlefontsize = 9)
            end
    end
end




fps = 2
anim = @animate for i = 1:10
#Define line settings
ps1 = [p_arr[i, 1, 1] p_arr[i, 2, 1] p_arr[i, 3, 1]]
ps2 = [p_arr[i, 1, 2] p_arr[i, 2, 2] p_arr[i, 3, 2]]

Plots.GridLayout(3, 1)
set1=plot(ps1..., layout = (1,3), size = (1000, 300))
Plots.GridLayout(3, 1)
set2=plot(ps2..., layout = (1,3), size = (1000, 300))
test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Travel Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)
l = @layout[a;b;c{.05h}]
Plots.GridLayout(3, 1)
plot(set1, set2, test, size = (1000, 750), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
 layout = l)
end


gif(anim, string("cpr\\output\\ts_test.gif"), fps = fps)
