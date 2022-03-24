#######################################################################
################# Finding the Monopoly Harvest ########################

################# Show the problem

ok  = cpr_abm(n = 150, ngroups = 150, lattice = (15,10), max_forest = 350000/2,
 leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = .01,
 wages = 1, fines1_on = false, fines2_on = false, seized_on = false,
 fidelity = .1, nrounds = 10000, nmodels = 3, mutation = .01, social_learning = true)

a=plot(ok[:stock][:,:,1], label = false, xlab = "Time", ylab = "Resource stock", ylim = (0, 1.2), alpha = .4)
b=plot(ok[:payoffR][:,:,1], label = false, xlab = "Time", ylab = "Payoff", ylim = (0, 25), alpha = .4)
out=plot(a,b, layout = (2,1))
png(out, "cpr/output/monpoloyfail.png")

################# Brute force a solution
 pay = []
 stock = []
 for i in collect(0.0:0.01:1.0)   
   ok  = cpr_abm(n = 150, ngroups = 150, lattice = (1,150), max_forest = 1166*150, 
   leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01, 
   wages = 1, fines1_on = false, fines2_on = false, nrounds = 3000, seized_on = false,
   nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = i)
   push!(pay, ok[:payoffR][:,1,1])
   push!(stock, ok[:stock][:,1,1])
 end

 plot(stock[1], alpha = .7, label = false)
 for i in 2:length(stock)
    display(plot!(stock[i], label = false, xlab = "Time", ylab = "Stock", ylim = (0, 1.1), alpha = .7))
 end
 means = [mean(pay[i]) for i in 1:length(stock)] 
 q=findmax(means)[2]
 a=plot!(stock[q], xlab = "Time", ylab = "Stock", ylim = (0, 1.1), lw = 3, lc =:black, label = "Stock level for max long-run payoff")


 plot(pay[1], alpha = .7, label = false)
 for i in 2:length(pay)
    display(plot!(pay[i], label = false, xlab = "Time", ylab = "Payoff", ylim = (0, 25), alpha = .7))
 end
 b=plot!(pay[q], xlab = "Time", ylab = "Payoff", ylim = (0, 25), lw = 3, lc =:black, label = "Max long-run payoff")
 out=plot(a,b, layout = (2,1))
 png(out, "cpr/output/monpoloybenchmark.png")


################# Show the effect of ruscola Wagner


# ok = cpr_abm(n = 150, ngroups = 150, lattice = (150,1), max_forest = 350000/2,
#  leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = .00,
#  wages = 1, fines1_on = false, fines2_on = false, seized_on = false,
#  fidelity = .01, nrounds = 1000, nmodels = 3, mutation = .01, social_learning = false, 
#  indvLearn = false, αlearn =.05)
# a=plot(ok[:stock][:,:,1], label = false, xlab = "Time", ylab = "Resource stock", ylim = (0, 1.2), alpha = .4)
# b=plot(ok[:payoffR][:,:,1], label = false, xlab = "Time", ylab = "Payoff", ylim = (0, 25), alpha = .4)
# plot(a,b, layout = (2,1))

################# Present solution


ok  = cpr_abm(n = 150, ngroups = 150, lattice = (1,150), max_forest = 1166*150, 
leak = false, pun1_on = false, punish_cost = 0.001,
pun2_on = false, learn_type = "income", mortality_rate = 0.01, wages = 1,
fines1_on = false, fines2_on = false, fidelity = .01, nrounds = 10000,
seized_on = false,  og_on = false,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, 
 socialLearnYear = (250:250:10000) )

# get comparison
comp  = cpr_abm(n = 150, ngroups = 150, lattice = (1,150), max_forest = 1166*150, 
leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01, 
wages = 1, fines1_on = false, fines2_on = false, nrounds = 10000, seized_on = false,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = .13)

a=plot(ok[:stock][:,:,1], label = false, xlab = "Time", ylab = "Resource stock", ylim = (0, 1.1), alpha = .4)
a=plot!(comp[:stock][:,1,1], xlab = "Time", ylab = "Resource Stock", ylim = (0, 1.1), lw = 3, lc =:black, label = "Max long-run payoff")

b=plot(ok[:payoffR][:,:,1], label = false, xlab = "Time", ylab = "Payoff", ylim = (0, 25), alpha = .4)
b=plot!(comp[:payoffR][:,1,1], xlab = "Time", ylab = "Payoff", ylim = (0, 25), lw = 3, lc =:black, label = "Max long-run payoff")

out=plot(a,b, layout = (2,1))

png(out, "cpr/output/monpoloysolution.png")



##################### Pareto Frontier ####################
using(Distributed)
#addprocs(15)
@everywhere include("C:/Users/jeffr/Documents/Work/cpr/code/abm/abm_invpun.jl")
S =expand_grid(collect(20:20:1000))

