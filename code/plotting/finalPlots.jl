using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes

#@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abmDatLabor.jld2")
@JLD2.load("cpr\\data\\abm\\abmDatLabor.jld2")


labor = unique(S[:,6])
pars = [:effort]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(labor)*length(pars))
p_arr=reshape(p_arr, length(labor), length(pars))
cols = [:RdBu_9, :PuOr9]

for r in 1:length(pars)
    for k in 1:length(labor)
                    l=findall(x->x==0.0001, S[:,10])
                    h=findall(x->x==0.9, S[:,10])
                    q=findall(x->x==labor[k], S[:,6])
                    l=l[l.∈ Ref(q)]
                    h=h[h.∈ Ref(q)]
                    low = abm_dat[l]
                    high =abm_dat[h]
                    m = zeros(20,20)
                    for i = 1:length(high)
                        m[i]  = mean(mean(high[i][pars[r]][100:end,2,:], dims =2)-mean(low[i][pars[r]][100:end,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                    end
                    using Plots
                    gr()
                        p_arr[k,r]=p1=heatmap(m,
                            c=cols[r],
                            clim= ifelse(r==3, (-.1,.1), (-1,1)),
                            xlab = "Wages",
                            ylab = ifelse(k == 3, "Price", " "),
                            yguidefontsize=9,
                            xguidefontsize=9,
                            legend = false,
                            xticks = ([2,19], ("Low", "High")),
                            yticks = ifelse(k==3, ([2,19], ("Low", "High")), ([2,19], (" ", " "))),
                            title = string("Lab Elast = ", round(labor[k], digits = 4)),
                            #legendtitle = "Δ E",
                            titlefontsize = 9,
                            top_margin = 30px,
                            right_margin = 20px,
                            bottom_margin = 30px)
                            #annotate!([23.5], [22.5], text("Δ E", :black, :right, 9))
            end
    end

ps1 = [p_arr[3, 1] p_arr[6, 1] p_arr[9, 1, 1]]

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., size = (1000, 300),heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 20px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly



png("cpr\\output\\lab.png")


###############################################
########## LEAKAGE ############################



@JLD2.load("cpr\\data\\abm\\abmDatLeak.jld2")

travelcost = unique(S[:,4])
sort!(travelcost)
labor = unique(S[:,6])
sort!(travelcost)


pars = [:effort, :leakage]
cols = [:RdBu_6, cgrad(:roma, rev = false)]

p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(travelcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(travelcost), length(labor), length(pars))

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(travelcost)
                        l=findall(x->x==0.0001, S[:,10])
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
                            m[i]  = mean(mean(high[i][pars[r]][100:end,2,:], dims =2)-mean(low[i][pars[r]][100:end,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-.1,.1), (-1,1)),
                             xlab = ifelse(r==2, "Wages", " "),
                             ylab = ifelse(j==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 2, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==1, string("Travel Cost: ", round(travelcost[j], digits = 3)), " "),
                             titlefontsize = 9)
                end
        end
end


ps1 = [p_arr[1, 1, 1] p_arr[7, 1, 1] p_arr[10, 1, 1]]
ps2 = [p_arr[1, 1, 2] p_arr[7, 1, 2] p_arr[10, 1, 2]]

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta T", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b]
Plots.GridLayout(3, 1)
plot(set1, set2, size = (1000, 600), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
 layout = l)

 

 png("cpr\\output\\leak.png")

 ##################################################################################
 ################ PUNISH 1 ########################################################

@JLD2.load("cpr\\data\\abm\\abmDatP1.jld2")

punishcost = unique(S[:,8])
sort!(punishcost)
labor = unique(S[:,6])
sort!(punishcost)
cols = [:RdBu_9, :lighttemperaturemap]

pars = [:effort, :punish]


p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.000, S[:,10])
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
                            m[i]  = mean(mean(high[i][pars[r]][100:end,2,:], dims =2)-mean(low[i][pars[r]][100:end,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-.1,.1), (-1,1)),
                             xlab = ifelse(r==2, "Wages", " "),
                             ylab = ifelse(j==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 2, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==1, string("Punish Cost: ", round(punishcost[j], digits = 3)), " "),
                             titlefontsize = 9)
                end
        end
end


ps1 = [p_arr[1, 1, 1] p_arr[6, 1, 1] p_arr[10, 1, 1]]
ps2 = [p_arr[1, 1, 2] p_arr[6, 1, 2] p_arr[10, 1, 2]]

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

plot(set1, set2, size = (1000, 550), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (2,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b]
Plots.GridLayout(3, 1)
plot(set1, set2, size = (1000, 600), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
 layout = l)


 png("cpr\\output\\pun1.png")


 
 ##################################################################################
 ################ PUNISH 2 ########################################################

@JLD2.load("cpr\\data\\abm\\abmDatP2.jld2")

punishcost = unique(S[:,8])
sort!(punishcost)
labor = unique(S[:,6])
sort!(punishcost)


pars = [:effort, :punish2, :limit]
cols = [:RdBu_9, cgrad(:PuOr_9, rev = false), :PiYG_9]

p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))

for r in 1:length(pars)
    println(r)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.000, S[:,10])
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
                            m[i]  = mean(mean(high[i][pars[r]][100:end,2,:], dims =2)-mean(low[i][pars[r]][100:end,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-2,2), (-1,1)),
                             xlab = ifelse(r==2, "Wages", " "),
                             ylab = ifelse(j==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 2, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==1, string("Punish Cost: ", round(punishcost[j], digits = 3)), " "),
                             titlefontsize = 9)
                end
        end
