include("cpr/code/abm/ABC_processing.jl")
using LaTeXStrings
using Plots.PlotMeasures



# Plot 
regrowth=density(S[best,1], xlab = "r", label = nothing);
density!(S[:,1],label = nothing);
value =density(S[best,2], xlab = "ι", label = nothing);
density!(S[:,2], label = nothing) ;
travel_cost=density(S[best,3], xlab = "cₜ", label = nothing);
density!(S[:,3], label = nothing);
wage = density(S[:,4], alpha = 1, xlab = "w", label = nothing) ;
density!(S[best,4], alpha  = 1,  label = nothing);
Plots.plot(regrowth, value, travel_cost, wage)


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

# We dont want Ploty always active so we use this module
module plotting
    import df
    using PlotlyJS
    PlotlyJS.plot(df, x = :effort, y=:deforest, z =:stock, color = :rankbin,  type = "scatter3d", mode = "markers", alpha = .01)    
end


# for moving average
frontrank =zeros(nsample);
fronts=nds4(output_moving)
for i in 1:length(fronts)
    frontrank[fronts[i]] .= i
end

df=DataFrame(output_moving, :auto)
rename!(df, "x1" => :effort, "x2" => :stock, "x3" => :deforest)
df.rank = frontrank
df.rankbin = ifelse.((frontrank.==1) .| (frontrank.==2), 1, 2)
df.effort=1 .-normalize(df.effort)
df.stock=1 .-normalize(df.stock)
df.deforest=1 .-normalize(df.deforest)
module plotting2
    using PlotlyJS
    PlotlyJS.plot(df, x = :effort, y=:deforest, z =:stock, color = :rankbin,  type = "scatter3d", mode = "markers")
end