@everywhere function g(ival)
    cpr_abm(n = 150,
    ngroups = 150,
    lattice = (1,150),
    max_forest = 1166*150, 
    leak = false,
    pun1_on = false,
    punish_cost = 0.001,
    pun2_on = false,
    learn_type = "income",
    mortality_rate = 0.01,
    wages = 1,
    fines1_on = false,
    fines2_on = false,
    fidelity = .01,
    nrounds = 10000,
    seized_on = false,
    og_on = false,
    nmodels = 3, 
    mutation = .01,
    social_learning = true, 
    socialLearnYear = (ival:ival:10000))
end


abm_dat = pmap(g, S[:])

U=comp[:payoffR][21:end,1,1]
U1=comp[:payoffR][:,1,1]
    

bl = []
ml = []
el = []
err = 0.03
for i in 1:length(abm_dat)
    x=abm_dat[i][:payoffR]
    means = []
    for j in 21:10000
        y=mean(x[(j-20):j, :, 1])
        push!(means, y)
    end
    push!(el, sum(abs.(x[9000:10000,:] .- U1[9000:10000,:])))
    bounds = [zeros(20) ;ifelse.((means .<= (U*(1+err))) .& (means .>= (U*(1-err))), true, false)]
    within = zeros(50)
    for j in 51:length(bounds)
        push!(within, sum(bounds[j-50:j] .==1))
    end
    push!(ml, means)
    push!(bl, within)
end
 
mintime = []
for i in 1:length(bl)
    push!(mintime, findfirst(bl[i] .==51))
end

mintime[mintime .==nothing] .= 10000
using Colors, ColorSchemes

out=scatter(el, mintime, ylim = (2000, 11000), c=colormap("Blues",50), markersize=1:.5:40, label = false, xlab = "error", ylab = "time till equibrium")

png(out, "cpr/output/monopolypareto1.png")

out=scatter(el[5:50], mintime[5:50], ylim = (2000, 11000), c=colormap("Blues",46), markersize=1:.5:30, label = false, xlab = "error", ylab = "time till equibrium")
png(out, "cpr/output/monopolypareto2.png")




##################### Pareto Frontier Fine grained ####################
using(Distributed)
#addprocs(15)
@everywhere include("C:/Users/jeffr/Documents/Work/cpr/code/abm/abm_invpun.jl")
S =expand_grid(collect(80:10:500))

@everywhere function g(ival)
    cpr_abm(n = 150,
    nsim = 20,
    ngroups = 150,
    lattice = (1,150),
    max_forest = 1166*150, 
    leak = false,
    pun1_on = false,
    punish_cost = 0.001,
    pun2_on = false,
    learn_type = "income",
    mortality_rate = 0.01,
    wages = 1,
    fines1_on = false,
    fines2_on = false,
    fidelity = .01,
    nrounds = 10000,
    seized_on = false,
    og_on = false,
    nmodels = 3, 
    mutation = .01,
    social_learning = true, 
    socialLearnYear = (ival:ival:10000))
end


abm_dat = pmap(g, S[:])
@JLD2.save("uturn.jld2", abm_dat, S)



U=comp[:payoffR][21:end,1,1]
U1=comp[:payoffR][:,1,1]
    


ttel =[]
nel =[]
err = 0.03
n = 150
nsim = 5
for i in 1:length(abm_dat)
    bl = []
    ml = []
    el = []
    for k in 1:nsim
        x=abm_dat[i][:payoffR][:,:,k]
        means = []
        for j in 21:10000
            y=mean(x[(j-20):j, :, 1])
            push!(means, y)
        end
        push!(el, sum(abs.(x[9000:10000,:] .- U1[9000:10000,:]))/n/1000)
        bounds = [zeros(20) ;ifelse.((means .<= (U*(1+err))) .& (means .>= (U*(1-err))), true, false)]
        within = zeros(50)
        for j in 51:length(bounds)
            push!(within, sum(bounds[j-50:j] .==1))
        end
        push!(ml, means)
        push!(bl, within)
    end #end sims
    ok =zeros()
    ok=mean([el[k] for k in 1:nsim])
    push!(ttel, bl)
    push!(nel, ok)
end
 

mintime = []
for i in 1:length(ttel)
    x = ttel[i]
    temp = []
    for j in 1:length(x)
       push!(temp, findfirst(x[j] .==51))
    end
    temp[temp.==nothing] .= 10000
    push!(mintime, mean(temp))
end

mintime[mintime .==nothing] .= 10000
using Colors, ColorSchemes

out=scatter(nel, mintime, ylim = (4000, 9000), c=colormap("Blues",50), markersize=1:.5:40, label = false, xlab = "error", ylab = "time till equibrium")

png(out, "cpr/output/monopolypareto3.png")