end


ps1 = [p_arr[1, 1, 1] p_arr[7, 1, 1] p_arr[10, 1, 1]]
ps2 = [p_arr[1, 1, 2] p_arr[7, 1, 2] p_arr[10, 1, 2]]
ps3 = [p_arr[1, 1, 3] p_arr[7, 1, 3] p_arr[10, 1, 3]]

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

l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly



plot(set1, set2, set3, size = (1000, 825), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
 layout = (3,1))

test=bar([i], xlim = (0,10), orientation = :horizontal, label = false, xlabel = "Insitutional Costs",     xguidefontsize=9, bottom_margin = 20px, xticks = ([0, 10], ("Low", "High")), yticks = ([10], ("")),  size = (1000, 100))
vline!([10], label = false)


l = @layout[a;b;c]
Plots.GridLayout(3, 1)
plot(set1, set2, set3, size = (1000, 900), left_margin = 20px, bottom_margin = 20px, right_margin = 10px,
 layout = l)



 png("cpr\\output\\pun2.png")


###############################################################
########################## COVARIANCE ##########################

punishcost = unique(S[:,8])
labor = unique(S[:,6])
sort!(punishcost)


pars = [:cel, :clp2]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(punishcost)*length(labor)*length(pars))
p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))
cols = [:RdBu_9, :PiYG_9]

