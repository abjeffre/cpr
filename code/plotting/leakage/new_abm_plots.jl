#################################
########### CPR ABM #############
using JLD2
using LaTeXStrings
using Plots
using Plots.PlotMeasures
using ColorSchemes


#################################################
############ BORDERS ############################

if run
    @everywhere function hu(ex)
        cpr_abm(pun2_on = false, leak = false,
            begin_leakage_experiment = 1, n = 150, experiment_leak= ex, tech = .5, wages = 2, punish_cost = 2, experiment_effort = 1,
            kmax_data = [350000/2, 350000/2], nrounds = 1000, baseline = 100, nmodels = 2, nsim = 100, inspect_timing = "after")
        end

    S = collect(0.01:.02:.99)
    out=pmap(hu, S[:])
    #jldsave("borders.jld2"; out)
end

out=load("borders.jld2")["out"]

out[1]
out2 = zeros(50)
for i in 1:50
    out2[i]=mean(mean(out[i][:punish][800:1000,2,:], dims =2))
end
out2
borders2 =plot(out2, ylim = (-0.02, 1), label = false, c = :black, ylab = "Borders", xlab = "Leakage", axis = nothing, left_margin = 5mm)

###################################
######## BORDERS CYLICAL ##########

a=cpr_abm(pun2_on = false, n = 150, tech = .5, wages = .001, punish_cost = .95, social_learning = false, travel_cost = .001,
kmax_data = [650000/2, 350000/2], nrounds = 20000, baseline = 1, nmodels = 2, nsim = 1, inspect_timing = "after", zero = true, mutation = .05)


function smooth(x, α = .5)
    n=length(x)
    y=zeros(n)
    y[1] = x[1]
    for i in 2:n
        y[i]=(1-α)*x[i] + α*y[i-1]
    end
    return y
end


borders_cylical=plot(smooth(a[:leakage][10000:20000,2,1], .997), axis = nothing, ylab = "Trait value", xlab = "Time", 
left_margin = 5mm, c= :black, w =1, label = "")
annotate!(9000, .33, text("x", :red, :left, 10))

plot!(smooth(a[:punish][10000:20000,2,1], .997), c= :red, lw =1, label = "")
annotate!(9000, .1, text("eₗ", :black, :left, 10))

###############################################
############## SELF REGULATION ################
if run 
    @everywhere function hu(ex)
                cpr_abm(pun1_on = false, leak = false,
                    begin_leakage_experiment = 1, experiment_leak= ex, tech = .5, wages = 1, travel_cost=.001, punish_cost = .01,
                    kmax_data = [450000, 350000], nrounds = 1000, baseline = 100, nmodels = 2, nsim = 100)
                end

    S = collect(0.01:.02:.99)
    out=pmap(hu, S[:])
    fun = copy(out)
    #jldsave("self_regulation.jld2"; fun)
end

fun=load("self_regulation.jld2")["fun"]
out3 = zeros(50)
for i in 1:50
    out3[i]=mean(mean(fun[i][:punish2][800:1000,2,:], dims =2))
end
self_regulation2 =plot(out3, ylim = (0, 1), label = false, c = :black, xlab = "Leakage", ylab = "Self-Regulation", axis = nothing, left_margin = 5mm)
#save("example.jld2", a)

# to do 
# remove total revenue from panel 2, 3 
# Re-label trait value and annotate e and zeta
# Get OAE in correct spots!


################################################
########### LEAKAGE ############################

# @everywhere function hu(ex)
#     cpr_abm(pun1_on = false, pun2_on = false, leak = true, back_leak = false, ngroups = 3, lattice = [1,3], n = 150,
#     begin_leakage_experiment = 1, experiment_effort = 1, experiment_leak= ex, tech = 1, wages = 10, travel_cost=.01, punish_cost = .01,
#     kmax_data = [450000/3, 350000/3, 350000/3], nrounds = 1000, baseline = 100, nmodels = 2, nsim = 100, experiment_group = [1], special_leakage_group = 3, special_experiment_leak =0)    
#     end

# S = collect(0.01:.02:.99)


# leak=pmap(hu, S[:])

# cg=cgrad(:imola,range(0,stop=1,length=51))
# out2 = zeros(1000, 50)
# for i in 1:50
#     out2[:,i]=mean(leak[i][:leakage][:,2,:], dims =2)
#     #plot!(mean(out[i][:punish2][:,2,:], dims =2), label = false, c=cgrad(:imola)[i*5])
#     #out2[i]=mean(mean(out[i][:punish2][800:1000,2,:], dims =2))
# end
# p1new=plot(out2, ylim = (0, 1), alpha = .9, linez = (1:100)'/50, label = false, c = :imola, xlab = "Time", ylab = "Trait value", axis = nothing, left_margin = 5mm)

# out2 = zeros(1000, 50)
# for i in 1:50
#     out2[:,i]=mean(leak[i][:effort][:,2,:], dims =2)
#     #plot!(mean(out[i][:punish2][:,2,:], dims =2), label = false, c=cgrad(:imola)[i*5])
#     #out2[i]=mean(mean(out[i][:punish2][800:1000,2,:], dims =2))
# end
# out2
# p2new=plot(out2, ylim = (0, 1), alpha = .9, linez = (1:100)'/50, label = false, c = :imola, xlab = "Time", ylab = "Trait value", axis = nothing, left_margin = 5mm)

# plot(p1new, p2new, size =(800, 400))

# # Finish plotting here!

