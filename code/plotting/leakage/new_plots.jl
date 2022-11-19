using Plots
using Pkg
using LaTeXStrings
using Plots.PlotMeasures

function grow(b, r, k)
    (r*b)*(1-(b/k))
end

newGrowth=[grow(i, .02, 1)/i for i in 0:.01:1]

# New growth
a=plot([grow(i, .02, 1) for i in 0:.01:1], ylim = (-.01, .01), xlab = "population", ylab = "growth")

# Harvest at MSY
change=plot([grow(i, .02, 1)-.005 for i in 0:.01:1], ylim = (-.01, .01), xlab = "population", ylab = "growth")

# BASE PLOT
without_leakage=plot([grow(i, .02, 1) for i in 0:.01:1], xlab = "", label = "", c=:black, axis=nothing, left_margin = 5mm, title = "No leakge", titlefontsize = 8)
Plots.abline!(.000022, 0, xlab = "", ylab = "Profit (ℜ)", label = "") #, ylim = (0, .006))
vspan!([30, 90], linecolor = :grey, fillcolor = :grey, alpha = .5, label = "")
vline!([45], c=:gray, l=:dash, label = "")
vline!([50, 50], c=:gray, l=:dash, label = "")
annotate!(46, .004, text("MEY", :black, :left, 8))
annotate!(51, .0035, text("MSY", :black, :left, 8))
annotate!(90, .0025, text("GBE", :black, :left, 8))
annotate!(95, .001, text("Total Revenue", :black, :right, 8))


# SOME LEAKAGE
with_Some_leakage=plot([grow(i, .02, 1) for i in 0:.01:1], xlab = "", label = "", c=:black, axis=nothing, left_margin = 5mm, title = "Some leakge", titlefontsize = 8)
Plots.abline!(.000022, 0, xlab = "", ylab = "", label = "") #, ylim = (0, .006))
vspan!([30, 60], linecolor = :grey, fillcolor = :orange, alpha = .5, label = "")
vspan!([60, 90], linecolor = :grey, fillcolor = :grey, alpha = .5, label = "")
vline!([45], c=:gray, l=:dash, label = "")
vline!([50, 50], c=:gray, l=:dash, label = "")
annotate!(46, .004, text("MEY", :black, :left, 8))
annotate!(51, .0035, text("MSY", :black, :left, 8))
annotate!(90, .0025, text("GBE", :black, :left, 8))
annotate!(95, .001, text("Total Revenue", :black, :right, 8))

# MAX LEAKAGE
MAX_LEAKAGE=plot([grow(i, .02, 1) for i in 0:.01:1], xlab = "Harvest Effort", label = "", c=:black, axis=nothing, left_margin = 5mm, title = "Max leakage", titlefontsize = 8)
Plots.abline!(.000022, 0, xlab = "Harvest Effort (E)", ylab = "Profit (ℜ)", label = "") #, ylim = (0, .006))
vspan!([30, 90], linecolor = :grey, fillcolor = :orange, alpha = .5, label = "")
vline!([45], c=:gray, l=:dash, label = "")
vline!([50, 50], c=:gray, l=:dash, label = "")
annotate!(46, .004, text("MEY", :black, :left, 8))
annotate!(51, .0035, text("MSY", :black, :left, 8))
annotate!(90, .0025, text("GBE", :black, :left, 8))
annotate!(95, .001, text("Total Revenue", :black, :right, 8))


# SHOW
lower_costs=plot([grow(i, .02, 1) for i in 0:.01:1], xlab = "Harvest Effort", label = "", c=:black, axis=nothing, left_margin = 5mm, title = "Different costs", titlefontsize = 8)
Plots.abline!(.000015, 0, xlab = "Harvest Effort (E)", ylab = "", label = "", l = :dash) #, ylim = (0, .006))
Plots.abline!(.000022, 0, xlab = "Harvest Effort (E)", ylab = "", label = "", c = :red) #, ylim = (0, .006))
vspan!([30, 90], linecolor = :grey, fillcolor = :orange, alpha = .5, label = "")
vspan!([90, 93], linecolor = :grey, fillcolor = :red, alpha = .5, label = "")
vline!([45], c=:gray, l=:dash, label = "")
vline!([50, 50], c=:gray, l=:dash, label = "")
annotate!(46, .004, text("MEY", :black, :left, 8))
annotate!(51, .0035, text("MSY", :black, :left, 8))
annotate!(95, .0022, text("GBE₁", :black, :right, 8))
annotate!(105.5, .0017, text("GBE₂", :black, :right, 8))
annotate!(95, .001, text("Total Revenue", :black, :right, 8))

plot(without_leakage, with_Some_leakage, MAX_LEAKAGE, lower_costs)

#########################################################################
################ LEAKAGE ################################################

