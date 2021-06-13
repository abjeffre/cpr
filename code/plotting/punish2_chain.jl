
####################################
############ LEAKAGE ###############

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leak6.jld2")

###LOW LABOR ####



l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x== 0, S[:,4])

l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,2,:], dims =2) - mean(low[i]["punish2"][:,2,:], dims = 2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )





l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x== 0, S[:,4])

l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,3,:], dims =2) - mean(low[i]["punish2"][:,3,:], dims = 2))
    end
using Plots
gr()
 pl3=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )




l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x== 0, S[:,4])

l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,4,:], dims =2) - mean(low[i]["punish2"][:,4,:], dims = 2))
    end
using Plots
gr()
 pl4=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )




l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x== 0, S[:,4])

l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,5,:], dims =2) - mean(low[i]["punish2"][:,5,:], dims = 2))
    end
using Plots
gr()
 pl5=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )



l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x== 0, S[:,4])

l=l[l.∈ Ref(q)]
l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(q)]
h=h[h.∈ Ref(v)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,6,:], dims =2) - mean(low[i]["punish2"][:,6,:], dims = 2))
    end
using Plots
gr()
 pl6=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )


plot(pl2,pl3, pl4, pl5, pl6)
