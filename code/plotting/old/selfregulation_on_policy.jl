###################################################################
############# SELF REGULATION ON POLICY ###########################

# Load 
dat = deserialize("cpr\\data\\abm\\regulation.dat")



y1 = [mean(mean(dat[i][:punish2][490:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y1[1:19])
μ = mean(a, dims = 2)
a=reduce(vcat, y1[1:19])
a=reduce(vcat, a)

y2 = [mean(mean(dat[i][:limit][490:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a2=reduce(vcat, y1[1:19])
μ = mean(a2, dims = 2)
a2=reduce(vcat, y2[1:19])
a2=reduce(vcat, a2)


Selection=scatter(a, a2, c=:black, ylim = (0, 6), label = false, xlab = "Support for Regulation", yticks = (0, " "), 
ylab = "MAY", alpha = .3,
title = "(g)", titlelocation = :left, titlefontsize = 15)
hline!([3.5], lw = 2, c=:red, label = "MSY", )

