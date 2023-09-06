
###################################################### 
########## Set up Seasonal Variation in Wages ########

nrounds = 1500
reset_stock=fill(true, nrounds)
wage_scalar =  0.1
wave_frequency = .03
amplitude =5
wage1 =  wage_scalar .* ((sin.(wave_frequency .*collect(1:nrounds)) .+ 1)*amplitude/2)
plot(wage1)

a = cpr_abm(tech =.000002,
 leak = false,
 experiment_limit = .2,
 regrow = 0.007,
 experiment_punish2 = .2,
 outgroup = 0.001,
 wage_data = wage1,
 price = .25, 
 nrounds = nrounds,
 max_forest = 20000,
 #reset_stock = reset_stock,
 nsim = 30)

 high=plot(mean(a[:caught2][:,1,:], dims = 2), label = "", xlab = "Time", c = "#CA2015")
 plot!(wage1, label = "", c = "black")
 plot!(mean(a[:stock][:,1,:], dims = 2), label = "")
 


b = cpr_abm(tech =.000002,
 leak = false,
 experiment_limit = .2,
 regrow = 0.007,
 experiment_punish2 = .2,
 outgroup = 0.001,
 wages = .25,
 price = .25, 
 nrounds = nrounds,
 max_forest = 20000,
 #reset_stock = reset_stock,
 nsim = 30)

low=plot(mean(b[:caught2][:,1,:], dims = 2), label = "", xlab = "Time", c = "#CA2015")
 hline!((.25, .25), label = "", c = "black")
 plot!(mean(b[:stock][:,1,:], dims = 2), label = "")
 

plot(low, high, size = (900, 400), bottom_margin = 20px, grid = false, lw =2)
savefig("simulation_predictions.pdf")

############################
#### CHECK RELATIONSHIP ####

# Check Coefs
acoefs=[]
for i in 1:30
    caught = Float64.(a[:caught2][100:end,1,i])
    dat=DataFrame(caught = caught,
            wage = wage[100:end])
    fm = @formula(caught ~ wage)
    lm1 = glm(fm, dat, Normal())
    push!(acoefs, coef(lm1)[2])
   # push!(bstd, stder(lm1)[2])
end
scatter(acoefs)



# Check Coefs
bcoefs=[]
for i in 1:30
    caught = Float64.(b[:caught2][100:end,1,i])
    dat=DataFrame(caught = caught,
            wage = wage[100:end])
    fm = @formula(caught ~ wage)
    lm1 = glm(fm, dat, Normal())
    push!(bcoefs, coef(lm1)[2])
   # push!(bstd, stder(lm1)[2])
end
scatter(bcoefs)