# Secondary Leakage Focal
c = .0008
leakage_self=plot([grow(i, .02, 1) for i in 0:.01:1], xlab = "Harvest Effort", label = "", c=:black, left_margin = 10mm, axis = nothing, title = "Local", titlefontsize = 8) #axis=nothing
Plots.abline!(.000022, c, xlab = "Total Harvest Effort (E)", ylab = "Profit (ℜ)", label = "", l = :dash, alpha = .3) #, ylim = (0, .006))
Plots.abline!(.000022, 0, xlab = "Total Harvest Effort (E)", ylab = "Profit (ℜ)", label = "", c = :red) #, ylim = (0, .006))
vspan!([80, 90], linecolor = :grey, fillcolor = :grey, alpha = .5, label = "")
vspan!([30, 80], linecolor = :orange, fillcolor = :orange, alpha = .5, label = "")
# vline!([45], c=:gray, l=:dash, label = "", alpha = .5)
# vline!([50, 50], c=:gray, l=:dash, label = "", alpha = .5)
# annotate!(43, .004, text("MEY", :grey, :left, 8, alpha = .5))
# annotate!(51, .004, text("MSY", :grey, :left, 8, alpha = .5))
# annotate!(90, .0025, text("GBE", :black, :right, 8))
# annotate!(95, .001, text("Total Revenue", :black, :right, 8))
x = [80, 80 ]
y = [.0018, 0.0030]
plot!(x,y, arrow=(:closed, 2.0), c = :black, label = "")
plot!(reverse(x),reverse(y), arrow=(:closed, 2.0), c = :black, label = "") 
annotate!(76, .00250, text(latexstring("ph_{L|L}"), :right, :black, 10))

x = [40, 40 ]
y = [.0018, 0.0047]
plot!(x,y, arrow=(:closed, 2.0), c = :black, alpha = .3, label = "")
plot!(reverse(x),reverse(y), arrow=(:closed, 2.0), c = :grey, alpha = .3, label = "") 
annotate!(65, .0035, text(latexstring("ph_{L|N} - c_t"), :right, :grey, 10), alpha = .5)

x = [40, 40 ]
y = [.0010, 0.0017]
plot!(x,y, arrow=(:closed, 2.0), c = :grey, label = "", alpha= .5)
plot!(reverse(x),reverse(y), arrow=(:closed, 2.0), c = :grey, label = "", alpha= .5) 
annotate!(48, .0015, text(latexstring("c_t"), :right, :grey, 10), alpha = .5)




# Secondary Neighboor Community

leakage_other=plot([grow(i, .02, 1) for i in 0:.01:1], xlab = "Harvest Effort", label = "", c=:black, left_margin = 10mm, axis=nothing, title = "Neighboor", titlefontsize = 8)
Plots.abline!(.000022, c, xlab = "Total Harvest Effort (E)", ylab = "Profit (ℜ)", label = "", l = :dash) #, ylim = (0, .006))
Plots.abline!(.000022, 0, xlab = "Total Harvest Effort (E)", ylab = "Profit (ℜ)", label = "", c = :red, alpha = .3) #, ylim = (0, .006))
vspan!([40, 90], linecolor = :grey, fillcolor = :grey, alpha = .5, label = "")
#vline!([45], c=:gray, l=:dash, label = "", alpha = .5)
#vline!([50, 50], c=:gray, l=:dash, label = "", alpha = .5)
#annotate!(43, .004, text("MEY", :grey, :left, 8, alpha = .5))
#annotate!(51, .004, text("MSY", :grey, :left, 8, alpha = .5))
#annotate!(90, .0025, text("GBE", :black, :right, 8))
annotate!(95, .001, text("Total Revenue", :black, :right, 8))
annotate!(65, .0035, text(latexstring("ph_{L|N} - c_t"), :right, :black, 10))
annotate!(48, .0015, text(latexstring("c_t"), :right, :black, 10))

x = [80, 80 ]
y = [.0018, 0.0030]
plot!(x,y, arrow=(:closed, 2.0), c = :grey, label = "", alpha = .5)
plot!(reverse(x),reverse(y), arrow=(:closed, 2.0), c = :grey, label = "", alpha = .5) 
annotate!(76, .00250, text(latexstring("ph_{L|L}"), :right, :grey, 10), alpha = .5)

x = [40, 40 ]
y = [.0018, 0.0047]
plot!(x,y, arrow=(:closed, 2.0), c = :black, label = "")
plot!(reverse(x),reverse(y), arrow=(:closed, 2.0), c = :black, label = "") 

x = [40, 40 ]
y = [.0010, 0.0017]
plot!(x,y, arrow=(:closed, 2.0), c = :black, label = "")
plot!(reverse(x),reverse(y), arrow=(:closed, 2.0), c = :black, label = "") 



plot(leakage_self, leakage_other , size =(800, 300), bottom_margin = 7mm)

