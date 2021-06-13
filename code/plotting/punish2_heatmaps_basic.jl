
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_pun_hm_p1p2.jld2")



###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl1=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl3=heatmap(m,
    c=:thermal, clim= (0, 1)
    )



###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph1=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph2=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph3=heatmap(m,
    c=:thermal, clim= (0, 1)
    )



plot(pl1, pl2, pl3, ph1, ph2, ph3)







###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 pl1=heatmap(m,
    c=:thermal, clim= (.05, .2)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (.05, .2)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 pl3=heatmap(m,
    c=:thermal, clim= (.05, .2)
    )



###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 ph1=heatmap(m,
    c=:thermal, clim= (.05, .2)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 ph2=heatmap(m,
    c=:thermal, clim= (.05, .2)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 ph3=heatmap(m,
    c=:thermal, clim= (.05, .2)
    )



plot(pl1, pl2, pl3, ph1, ph2, ph3)




############################################################################
######################## EFFORT ############################################






###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 pl1=heatmap(m,
    c=:thermal, clim= (0, .3)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (0, .3)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 pl3=heatmap(m,
    c=:thermal, clim= (0, .3)
    )



###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 ph1=heatmap(m,
    c=:thermal, clim= (0, .3)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 ph2=heatmap(m,
    c=:thermal, clim= (0, .3)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==1, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 ph3=heatmap(m,
    c=:thermal, clim= (0, .3)
    )



plot(pl1, pl2, pl3, ph1, ph2, ph3)



###############################################################################
########################## DF 3 ###############################################





###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl1=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 pl3=heatmap(m,
    c=:thermal, clim= (0, 1)
    )



###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph1=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph2=heatmap(m,
    c=:thermal, clim= (0, 1)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["punish2"][:,2,:], dims =2))
    end
using Plots
gr()
 ph3=heatmap(m,
    c=:thermal, clim= (0, 1)
    )



plot(pl1, pl2, pl3, ph1, ph2, ph3)







###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 pl1=heatmap(m,
    c=:thermal,  clim= (.05, .20)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (0.05, .2)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 pl3=heatmap(m,
    c=:thermal, clim= (.05, .20)
    )



###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 ph1=heatmap(m,
    c=:thermal,  clim= (.05, .20)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 ph2=heatmap(m,
    c=:thermal,  clim= (.05, .20)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["limit"][:,2,:], dims =2))
    end
using Plots
gr()
 ph3=heatmap(m,
    c=:thermal, clim= (.05, .20)
    )



plot(pl1, pl2, pl3, ph1, ph2, ph3)




############################################################################
######################## EFFORT ############################################






###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 pl1=heatmap(m,
    c=:thermal, clim= (0, .3)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 pl2=heatmap(m,
    c=:thermal, clim= (0, .3)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 pl3=heatmap(m,
    c=:thermal, clim= (0, .3)
    )



###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 ph1=heatmap(m,
    c=:thermal, clim= (0, .3)
    )

#####Mid LABOR ######
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 ph2=heatmap(m,
    c=:thermal, clim= (0, .3)
    )

###High LABOR ###
l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
v=findall(x->x==3, S[:,14])

l=l[l.∈ Ref(v)]
h=h[h.∈ Ref(v)]
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2))
    end
using Plots
gr()
 ph3=heatmap(m,
    c=:thermal, clim= (0, .3)
    )



plot(pl1, pl2, pl3, ph1, ph2, ph3)
