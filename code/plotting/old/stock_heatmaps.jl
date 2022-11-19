
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")

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
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end
using Plots
gr()
 pn1=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )

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
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
pn2=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )

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
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
pn3=heatmap( m,
    c=:thermal, clim= (-.8, .8)
    )



####################################
############ LEAKAGE ###############

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leak.jld2")

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
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
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
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
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
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
pl3=heatmap( m,
    c=:thermal, clim= (-.8, .8)
    )




####################################
############ P1 ####################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leakp1.jld2")

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
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
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
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
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
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
plp13=heatmap( m,
    c=:thermal, clim= (-.8, .8)
    )





####################################
############ P2 ####################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leakp1p2.jld2")

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
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
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
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
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
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
plp1p23=heatmap( m,
    c=:thermal, clim= (-.8, .8)
    )




plot(pn1, pn2, pn3,
pl1, pl2, pl3,
plp11, plp12, plp13,
plp1p21, plp1p22, plp1p23,
layout = grid(4, 3))
