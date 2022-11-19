
####################################
############ LEAKAGE ###############

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leak6.jld2")

###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x== 0, S[:,4])

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
 pl1=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )

#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x== 0, S[:,4])

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
pl2=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )

###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==00, S[:,4])

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
pl3=heatmap( m,
    c=:thermal, clim= (-.8, .8)
    )




####################################
############ P1 ####################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leakp16.jld2")

###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==00, S[:,4])

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
 plp11=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )

#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==00, S[:,4])

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
plp12=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )

###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==00, S[:,4])

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
plp13=heatmap( m,
    c=:thermal, clim= (-.8, .8)
    )





####################################
############ P2 ####################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leakp1p26.jld2")

###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==00, S[:,4])

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
 plp1p21=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )

#####Mid LABOR ######

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==00, S[:,4])

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
plp1p22=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )

###High LABOR ###

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==00, S[:,4])

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
plp1p23=heatmap( m,
    c=:thermal, clim= (-.8, .8)
    )




plot(pl1, pl2, pl3,
plp11, plp12, plp13,
plp1p21, plp1p22, plp1p23,
layout = grid(3, 3))
