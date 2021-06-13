

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")


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

using Plots
gr()
p1=heatmap(m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.9",aspect_ratio=:equal, clims = (-.8, .8))

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leak.jld2")

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

using Plots
gr()
p2=heatmap(m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.9",aspect_ratio=:equal, clims = (-.8, .8))




@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leakp1.jld2")

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

using Plots
gr()
p3=heatmap(m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.9",aspect_ratio=:equal, clims = (-.8, .8))






@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leakp1p2.jld2")

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

using Plots
gr()
p4=heatmap(m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.9",aspect_ratio=:equal, clims = (-.8, .8))

plot(p1, p2, p3, p4)
