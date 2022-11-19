

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_leakagefin.jld2")


#####################################################
###########LOW LABOR ################################
using(ColorSchemes)


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#Price is on the y axis and wage is on the x

using Plots
gr()

 p1=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab = "Price",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
    yticks = ([2,19],["Low","High"]),
    xticks = ([2,19],["",""]),
    )
title!("Labor = 0.1", titlefontsize = 9)


#####################################################
###########Mid LABOR ################################

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#Price is on the y axis and wage is on the x

using Plots
gr()
p2=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab = "",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
        yticks = ([2,19],["",""]),
        xticks = ([2,19],["",""]))
title!("Labor = 0.5", titlefontsize = 9)




#####################################################
###########High LABOR ################################

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end



#Price is on the y axis and wage is on the x

using Plots
gr()
p3=heatmap(m,
    c=:thermal,  clim= (-1, 1), xlab = "", ylab = "", yguidefontsize=9,
      xguidefontsize=9, legend = false,
          yticks = ([2,19],["",""]),
          xticks = ([2,19],["",""])
    )
    title!("Labor = 0.9", titlefontsize = 9)






####################################
############ LEAKAGE ###############

#@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leak.jld2")

###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["leakage"][:,2,:], dims =2) - mean(low[i]["leakage"][:,2,:], dims = 2))
    end
using Plots
gr()
 l1=heatmap(m,
    c=cgrad(:roma, rev = false), clim= (-1, 1), xlab = "Wages",
     ylab = "Price", yguidefontsize=9,  xguidefontsize=9, legend = false,
    yticks = ([2,19],["Low","High"]),
    xticks = ([2,19],["Low","High"])
    )
    title!(" ", titlefontsize = 9)


#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["leakage"][:,2,:], dims =2) - mean(low[i]["leakage"][:,2,:], dims = 2))
    end

#Price is on the y axis and wage is on the x

using Plots
gr()
l2=heatmap(m,
    c=cgrad(:roma, rev = false), clim= (-1, 1), xlab = "Wages", ylab = "",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
   yticks = ([2,19],["",""]),
   xticks = ([2,19],["Low","High"])
    )
    title!(" ", titlefontsize = 9)

###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["leakage"][:,2,:], dims =2) - mean(low[i]["leakage"][:,2,:], dims = 2))
    end



#Price is on the y axis and wage is on the x

using Plots
gr()
l3=heatmap( m,
    c=cgrad(:roma, rev = false), clim= (-1, 1), xlab = "Wages", ylab = "",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
    yticks = ([2,19],["",""]),
    xticks = ([2,19],["Low","High"])
    )
    title!(" ", titlefontsize = 9)


plot(p1, p2, p3, l1, l2,l3, layout = grid(2,3))



ps = [p1 p2 p3]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)),  title ="\\Delta E", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly



ps = [l1 l2 l3]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

pun = plot(ps..., heatmap((-1:0.02:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), c=:roma , title ="\\Delta L", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly

plot(eff, pun, layout=grid(2,1))

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\leakage.png")
