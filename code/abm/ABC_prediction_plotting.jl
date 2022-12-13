####################################################################
#################### ABC prediction Plotting #######################

# Load in data from prediction
# Identify most likley time step

LAND_prior=LAND./mean(LAND)
# get average leakage into a group at each time step 
# Scatter that against effort
nsim = 100
nround = 600
output = zeros(nsim, nround)
for k in 1:nsim 
    theft=[[mean((a[k][:loc][i,:,1].==j) .& (a[k][:gid][:,1].!=j)  ) for j in 1:24] for i in 1:nround] 
    coefs = zeros(nround, 3)
    for i in 2:nround
        df=DataFrame(:effort => Float64.(a[k][:effortfull][i, :, 1]),
                :theft => theft[i-1][Int.(a[k][:gid][:,1])][:,1],
                :stock => (LAND_prior.*a[k][:stock][i-1,:,1])[Int.(a[k][:gid][:,1])][:,1],
                #:stock => LAND[Int.(a[:gid][:,1])][:,1],
                :pop => POP[:, 2][Int.(a[k][:gid][:,1])][:,1])
        # fm = @formula(effort ~ theft + stock + pop) 
        fm = @formula(effort ~ theft + pop) 
        m1=lm(fm, df)
        typeof(m1)
        coefs[i,:]=coef(m1)
    end
    output[k,:] = coefs[:, 2]
end



effort_plot=plot(title = "Effort", titlefontsize = 8)
for i in 2:nround
    scatter!(fill(i, nsim), output[:,i], color = :firebrick, alpha = .1, label = false)
end
plot!(mean(output, dims = 1)', lw = 2, c= :orange, label = false, xlab = "Time step", ylab = "Coefficent estimate")
hline!([0], c=:grey, lw = 2, label = "")
vspan!(effort_plot, hpdi_bounds, label = nothing, color = :grey, alpha = .3)


# Examine overall leakage 
nsim = 100
output = zeros(nsim, nround)
for k in 1:nsim 
    theft=[[mean((a[1][:loc][i,:,1].==j) .& (a[k][:gid][:,1].!=j)) for j in 1:24] for i in 1:nround] 
    coefs = zeros(nround, 3)
    for i in 2:nround
        df=DataFrame(:leak => Float64.(a[k][:leakfull][i, :, 1]),
        :theft => theft[i-1][Int.(a[k][:gid][:,1])][:,1],
        #:stock => (LAND_prior.*a[k][:stock][i-1,:,1])[Int.(a[k][:gid][:,1])][:,1],
        :stock => LAND[Int.(a[k][:gid][:,1])][:,1],
        :pop => POP[:, 2][Int.(a[k][:gid][:,1])][:,1])
        # fm = @formula(leak ~ theft + stock + pop)
        fm = @formula(leak ~ theft +  pop) 
         
        # m1=glm(fm, df, Binomial(), LogitLink())
        m1=lm(fm, df)
        typeof(m1)
        coefs[i,:]=coef(m1)
    end
    output[k,:] = coefs[:, 2]
end

leakage_plot=plot()
for i in 2:nround
    scatter!(fill(i, nsim), output[:,i], color = :firebrick, alpha = .1, label = false)
end
plot!(moving_average(mean(output, dims = 1)', 10), lw = 2, c= :orange, label = false, xlab = "Time step", ylab = "", title = "Leakage", titlefontsize = 8)
hline!([0], c=:grey, lw = 2, label = nothing)
vspan!(leakage_plot, [hpdi_bounds], label = nothing, color = :grey, alpha = .3)


###########################################################
############## GENERATE STOCK PICTURE #####################
stock_plot=plot()
for i in 1:100
    plot!(a[i][:stock][:,:,1], label = nothing, alpha =.01, color = :black)
end
vspan!(stock_plot, [hpdi_bounds], label = nothing, color = :grey, alpha = .3, xlab = "Time step", ylab = "Prop Forest Remaining")

plot(regrowth, value, travel_cost, wage, nds, stock_plot, effort_plot, leakage_plot, size = (1200, 600), titlelocation = :left, titlefontsize = 8, layout = grid(2,4), bottom_margin = 15px, left_margin = 15px, title = ["a." "b." "c." "d." "e." "f." "g." "h."])
savefig("cpr/Plots/ABC.pdf")