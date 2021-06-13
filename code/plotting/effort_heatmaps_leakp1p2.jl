

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_leakp1p2.jld2")


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
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
 p1=heatmap(m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.1",  clims = (-.8,.8))


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

#price is on the y axis and wage is on the x

using Plots
gr()
p2=heatmap( m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.5", clims = (-.8,.8))




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



#price is on the y axis and wage is on the x

using Plots
gr()
p3=heatmap(m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.9", aspect_ratio=:equal, clims = (-.8,.8))


mean(low[18]["limit"][:,2,:], dims =2)
