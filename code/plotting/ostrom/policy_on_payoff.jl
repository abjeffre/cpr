#####################################################################################
############################## Policy on Payoffs ####################################

# Load 
dat = deserialize("cpr\\data\\abm\\regulation.dat")


y1 = [mean(mean(dat[i][:payoffR][900:1000,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y1).+(collect(0.1:.05:1).*0.1) # adjust for institutional costs
μ = mean(a, dims = 2)
a=reduce(vcat, y1)
a=reduce(vcat, a)


y2 = [mean(mean(dat[i][:limit][900:1000,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a2=reduce(vcat, y2)
μ = mean(a2, dims = 2)
a2=reduce(vcat, y2)
a2=reduce(vcat, a2)


y3 = [mean(mean(dat[i][:punish2][900:1000,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a3=reduce(vcat, y3)
μ = mean(a3, dims = 2)
a3=reduce(vcat, y3)
a3=reduce(vcat, a3)

a3 = ifelse.(a3 .> .4, :red, :black)

Covariance=scatter(a2[a3 .== :red], a[a3 .== :red], c=:orange, label = false, xlab = "MAH", xticks = (0, " "),  
ylab = "Payoffs", labels = "Enforced", alpha = .5, markerstrokecolor = :orange,
title = "(l)", titlelocation = :left, titlefontsize = 15)
scatter!(a2[a3 .== :black], a[a3 .== :black], c=:black, label = false, xlab = "MAH",  
ylab = "Payoffs", labels = ("Not Enforced"), alpha = .5)
vline!([3.5, 3.5], c=:red, label = "MSY")

