
nrounds = 500
capture_rate = .05
price = .20
mah = .5
welast = 0
labor = rand(Uniform(.99, 1), 300)
freq = 5

pbauw = []
pbauc = []
phighw = []
phighc = []

for i in 1:20
        ##############################################################
        ################ MOST SIMPLE MODEL ########################### 
        w = cos.(collect(1:nrounds)./(pi*freq)) + rand(Normal(0,0.1), nrounds)
        c = cos.(collect(1:nrounds)./(pi*freq)) + rand(Normal(0,0.1), nrounds)
        g = ((c+w)./10) .+ -minimum((c+w)./10)
        g2 =((c.*2+w)./10) .+ -minimum((c+w)./10)
        y = reduce(vcat, rand.(Poisson.(exp.(g.*.5)), 1))
        d= DataFrame(y =y,
                g = g,
                c = c)
        formula = @formula(y ~ c)
        glm(formula, d, Poisson())

        formula = @formula(y ~ g)
        glm(formula, d, Poisson())

        formula = @formula(y ~ c + g)
        glm(formula, d, Poisson())



        plot(weather, wages, ylim = (0, .4))

        a = cpr_abm(tech =.000002,
        leak = false,
        experiment_limit = mah,
        regrow = 0.007,
        experiment_punish2 = capture_rate,
        outgroup = 0.001,
        wage_data = g,
        price = price, 
        nrounds = nrounds,
        max_forest = 20000,
        set_stock = .5,
        nsim = 1,
        nmodels=5,
        labor = 1,
        fidelity = .2,
        labor_market = false,
        genetic_evolution = false)

        b = cpr_abm(tech =.000002,
        leak = false,
        experiment_limit = mah,
        regrow = 0.007,
        experiment_punish2 = capture_rate,
        outgroup = 0.001,
        wage_data = g2,
        price = price, 
        nrounds = nrounds,
        max_forest = 20000,
        set_stock = .5,
        nsim = 1,
        nmodels=5,
        labor = 1,
        fidelity = .2,
        labor_market = false,
        genetic_evolution = false)


        ##################################
        ############ BAU #################

        caught = Int64.(round.(a[:caught2][1:end,1,1].*300, digits=0))
        dat=DataFrame(caught = caught,
                wage = g[1:end],
                climate = c[1:end])

        # Weather and Wages
        fm = @formula(caught ~ wage + climate)
        lm_bau = glm(fm, dat, Poisson())
        pvals =coeftable(lm_bau).cols[4][2:3]
        push!(pbauc, pvals[1])
        push!(pbauc, pvals[2])


        ######################################
        ############ HIGH VAR #################

        caught = Int64.(round.(b[:caught2][1:end,1,1].*300, digits=0))
        dat=DataFrame(caught = caught,
                wage = g2[1:end],
                climate = c[1:end]*2)
        # Weather and Wages
        fm = @formula(caught ~ wage + climate)
        lm_high = glm(fm, dat, Poisson())
        pvals =coeftable(lm_high).cols[4][2:3]
        push!(phighc, pvals[1])
        push!(phighc, pvals[2])
end




##################################################################
############## INTRODUCE MONITORING COVARYING WITH WAGES #########

# Notes: In the Pemba 



# plot!(high, label = "#high", c = "black", ylim = (0, .5), alpha = .5)
# plot!(bau, label = "bau", c = "#15bfca", ylim = (0, .5), alpha = .5)


# # It appears that the marginal increase in the rate of illegal activity is sensitve to 
# # The 

# c = .1

# #################
# function overharvest(; w1=.25, b= .25, c  = .1, h1 = .1)
#         ifelse.(c .< b.*h1 .- w1.*h1, 1 ,0)
# end

# plot(overharvest(w1= bau, b= 1.1))

# plot(b[:effort][:,1,:])

# plot(baup)
# plot!(highp) 



#  plot!(mean(a[:stock][:,1,:], dims = 2), label = "")
#  plot!(mean(a[:payoffR][:,1,:], dims = 2), label = "", ylim = (0, 1))
#  plot!(mean(a[:effort][:,1,:], dims = 2), label = "", ylim = (0, 1))
#  plot!(mean(a[:harvest][:,1,:], dims = 2), label = "", ylim = (0, 1))



# b = cpr_abm(tech =.000002,
#  leak = false,
#  experiment_limit = .2,
#  regrow = 0.007,
#  experiment_punish2 = .2,
#  outgroup = 0.001,
#  wages = .25,
#  price = .25, 
#  nrounds = nrounds,
#  max_forest = 20000,
#  #reset_stock = reset_stock,
#  nsim = 30)

# low=plot(mean(b[:caught2][:,1,:], dims = 2), label = "", xlab = "Time", c = "#CA2015")
#  hline!((.25, .25), label = "", c = "black")
#  plot!(mean(b[:stock][:,1,:], dims = 2), label = "")
 

# plot(low, high, size = (900, 400), bottom_margin = 20px, grid = false, lw =2)
# savefig("simulation_predictions.pdf")

# ############################
# #### CHECK RELATIONSHIP ####

# # Check Coefs
# acoefs=[]
# for i in 1:30
#     caught = Float64.(a[:caught2][100:end,1,i])
#     dat=DataFrame(caught = caught,
#             wage = wage[100:end])
#     fm = @formula(caught ~ wage)
#     lm1 = glm(fm, dat, Normal())
#     push!(acoefs, coef(lm1)[2])
#    # push!(bstd, stder(lm1)[2])
# end
# scatter(acoefs)



# # Check Coefs
# bcoefs=[]
# for i in 1:30
#     caught = Float64.(b[:caught2][100:end,1,i])
#     dat=DataFrame(caught = caught,
#             wage = wage[100:end])
#     fm = @formula(caught ~ wage)
#     lm1 = glm(fm, dat, Normal())
#     push!(bcoefs, coef(lm1)[2])
#    # push!(bstd, stder(lm1)[2])
# end
# scatter(bcoefs)


