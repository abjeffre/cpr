

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
resize!(p_arr, length(tech)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(tech), length(labor), length(pars))
cols = [:RdBu_9]

for r in 1:length(pars)
    for j in 1:length(tech)
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
                                m[i]  = mean(mean(low[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
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
                                
                                p_arr[j,k,r]= plot(set1..., heatmap((0:0.01:1).*ones(101,1),
                                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                                string.(0:0.1:1)), title ="\n \n \n Effort ", titlefont = 8), layout=l, 
                                size = (800, 340), bottom_margin = 20px, left_margin = 20px)
    
                end
        end
    end

    p1
    png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort_low_base.png")

    p2
    png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort_high_base.png")

    plot(p_arr[1,1,1])
    png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort_base.png")





    using Plots.PlotMeasures
    using Statistics
    using JLD2
    using Plots
    using ColorSchemes
    @JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none_crash_tech.jld2")
    
    
    labor = unique(S[:,6])
    tech = unique(S[:,5])
    pars = [:effort]
    p_arr = Plots.Plot{Plots.GRBackend}[]
    resize!(p_arr, length(tech)*length(labor)*length(pars))
    p_arr=reshape(p_arr, length(tech), length(labor), length(pars))
    cols = [:RdBu_9]
    
    for r in 1:length(pars)
        for j in 1:length(tech)
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
                             p_arr[j,k,r]=p1=heatmap(m,
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
        end
    
        plot(p_arr[1,1,1])
        png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort_pred_example.png")
    
    



        
    for r in 1:length(pars)
        for j in 1:length(tech)
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
                             p_arr[j,k,r]=p1=heatmap(m,
                                 c=cols[r],
                                 clim= ifelse(r==3, (-.1,.1), (-1,1)),
                                 xlab = "Wages",
                                 ylab = ifelse(k == 1, "Price", " "),
                                 yguidefontsize=9,
                                 xguidefontsize=9,
                                 legend = false,
                                 xticks = ([2,19], ("Low", "High")),
                                 yticks = ifelse(k == 1, ([2,19], ("Low", "High")), ([2,19], (" ", " "))),
                                 title = string("\n \n Labor Elasticity = :", round(labor[k], digits = 5)),
                                 titlefontsize = 9,
                                 top_margin = 20px,
                                 right_margin = 20px)
        
                    end
            end
        end
        fps = 1.5
        anim = @animate for i = 1:7
        #Define line settings
        l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
        Plots.GridLayout(1, 2)
        set1=plot(p_arr[i, :, 1]..., heatmap((0:0.01:1).*ones(101,1),
        legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
        string.(0:0.1:1)), title ="\n \n \n \\Delta Effort ", titlefont = 8), layout=l, 
        size = (1000, 300), bottom_margin = 20px, left_margin = 20px)
       
        test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, 
        xlabel = "Tech (TFP)",
        xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), 
        yticks = ([10], ("")),  size = (1000, 100))
    
                            
        l = @layout[a;b{.05h}]
        Plots.GridLayout(2, 1)
        plot(set1, test, size = (1000, 330), left_margin = 20px, bottom_margin = 20px,
         right_margin = 20px, layout = l)
        end


        gif(anim, string("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort_tech.gif")
        , fps = fps)
















    @JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")
r=1
j = 1
k = 3
labor = unique(S[:,6])

    l=findall(x->x==0.001, S[:,10])
    h=findall(x->x==0.9, S[:,10])
    q=findall(x->x==labor[k], S[:,6])
    l=l[l.∈ Ref(q)]
    h=h[h.∈ Ref(q)]
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
            
            p_arr[j,k,r]= plot(set1..., heatmap((0:0.01:1).*ones(101,1),
            legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
            string.(0:0.1:1)), title ="\n \n \n Effort ", titlefont = 8), layout=l, 
            size = (800, 340), bottom_margin = 20px, left_margin = 20px)


            plot(high[85][:effort][:,2,1], ylim = (0, 1), color = "goldenrod" , labels = ("high leakage"),
            xlabel = :Time, ylabel = :Effort)
            plot!(high[85][:effort][:,2,2:5], ylim = (0, 1), color = "goldenrod" , labels = false)
            plot!(low[84][:effort][:,2,1], ylim = (0, 1), color = "turquoise" , labels = ("low leakage"))
            plot!(low[84][:effort][:,2,2:5], ylim = (0, 1), color = "turquoise" , labels = false)

            png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort_example.png")

