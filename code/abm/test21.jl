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
    nsim = 5,
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

out=scatter(nel, mintime, ylim = (2000, 11000), c=colormap("Blues",50), markersize=1:.5:40, label = false, xlab = "error", ylab = "time till equibrium")

png(out, "cpr/output/monopolypareto3.png")















L = expand_grid(
        10 .^(collect(range(-3, stop = 1, length = 20))),
        10 .^(collect(range(-3, stop = 1, length = 20)))
)

for i in 1:length(L)
    S=collect(0.0:0.01:1.0)
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    @everywhere function g(P,W,P)
        cpr_abm(n = 150, ngroups = 150, lattice = (1,150), max_forest = 1400*150, regrow = 0.025,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = W, price = P, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = L)
    end
    msy=pmap(g, L[:,1], L[:,2])
    a=[msy[i][:payoffR][end,1,1] for i in 1:length(msy)]
    j=findmax(a)[2]
    push!(osy, msy[j][:harvest][end,1,1])
end



S =expand_grid( [150*9],         #Population Size
[9],            #ngroups
[[3, 3]],        #lattice, will be replaced below
[.0001],         #travel cost
[1],             #tech
[.7],            #labor
[1.5],             #limit seed values
10 .^(collect(range(-5, stop =1, length = 6))),       #Punish Cost
[210000*9],      #max forest
[0.0001,.9],     #experiment leakage
[0.5],           #experiment punish
[1],             #experiment_group
[3],             #groups_sampled
[1],             #Defensibility
[0],             #var forest
10 .^(collect(range(-3, stop = 1, length = 20))),          #price
[.025],          #regrowth
[[1, 1]],        #degrade
10 .^(collect(range(-3, stop = 1, length = 20))),       #wages,
[.5] # outgroup punishment experiment 
)


for i in size(S)[1]
    price = findall(x->x == S[i, 16], L[i,2])
    wage = findall(x->x == S[i, 19], L[i,1])
    inds=findall(price ∈ wage) 
    osy[]

S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,20] = ifelse.(S[:,10].==.0001, .0001, .9)



a=cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 1400*300, regrow = 0.025,
leak = false, pun1_on = false, pun2_on = true, learn_type = "income", mortality_rate = 0.01, 
wages = 1.3, price = .06, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false, defensibility = 1,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_limit = 4.70, experiment_punish2 = 1, punish_cost = 0, compress_data = false, nsim = 10)

#data
mean(a[:payoffR][700:1000,1,end])
mean(a[:stock][700:1000,1,end])
mean(a[:effort][700:1000,1,end])
mean(a[:harvest][700:1000,1,end])


plot(a[:payoffR][:,1,end], ylim = (14, 14.5))
plot(a[:stock][:,1,end], ylim = (0, 1))
plot(a[:harvest][:,1,end], ylim = (4, 5))


a=cpr_abm(n = 150*2, max_forest = 2*210000, ngroups =2, nsim = 1,
lattice = [2,1], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.0000, labor = .7, zero = true,  travel_cost = 0, seed = 1,
experiment_group = [1, 2], experiment_punish1 = 1, experiment_punish2 = 0.0001, experiment_leak = 0, experiment_limit = 4.8,
back_leak = false, control_learning = true, full_save = true)


plot(a[:effort][:,:,1], xlab = "effort")
plot(a[:leakage][:,:,1], xlab = "leakage")
plot(a[:stock][:,:,1], xlab = "stock")
plot(a[:payoffR][:,:,1], xlab = "payoff", ylim = (1, 2))
plot(a[:seized][:,:,1])
plot(a[:harvest][:,:,1])
plot(a[:seized2][:,:,1])
plot(a[:limit][:,:,1], xlab = "limit")





S =expand_grid( [150*9],         #Population Size
                [9],            #ngroups
                [[3, 3]],        #lattice, will be replaced below
                [.0001],         #travel cost
                [1],             #tech
                [.7],            #labor
                [1.5],             #limit seed values
                10 .^(collect(range(-5, stop =1, length = 6))),       #Punish Cost
                [210000*9],      #max forest
                [0.0001,.9],     #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [3],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20))),       #wages,
                [.5] # outgroup punishment experiment 
                )

S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,20] = ifelse.(S[:,10].==.0001, .0001, .9)

a=cpr_abm(nrounds = 1000,
            nsim = 1,
            fines1_on = false,
            fines2_on = false,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            full_save = true,
            control_learning = false,
            harvest_var = 1,
            n = 150*9,
            ngroups = 9,
            lattice = [3,3],
            travel_cost = 0.0001,
            tech = 1,
            labor = .7,
            harvest_limit = 7,
            punish_cost = 0.01,
            max_forest = 210000*9,
            groups_sampled =3,
            defensibility = 1,
            var_forest = 0,
            regrow = 0.025,
            wages = 1,
            price = .1
            )


