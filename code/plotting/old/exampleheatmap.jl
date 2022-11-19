
using(JLD2)
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")

###LOW LABOR ####


l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.31, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]
low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i][:effort][:,2,:], dims =2) - mean(low[i][:effort][:,2,:], dims = 2))
    end
using Plots
gr()
 pn1=heatmap(-m,clim= (-.6, .6), xticks = ([2,19], ("Low", "High")), xaxis = false, yaxis = false,
    yticks = ([2,19], ("Low", "High")), size = (450, 380), c = :PuOr_7, xlab = "Wage", ylab = "Price"
    )
png("cpr/output/exampleheatmap.png")
