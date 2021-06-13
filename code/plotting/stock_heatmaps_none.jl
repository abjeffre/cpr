

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")


#####################################################
###########LOW LABOR ################################



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

#price is on the y axis and wage is on the x

using Plots
gr()
 p1=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )




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
    m[i]  = mean(mean(low[i]["stock"][:,2,:], dims =2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
 pl1=heatmap( m,
    c=:thermal, clim= (0, 1)
    )




low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
 ph1=heatmap(m,
    c=:thermal, clim= (0, 1)
    )



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
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
p2=heatmap(m,
    c=:thermal, clim= (-.8, .8)
    )




l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["stock"][:,2,:], dims =2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
 pl2=heatmap( m,
    c=:thermal, clim= (0, 1)
    )




low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
 ph2=heatmap(m,
    c=:thermal, clim= (0, 1)
    )





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
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2) - mean(low[i]["stock"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
p3=heatmap( m,
    c=:thermal, clim= (-.8, .8)
    )




l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(low[i]["stock"][:,2,:], dims =2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
 pl3=heatmap( m,
    c=:thermal, clim= (0, 1)
    )




low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["stock"][:,2,:], dims =2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
 ph3=heatmap( m,
    c=:thermal, clim= (0, 1)
    )



plot(pl1, ph1, p1,
pl2, ph2, p2,
pl3, ph3, p3,
layout =grid(3,3)
)
