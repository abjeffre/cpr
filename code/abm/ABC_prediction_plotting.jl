####################################################################
#################### ABC prediction Plotting #######################

# Load in data from prediction
# Identify most likley time step


# get average leakage into a group at each time step 
# Scatter that against effort
nsim = 100
output = ones(nsim, 400)
for k in 1:nsim 
    theft=[[mean(a[:loc][i,:,k].==j) for j in 1:24] for i in 1:400] 
    coefs = ones(400, 4)
    for i in 1:400
        df=DataFrame(:effort => Float64.(a[:effortfull][i, :, k]),
                :theft => theft[i][Int.(a[:gid][:,1])][:,1],
                :stock => LAND[Int.(a[:gid][:,1])][:,1],
                :pop => POP[:, 2][Int.(a[:gid][:,1])][:,1])
        fm = @formula(effort ~ theft + stock + pop) 
#       fm = @formula(effort ~ theft) 
        m1=lm(fm, df)
        typeof(m1)
        coefs[i,:]=coef(m1)
    end
    output[k,:] = coefs[:, 2]
end



effort_plot=plot(title = "Effort", titlefontsize = 8)
for i in 1:400
    scatter!(fill(i, nsim), output[:,i], color = :firebrick, alpha = .1, label = false)
end
plot!(mean(output, dims = 1)', lw = 2, c= :orange, label = false, xlab = "Time step", ylab = "Coefficent estimate")
hline!([0], c=:white, lw = 2, label = "")
vspan!(effort_plot, [hpdi_bounds], label = nothing, color = :grey, alpha = .3)


# Examine overall leakage 
nsim = 100
output = ones(nsim, 400)
for k in 1:nsim 
    theft=[[mean(a[:loc][i,:,k].==j) for j in 1:24] for i in 1:400] 
    coefs = ones(400, 4)
    for i in 1:400
        df=DataFrame(:leak => Float64.(a[:leakfull][i, :, k]),
                :theft => theft[i][Int.(a[:gid][:,1])][:,1],
                :stock => LAND[Int.(a[:gid][:,1])][:,1],
                :pop => POP[:, 2][Int.(a[:gid][:,1])][:,1])
        fm = @formula(leak ~ theft + stock + pop) 
        m1=lm(fm, df)
        typeof(m1)
        coefs[i,:]=coef(m1)
    end
    output[k,:] = coefs[:, 2]
end

leakage_plot=plot()
for i in 1:400
    scatter!(fill(i, nsim), output[:,i], color = :firebrick, alpha = .1, label = false)
end
plot!(mean(output, dims = 1)', lw = 2, c= :orange, label = false, xlab = "Time step", ylab = "", title = "Leakage", titlefontsize = 8)
hline!([0], c=:white, lw = 2, label = nothing)
vspan!(leakage_plot, [hpdi_bounds], label = nothing, color = :grey, alpha = .3)


plot(effort_plot, leakage_plot, size = (800, 400), bottom_margin = 10px, left_margin = 15px)
savefig("cpr/Plots/ABC_predictions.pdf")