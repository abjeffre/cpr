include("cpr/code/abm/ABC_processing.jl")
using LaTeXStrings
using Plots.PlotMeasures



# Plot 
regrowth=density(S[best,1], xlab = "r", label = nothing, yaxis = nothing, ylab = "Density");
density!(S[:,1],label = nothing);
vline!([median(S[best,1])], l = :dash, c = :red, label = nothing)
value =density(S[best,2], xlab = "ι", label = nothing, yaxis = nothing);
density!(S[:,2], label = nothing) ;
vline!([median(S[best,2])], l = :dash, c = :red, label = nothing)
travel_cost=density(S[best,3], xlab = "cₜ", label = nothing, yaxis = nothing, ylab = "Density");
density!(S[:,3], label = nothing);
vline!([median(S[best,3])], l = :dash, c = :red, label = nothing)
wage = density(S[best,4], alpha = 1, xlab = "w", label = nothing, yaxis = nothing) ;
density!(S[:,4], alpha  = 1,  label = nothing);
vline!([median(S[best,4])], l = :dash, c = :red, label = nothing)

Plots.plot(regrowth, value, travel_cost, wage, left_margin = 15px)
savefig("cpr/Plots/ABC_densities.pdf")

# GET 3d PLOTS
frontrank =zeros(nsample);
fronts=nds4(output)
for i in 1:length(fronts)
    frontrank[fronts[i]] .= i
end

df=DataFrame(output, :auto)
rename!(df, "x1" => :effort, "x2" => :stock, "x3" => :deforest)
df.rank = frontrank
df.rankbin = ifelse.(frontrank.==1, 1, 2)
df.effort=1 .-normalize(df.effort)
df.stock=1 .-normalize(df.stock)
df.deforest=1 .-normalize(df.deforest)
df.rankbin = ifelse.(frontrank.==1, :red, :blue)
df.opacity = ifelse.(frontrank.==1, 1, .1)

plot(df.effort, df.stock, df.deforest, seriestype = "scatter", label = nothing, camera = (50, 30), c = df.rankbin, alpha = df.opacity, ylab = "KL Stock", xlab = "KL effort", zlab = "KL Deforestatio Rate")

savefig("cpr/Plots/ABC_NDS.pdf")