for r in 1:length(pars)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                        l=findall(x->x==0.00, S[:,10])
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
                            m[i]  = nanmean(mean(low[i][pars[r]][:,2,:], dims =2))[1]#-mean(low[i][pars[r]][:,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                            end
                        using Plots
                        gr()
                         p_arr[j,k,r]=p1=heatmap(m,
                             c=cols[r],
                             clim= ifelse(r==3, (-.1,.1), (-.5,.5)),
                             xlab = ifelse(k==1, "Wages", " "),
                             ylab = ifelse(j==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(k == 1, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(j == 1, ("Low", "High"), (" ", " "))),
                             title = string("Pun cost = :", round(punishcost[j], digits = 5)), titlefontsize = 9)
                end
        end
end

ps2 = [p_arr[1, 1, 2] p_arr[7, 1, 2] p_arr[10, 1, 2]]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)
set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1), size = (1000, 300),
legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
string.(-.5:0.1:.5)), title ="Cov(R, B)", titlefont = 8), left_margin = 20px, bottom_margin = 20px,  right_margin = 10px, top_margin = 20px, layout=l) # Plot them set y values of color bar accordingly






 ################################################################
 ################### FULL #######################################

 ### Run on server


 @JLD2.load("abmDatFull.jld2")

 punishcost = unique(S[:,8])
 sort!(punishcost)
 labor = unique(S[:,6])
 sort!(punishcost)
 pars = [:effort, :leakage, :punish, :punish2, :limit]

 m_arr = []
 resize!(m_arr, length(punishcost)*length(labor)*length(pars))
 m_arr=reshape(m_arr, length(punishcost), length(labor), length(pars))
 


 for r in 1:length(pars)
     println(r)
         for k in 1:length(labor)
                 for j in 1:length(punishcost)
                         l=findall(x->x==0.0001, S[:,10])
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
                             m[i]  = mean(mean(high[i][pars[r]][100:end,2:end,:], dims =2)-mean(low[i][pars[r]][100:end,2:end,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                        end
                          m_arr[j,k,r]=m
                 end
         end
 end
 
  
 @JLD2.save("m_arr.jld2", m_arr, S)

###### On Local Machine 

 @JLD2.load("cpr\\data\\abm\\m_arr.jld2")

 
 punishcost = unique(S[:,8])
 sort!(punishcost)
 labor = unique(S[:,6])
 sort!(punishcost)
 pars = [:effort, :leakage, :punish, :punish2, :limit]

 p_arr = Plots.Plot{Plots.GRBackend}[]
 resize!(p_arr, length(punishcost)*length(labor)*length(pars))
 p_arr=reshape(p_arr, length(punishcost), length(labor), length(pars))
 cols = [:RdBu_9, cgrad(:roma, rev = true),  :lighttemperaturemap, cgrad(:PuOr_9, rev = false), :PiYG_9]


 for r in 1:length(pars)
    println(r)
        for k in 1:length(labor)
                for j in 1:length(punishcost)
                         p_arr[j,k,r]=p1=heatmap(m_arr[j,k,r],
                             c=cols[r],
                             clim= ifelse(r==5, (-.5,.5), (-.5,.5)),
                             xlab = ifelse(r==2, "Wages", " "),
                             ylab = ifelse(j==1, "Price", " "),
                             yguidefontsize=9,
                             xguidefontsize=9,
                             legend = false,
                             xticks = ([2,19], ifelse(r == 5, ("Low", "High"), (" ", " "))),
                             yticks = ([2,19], ifelse(j == 1, ("Low", "High"), (" ", " "))),
                             title = ifelse(r==1, string("Punish Cost: ", round(punishcost[j], digits = 3)), " "),
                             titlefontsize = 9)
                end
        end
end

 ps1 = [p_arr[1, 1, 1] p_arr[3, 1, 1] p_arr[6, 1, 1]]
 ps2 = [p_arr[1, 1, 2] p_arr[3, 1, 2] p_arr[6, 1, 2]]
 ps3 = [p_arr[1, 1, 3] p_arr[3, 1, 3] p_arr[6, 1, 3]]
 ps4 = [p_arr[1, 1, 4] p_arr[3, 1, 4] p_arr[6, 1, 4]]
 ps5 = [p_arr[1, 1, 5] p_arr[3, 1, 5] p_arr[6, 1, 5]]
 

 l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
 Plots.GridLayout(1, 3)
 set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
 legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
 string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly
 
 
 l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
 Plots.GridLayout(1, 3)
 set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
 legend=:none, xticks=:none, c=cols[2], yticks=(1:10:101,
 string.(-1:0.2:1)), title ="\\Delta T", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
 
 l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
 Plots.GridLayout(1, 3)
 set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
 legend=:none, xticks=:none, c=cols[3], yticks=(1:10:101,
 string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
 
 l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
 Plots.GridLayout(1, 3)
 set4 = plot(ps4..., heatmap((0:0.01:1).*ones(101,1),
 legend=:none, xticks=:none, c=cols[4], yticks=(1:10:101,
 string.(-1:0.2:1)), title ="\\Delta R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
 
 l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
 Plots.GridLayout(1, 3)
 set5 = plot(ps5..., heatmap((0:0.01:1).*ones(101,1),
 legend=:none, xticks=:none, c=cols[5], yticks=(1:10:101,
 string.(-1:0.2:1)), title ="\\Delta B", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
 
 
 plot(set1, set2, set3, set4, set5, size = (1000, 1400), left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
  layout = (5,1))
 
 
