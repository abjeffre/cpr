######################################
############# PLOTTING ###############
using Plots
using Plots.PlotMeasures
include("C:/Users/jeffr/Documents/Work/cpr/code/analyitic/analyitic.jl")
######################################
######### IF LEAKAGE RATE IS FIXED ###
c = .002
p =.5
q = 0.0044
# Revenue
s, h, r0, rt =profitMax(full_output = true, q =q, c =c,  p =p, T = 2000, e₂ = .00)
fixed_leakage=plot(h*p, ylim = (0, .002), ylab = "Total revenue", xlab = "Harvest effort",
 axis = nothing, left_margin = 10mm, c = :black, label = "")
plot!(c*collect(0:.01:1), label = "")
oae=[getOAE(h,p,c)]
#annotate!(oae[1] - 1, (h*p)[oae][1] + .0001, text("OAE₁", :black, :right, 8))

vline!([oae], c = :black, l = :dash, label = "")

s, h, r0, rt =profitMax(full_output = true, q =q, c =c,  p =p, T = 2000, e₂ = .02)
plot!(h*p, ylim = (0, .002), c = :grey, label = "")
oae=[getOAE(h,p,c)]
#annotate!(oae[1] - 1, (h*p)[oae][1] + .0001, text("OAE₂", :grey, :right, 8))
vline!([oae], c = :grey, l = :dash, label = "")

# # Profits
# # Marignal costs
# c2 = collect(0:.01:1).*c
# s, h, r0, rt =profitMax(full_output = true, q =q, c =c,  p =p, T = 2000, e₂ = .00)
# p1=(h*p)-c2
# vline!([findmax(p1)[2]])
# #plot!(p1, ylab = "total revenue", xlab = "total harvest effort", axis = nothing, left_margin = 10mm)
# s, h, r0, rt =profitMax(full_output = true, q =q, c =c,  p =p, T = 2000, e₂ = .02)
# p2=(h*p)-c2
# vline!([findmax(p2)[2]])
# #plot!(p2, ylim = (0, .002))



###########################################
############ PRODUCTION CONSTRAINT ########

c = .001
p =.5
q = 0.003
# Revenue
s, h, r0, rt =profitMax(full_output = true, q =q, c =c,  p =p, T = 2000, e₂ = .00)
production_constraint=plot(h*p, ylim = (0, .002), ylab = " ", xlab = "Harvest effort",
 axis = nothing, left_margin = 10mm, c = :black, label = "")
plot!(c*collect(0:.01:1), label = "")
oae=[getOAE(h,p,c)]
# annotate!(oae[1] - 1, (h*p)[oae][1] + .0001, text("OAE₁", :black, :right, 8))
# vline!([oae], c = :black, l = :dash, label = "")

s, h, r0, rt =profitMax(full_output = true, q =q, c =c,  p =p, T = 2000, e₂ = .3)
plot!(h*p, ylim = (0, .002), c = :grey, label = "")
oae=[getOAE(h,p,c)]
# annotate!(oae[1] - 1, (h*p)[oae][1] + .0001, text("OAE₂", :grey, :right, 8))
vline!([oae], c = :grey, l = :dash, label = "")

###############################
#### DIFFERENT COSTS ##########
c = .002
p =.5
q = 0.0044
# Revenue
s, h, r0, rt =profitMax(full_output = true, q =q, c =c,  p =p, T = 2000, e₂ = .00)
diffrent_costs=plot(h*p, ylim = (0, .002), ylab = " ", xlab = "Harvest effort",
 axis = nothing, left_margin = 10mm, c = :black, label = "")
plot!(c*collect(0:.01:1), label = "")
oae=[getOAE(h,p,c)]
# annotate!(oae[1] - 1, (h*p)[oae][1] + .0001, text("OAE₁", :black, :right, 8))
vline!([oae], c = :black, l = :dash, label = "")

c = .001
plot!((c*collect(0:.01:1)), label = "", c=:red, l = :dash)
oae=[getOAE(h,p,c)]
# annotate!(oae[1] - 1.5, (h*p)[oae][1] + .0001, text("OAE₂", :red, :right, 8))
vline!([oae], c = :grey, l = :dash, label = "")