a=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10,
lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.0000, labor = .7, zero = true,  travel_cost = 0, seed = 1,
experiment_group = [1, 2], experiment_punish1 = 1, experiment_punish2 = 0.0001, experiment_leak = 0, experiment_limit = 4.8,
back_leak = false, control_learning = true, full_save = true)




getOSY(labor = .7, n = 300, max_forest = 420000, regrow = 0.025, wages = 1, price = .2, ncores = 20)
a=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 2000,
lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, 
wages = 1, price = .2, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.01, labor = .7, zero = true,  travel_cost = 0, seed = 1,
full_save = true, socialLearnYear = collect(1:1:2000), learn_type = "income", policy_weight = "max", inher = true)

using Plots
i = 1

for i in 1:10
    p1=plot(a[:stock][:,:,i], label = false)
    p2=plot(a[:limit][:,:,i], label = false)
    p3=plot(a[:punish2][:,:,i], label = false)
    display(plot(p1, p2, p3))
end



b=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 2000,
lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, 
wages = 1, price = .2, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.01, labor = .7, zero = true,  travel_cost = 0, seed = 1,
full_save = true, socialLearnYear = collect(1:1:2000), learn_type = "income", policy_weight = "max", inher = false)

using Plots
i = 1

for i in 1:10
    p1=plot(b[:stock][:,:,i], label = false)
    p2=plot(b[:limit][:,:,i], label = false)
    p3=plot(b[:punish2][:,:,i], label = false)
    display(plot(p1, p2, p3))
end



c=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 2000,
lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, 
wages = 1, price = .2, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.01, labor = .7, zero = true,  travel_cost = 0, seed = 1,
full_save = true, socialLearnYear = collect(1:1:2000), learn_type = "wealth", policy_weight = "max", inher = false)

using Plots
i = 1

for i in 1:10
    p1=plot(c[:stock][:,:,i], label = false)
    p2=plot(c[:limit][:,:,i], label = false)
    p3=plot(c[:punish2][:,:,i], label = false)
    display(plot(p1, p2, p3))
end



d=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 2000,
lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, 
wages = 1, price = .2, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.01, labor = .7, zero = true,  travel_cost = 0, seed = 1,
full_save = true, socialLearnYear = collect(1:1:2000), learn_type = "wealth", policy_weight = "max", inher = true)

using Plots
i = 1

for i in 1:10
    p1=plot(d[:stock][:,:,i], label = false)
    p2=plot(d[:limit][:,:,i], label = false)
    p3=plot(d[:punish2][:,:,i], label = false)
    display(plot(p1, p2, p3))
end



e=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 2000,
lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, 
wages = 1, price = .2, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.01, labor = .7, zero = true,  travel_cost = 0, seed = 1,
full_save = true, socialLearnYear = collect(1:1:2000), learn_type = "income", policy_weight = "equal", inher = false)

using Plots
i = 1

for i in 1:10
    p1=plot(e[:stock][:,:,i], label = false)
    p2=plot(e[:limit][:,:,i], label = false)
    p3=plot(e[:punish2][:,:,i], label = false)
    display(plot(p1, p2, p3))
end






f=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 10000,
lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, 
wages = 1, price = .2, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.01, labor = .7, zero = true,  travel_cost = 0, seed = 1,
full_save = true, socialLearnYear = collect(1:1:2000), learn_type = "wealth", policy_weight = "equal", inher = true)

using Plots
i = 1

for i in 1:10
    p1=plot(f[:stock][:,:,i], label = false)
    p2=plot(f[:limit][:,:,i], label = false)
    p3=plot(f[:punish2][:,:,i], label = false)
    display(plot(p1, p2, p3))
end


median(f[:limit][1500:2000,:,:])

S =expand_grid( ["wealth", "income"],    # learn_type
                [true, false],          # inher
                ["equal", "max"],       # policy_weight
                ["wealth", "income"]   # glearn_strat
                )



@everywhere function g(lt, in, pw, gl) 
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 5000,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, 
    wages = 1, price = .2, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.01, labor = .7, zero = true,  travel_cost = 0, seed = 1,
    full_save = true, socialLearnYear = collect(1:1:5000),
     learn_type = lt, policy_weight = pw, inher = in, glearn_strat = gl)
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4])
using JLD2

@JLD2.save("tests.JLD2", abm_dat, S)

@JLD2.load("tests.JLD2")



lim = []
harv = Float64[]
pun2 = Float64[]
stock = Float64[]
for i in 1:size(abm_dat)[1]
    push!(lim, [mean(mean(abm_dat[i][:limit][4000:5000,:,j], dims=1), dims=2)[1] for j in 1:10])
end

# get limits


using Plots
plot(abm_dat[15][:limit][:,:,2])


