
####################################
############ P1 ####################
using Plots.PlotMeasures
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_pun_hm_p1.jld2")

###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end
using Plots
gr()
 p1=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "Prices",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["",""]), yticks = ([2,19],["Low","High"])
    )
title!("Labor = 0.1", titlefontsize = 9)
#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
p2=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
     xticks = ([2,19],["",""]), yticks = ([2,19],["",""])
    )
title!("Labor = 0.5", titlefontsize = 9)

###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
p3=heatmap( m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,  xticks = ([2,19],
     ["",""]), yticks = ([2,19],["",""])
    )
title!("Labor = 0.9", titlefontsize = 9)




###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end
using Plots
gr()
 plp11=heatmap(m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wages", ylab= "Prices",
     yguidefontsize=9, xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["Low","High"])
    )

    title!(" ", titlefontsize = 9)




#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
plp12=heatmap(m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wages", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,
      xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
        title!(" ", titlefontsize = 9)




###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
plp13=heatmap( m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wage", ylab= "",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
    title!(" ", titlefontsize = 9)




ps = [p1 p2 p3]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly



ps = [plp11 plp12 plp13]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

pun = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), c=:Spectral_8, title ="\\Delta X", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly

plot(eff, pun, layout=grid(2,1))

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish_nl_df1.png")



################################DF 3 #########################################


###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end
using Plots
gr()
 p1=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "Prices",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["",""]), yticks = ([2,19],["Low","High"])
    )
title!("Labor = 0.1", titlefontsize = 9)
#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
p2=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
     xticks = ([2,19],["",""]), yticks = ([2,19],["",""])
    )
title!("Labor = 0.5", titlefontsize = 9)

###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
p3=heatmap( m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,  xticks = ([2,19],
     ["",""]), yticks = ([2,19],["",""])
    )
title!("Labor = 0.9", titlefontsize = 9)




###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end
using Plots
gr()
 plp11=heatmap(m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wages", ylab= "Prices",
     yguidefontsize=9, xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["Low","High"])
    )

    title!(" ", titlefontsize = 9)




#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
plp12=heatmap(m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wages", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,
      xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
        title!(" ", titlefontsize = 9)




###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
plp13=heatmap( m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wage", ylab= "",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
    title!(" ", titlefontsize = 9)




ps = [p1 p2 p3]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly



ps = [plp11 plp12 plp13]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

pun = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), c=:Spectral_8, title ="\\Delta X", titlefont = 9), layout=l) # Plot them set y values of or bar accordingly

plot(eff, pun, layout=grid(2,1))

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish_nl_df3.png")




###############################################################################
###################### PUNISHMENT WITH LEAKAGE ###############################
high[1]["leakage"]



@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_pun_hm_leakp1.jld2")

###LOW LABOR ####

###LOW LABOR ####

###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end
using Plots
gr()
 p1=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "Prices",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["",""]), yticks = ([2,19],["Low","High"])
    )
title!("Labor = 0.1", titlefontsize = 9)
#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
p2=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
     xticks = ([2,19],["",""]), yticks = ([2,19],["",""])
    )
title!("Labor = 0.5", titlefontsize = 9)

###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
p3=heatmap( m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,  xticks = ([2,19],
     ["",""]), yticks = ([2,19],["",""])
    )
title!("Labor = 0.9", titlefontsize = 9)




###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end
using Plots
gr()
 plp11=heatmap(m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wages", ylab= "Prices",
     yguidefontsize=9, xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["Low","High"])
    )

    title!(" ", titlefontsize = 9)




#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
plp12=heatmap(m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wages", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,
      xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
        title!(" ", titlefontsize = 9)




###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
plp13=heatmap( m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wage", ylab= "",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
    title!(" ", titlefontsize = 9)




ps = [p1 p2 p3]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly



ps = [plp11 plp12 plp13]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

pun = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), c=:Spectral_8, title ="\\Delta X", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly

plot(eff, pun, layout=grid(2,1))

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish_l_df1.png")


####################################### DF 3######################

###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end
using Plots
gr()
 p1=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "Prices",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["",""]), yticks = ([2,19],["Low","High"])
    )
title!("Labor = 0.1", titlefontsize = 9)
#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
p2=heatmap(m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "",
    yguidefontsize=9,  xguidefontsize=9, legend = false,
     xticks = ([2,19],["",""]), yticks = ([2,19],["",""])
    )
title!("Labor = 0.5", titlefontsize = 9)

###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
p3=heatmap( m,
    c=:thermal, clim= (-1, 1), xlab = "", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,  xticks = ([2,19],
     ["",""]), yticks = ([2,19],["",""])
    )
title!("Labor = 0.9", titlefontsize = 9)




###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end
using Plots
gr()
 plp11=heatmap(m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wages", ylab= "Prices",
     yguidefontsize=9, xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["Low","High"])
    )

    title!(" ", titlefontsize = 9)




#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
plp12=heatmap(m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wages", ylab= "",
     yguidefontsize=9, xguidefontsize=9, legend = false,
      xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
        title!(" ", titlefontsize = 9)




###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])
l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]

low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish"][:,2,:], dims =2) - mean(low[i]["punish"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
plp13=heatmap( m,
    c=:Spectral_8, clim= (-1, 1), xlab = "Wage", ylab= "",
     yguidefontsize=9,  xguidefontsize=9, legend = false,
       xticks = ([2,19],["Low","High"]), yticks = ([2,19],["",""])
    )
    title!(" ", titlefontsize = 9)




ps = [p1 p2 p3]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta E", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly



ps = [plp11 plp12 plp13]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

pun = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, yticks=(1:10:101,
string.(-1:0.2:1)), c=:Spectral_8, title ="\\Delta X", titlefont = 9), layout=l) # Plot them set y values of color bar accordingly

plot(eff, pun, layout=grid(2,1))

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish_l_df3.png")
