############################################
######### Credit Base Plots ################
using Plots.PlotMeasures
frequency = 20
sample_rate = 2500
x = range(0, stop = 1, step = 1/sample_rate)
y = sin.(2π * x * frequency)
y = (y.+1)*.5
y1=ifelse.(y .< mean(y), mean(y), y)
y2=y.+(mean(y1).-mean(y))
mean(y2)
a1=plot(x, y, lw = 1, ylim = (0, 1.5), label = "", c= :black, ylab = "Non-forest Income", labelfontsize = 9, title = "No Smoothing", titlefontsize = 10, axis = nothing)
plot!(x, fill(mean(y), length(collect(x))), lw = 1, ylim = (0, 1.5), label = "", c= :red)

a2=plot(x, y1, lw = 1, ylim = (0, 1.5),label = "", c= :black, title = "Smoothing ", titlefontsize = 10, axis = nothing)
plot!(x, fill(mean(y1), length(collect(x))), lw = 1, ylim = (0, 1.5), label = "", c= :red)

a3=plot(x, y2, lw = 1, ylim = (0, 1.5), label = "", c= :black)
plot!(x, fill(mean(y2), length(collect(x))), lw = 1, ylim = (0, 1.5), label = "", c= :red)

a = cpr_abm(tech =.2,wage_data = y, nrounds =sample_rate, max_forest = 1000000, degrade = .2, pun1_on = false, pun2_on = false, leak = false)
b = cpr_abm(tech =.2,wage_data=y1, nrounds =sample_rate, max_forest = 1000000, degrade = .2, pun1_on = false, pun2_on = false, leak = false)
c = cpr_abm(tech =.2,wage_data=y2, nrounds =sample_rate, max_forest = 1000000, degrade = .2, pun1_on = false, pun2_on = false, leak = false)

b1=plot(a[:stock][:,1,1], ylim = (0, 1), c = :darkgreen, label = "", ylabel = "Forest Stock", labelfontsize = 9, axis = nothing, xlab = "Time")
b2=plot(b[:stock][:,1,1], ylim = (0, 1), c = :darkgreen, label = "", axis = nothing, xlab = "Time", labelfontsize = 9,)
b3=plot(c[:stock][:,1,1], ylim = (0, 1), c = :darkgreen, label = "")

plot(a1, a2, b1, b2, layout = grid(2, 2), left_margin = 15px, bottom_margin = 15px)

savefig("credit_smoothing_model.png")