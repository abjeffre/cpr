using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
using Distributed
using DataFrames
using Serialization
#cd("C:\\Users\\jeffr\\Documents\\Work\\")
#cd("Y:\\eco_andrews\\Projects\\")

################# Brute force a solution
pay = []
stock = []

# cd("C:\\Users\\jeffr\\Documents\\Work\\")

# @everywhere include("C:\\Users\\jeffr\\Documents\\Work\\cpr\\code\\abm\\abm_invpun.jl")
# @everywhere include("C:\\Users\\jeffr\\Documents\\Work\\cpr\\code\\abm\\abm_bsm.jl")
# @everywhere include("C:\\Users\\jeffr\\Documents\\Work\\functions\\utility.jl")

 @everywhere include("Y:\\eco_andrews\\Projects\\cpr\\code\\abm\\abm_invpun.jl")
 @everywhere include("Y:\\eco_andrews\\Projects\\functions\\utility.jl")
 @everywhere include("Y:\\eco_andrews\\Projects\\cpr\\code\\abm\\abm_group_policy.jl")


 @everywhere include("C:\\Users\\jeffr\\Documents\\Work\\cpr\\code\\abm\\abm_group_policy.jl")


S=collect(0.0:0.05:1.0)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 1400*300, regrow = 0.025,
    leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01, 
    wages = 1.3, price = .06, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
    nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = L, compress_data = false)
  end
msy=pmap(g, S)

a=[mean(msy[i][:payoffR][700:end,1,1]) for i in 1:length(msy)]
i=findmax(a)[2]
lim=msy[i][:harvest][end,1,1]


########################## HETEROGENITY IN PATCH SIZE #######################################
a=cpr_abm(n = 150*2, max_forest = 2*410000, ngroups =2, nsim = 1, nrounds = 1000,
lattice = [1,2], harvest_limit = 16.168, regrow = .025, pun1_on = false, pun2_on = false, wages = 0.007742636826811269,
 price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.00650525196229018395, labor = .7, zero = true,
travel_cost = 0.003, full_save = true, kmax_data = [410000, 410000],
learn_group_policy = true)


seq = collect(210000:10000:640000)

out = []
for i in seq
    b=cpr_abm(n = 150*2, max_forest = 2*410000, ngroups =2, nsim = 1, nrounds = 1000,
    lattice = [1,2], harvest_limit = 16.168, regrow = .025, pun1_on = false, pun2_on = false, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true,
    travel_cost = 0.003, full_save = true, kmax_data = [i, 210000],
    learn_group_policy = true)
    push!(out, b)
end
plot(a[:leakage][:,:,1])
plot(b[:leakage][:,:,1])

het=[mean(out[i][:leakage][:,2,1]) for i in 1:length(out)]
heterogenity=plot(seq, het, label = false, xlab = "Heterogenity in patch size",
ylab = "Roving Banditry", c = :black,
title = "(a)", titlelocation = :left, titlefontsize = 15)
xticks!([minimum(seq), maximum(seq)], ["Low", "High"])


######################### STRINGENT POLICIES #############################

out2 = []
seq = collect(.2:.2:4)
for i in seq
    b=cpr_abm(n = 75*2, max_forest = 2*105000, ngroups =2, nsim = 1, nrounds = 500,
    lattice = [1,2], harvest_limit = 3.5, regrow = .01, pun1_on = false,
    pun2_on = true, wages = 0.1,
    price = 1, defensibility = 1, fines1_on = false,
    fines2_on = false, seized_on = true, labor = .7,
    zero = true, 
    travel_cost = 0.3, full_save = true, 
    experiment_limit = i, experiment_punish2 = 1)
    push!(out2, b)
end

stringent=[mean(out2[i][:leakage][:,1,1]) for i in 1:length(out2)]
stringent=plot(4 .- seq, stringent, c = :black, label = false, xlab = "Policy Stringency",
 xtick = ((.1, 3.8), ("Low", "High")), ylab = "Roving Banditry",
 title = "(b)", titlelocation = :left, titlefontsize = 15)

##################################################
########## EFFECT OF SEIZURES ####################

out3 = []
seq = [true, false]
for i in seq 
    L = fill(i, 40)
    @everywhere function newone(L)
        cpr_abm(n = 75*9, max_forest = 9*105000, ngroups =9, nsim = 1, nrounds = 500,
            lattice = [3,3], harvest_limit = 2, regrow = .01, pun1_on = true,
            pun2_on = true, wages = 0.1, harvest_var =.1,
            price = 1, defensibility = 1, fines1_on = false,
            fines2_on = false, seized_on = L, labor = .7,
            zero = true, harvest_var_ind = 0.1,
            travel_cost = 0.1, full_save = true)
    end
    println("gothere")
    b=pmap(newone, L)
    push!(out3, b)
end

serialize("seizures.dat", out3)


######## Plot that ###########


dat=deserialize("CPR\\data\\abm\\seizures.dat")

seizures=plot(dat[1][1][:punish][:,:,1], labels = "", ylab = "Support for Borders",
 xlab = "Time", c=:black, alpha = .1, xticks = (0, " "), ylim = (0,1),
 title = "(d)", titlelocation = :left, titlefontsize = 15)
[plot!(dat[1][i][:punish][:,:,1], labels = "", c =:black, alpha = .025) for i in 1:40]

noseizures=plot(dat[2][1][:punish][:,:,1], labels = "", ylab = "Support for Borders", xlab = "Time",
 c=:black, alpha = .1, xticks = (0, " "), ylim = (0,1),
 title = "(c)", titlelocation = :left, titlefontsize = 15)
[plot!(dat[2][i][:punish][:,:,1], labels = "", c =:black, alpha = .025) for i in 1:40]


section21=plot(heterogenity, stringent, seizures, noseizures, layout = grid(1,4), size = (1300, 300),
 left_margin = 25px, bottom_margin=25px)
 png("cpr//output//causesofborders.png")




#####################################
#####################################

S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*2, max_forest = 2*210000, ngroups =2, nsim = 100,
    lattice = [1,2], harvest_limit = 4.8, regrow = .025, pun2_on = false, 
    leak=false,
    wages = 1.3, price = .06, defensibility = 1, experiment_leak = L, experiment_effort =1, fines1_on = false, punish_cost = 0.001, labor = .7, zero = true)
end
dat=pmap(g, S)
#@JLD2.save("brute.jld2", dat)

@JLD2.load("cpr\\data\\abm\\brute.jld2")

y = [mean(dat[i][:punish][100:end,2,:], dims =1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 10)

mean(y)
border=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "IRC", ylab = "Support for borders",
xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")),
title = "(e)", titlelocation = :left, titlefontsize = 15)
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)

png("cpr//output//ostromfirstprinciple.png")







S=collect(0.1:.05:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 75*2, max_forest = 2*105000, ngroups =2, nsim = 100,
    lattice = [1,2], harvest_limit = 1, harvest_var = .1, harvest_var_ind = .1,
    regrow = .01, pun2_on = true, leak=false,
    wages = 0.1, price = 1, defensibility = 1, experiment_leak = L, experiment_effort =.5, experiment_punish2=1,
     fines1_on = false, punish_cost = 0.1, labor = .7, zero = true, begin_leakage_experiment = 1)
end
dat=pmap(g, S)
serialize("brutetest.dat", dat)



#GET LARGE POLICY DIFFRENCE
@everywhere include("cpr/code/abm/abm_group_policy.jl")

S=collect(0:.02:1)
S=collect(0.1:.05:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 75*9, max_forest = 9*105000, ngroups =9, nsim = 50,
    lattice = [3,3], harvest_limit = 4, harvest_var = .7, harvest_var_ind = .1,
    regrow = .01, pun2_on = true, leak=true, nrounds = 500,
    wages = 0.1, price = 1, experiment_punish1=L, experiment_group = collect(1:1:9), back_leak = true,
    fines1_on = false, punish_cost = 0.1, labor = .7, zero = true, learn_group_policy = true, control_learning = true)
end
dat=pmap(g, S)
serialize("brute2.dat", dat)




@JLD2.save("brute3.jld2", dat)

# SET UP PROPER COVARIANCE MAPPING

S=collect(.05:.05:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*201000, ngroups =9, nsim = 20,
    lattice = [3,3], harvest_limit = 8.75, regrow = .025, pun1_on = true, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.1, labor = .7, zero = true, experiment_punish1 = L,  travel_cost = 0.1,
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true, learn_group_policy = true)
end
dat=pmap(g, S)


#############################################################################
################### Plots ###################################################




using JLD2

dat = deserialize("cpr\\data\\abm\\brutetest.dat")

y = [mean(dat[i][:punish][400:500,2,:], dims =1) for i in 1:length(dat)]
a=reduce(vcat, y[2:19])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.01:.05:1)
x=repeat(x, 10)


mean(y)
border=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:grey, label = false,
 xlab = "Roving Bandity", ylab = "Support for borders",
xticks = (collect(0:4:20), ("0", "0.2", "0.4", "0.6", "0.8", "1")),
title = "(e)", titlelocation = :left, titlefontsize = 15)
scatter!(x.*19, y, c=:black, alpha = .2, label = false)




@JLD2.load("CPR\\data\\abm\\brute2.jld2")

y = [mean(mean(dat[i][:punish2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
Punish=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3,
 c=:grey, label = false, xlab = "Presence of Borders",
 ylab = "Support for Regulation", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")),
 title = "(f)", titlelocation = :left, titlefontsize = 15)
scatter!(x.*50, y, c=:black, alpha = .2, label = false)


@JLD2.load("CPR\\data\\abm\\brute3.jld2")

y1 = [mean(mean(dat[i][:punish2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y1[2:51])
μ = mean(a, dims = 2)
a=reduce(vcat, y1[2:51])
a=reduce(vcat, a)

y2 = [mean(mean(dat[i][:limit][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a2=reduce(vcat, y1[2:51])
μ = mean(a2, dims = 2)
a2=reduce(vcat, y2[2:51])
a2=reduce(vcat, a2)


Selection=scatter(a, a2, c=:black, ylim = (5, 16), label = false, xlab = "Support for Regulation", yticks = (0, " "), 
ylab = "MAY", alpha = .3,
title = "(g)", titlelocation = :left, titlefontsize = 15)
hline!([8.19], lw = 2, c=:red, label = "MSY", )


plot(border, Punish, Selection, layout = grid(1,3), size = [1000, 300], left_margin = 25px, bottom_margin = 20px, top_margin = 10px, right_margin = 20px)
png("cpr\\output\\trypic.png")




# ADD in MAY VS PAYOFF

dat=deserialize("CPR\\data\\abm\\brute5.dat")

# Mark if under selection

y1 = [mean(mean(dat[i][:payoffR][900:1000,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y1).+(collect(0.01:.05:1).*0.1) # adjust for institutional costs
μ = mean(a, dims = 2)
a=reduce(vcat, y1)
a=reduce(vcat, a)


y2 = [mean(mean(dat[i][:limit][900:1000,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a2=reduce(vcat, y2)
μ = mean(a2, dims = 2)
a2=reduce(vcat, y2)
a2=reduce(vcat, a2)


y3 = [mean(mean(dat[i][:punish2][900:1000,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a3=reduce(vcat, y3)
μ = mean(a3, dims = 2)
a3=reduce(vcat, y3)
a3=reduce(vcat, a3)

a3 = ifelse.(a3 .> .4, :red, :black)

Covariance=scatter(a2[a3 .== :red], a[a3 .== :red], c=:green, label = false, xlab = "MAY", xticks = (0, " "),  
ylab = "Payoffs", labels = "Selection", alpha = .5, markerstrokecolor = :green,
title = "(h)", titlelocation = :left, titlefontsize = 15)
scatter!(a2[a3 .== :black], a[a3 .== :black], c=:black, label = false, xlab = "MAY",  
ylab = "Payoffs", labels = ("Drift"), alpha = .5)
vline!([3.5, 3.5], c=:red, label = "MSY")


plot(border, Punish, Selection, Covariance, layout = grid(1,4), size = [1300, 300], left_margin = 25px, bottom_margin = 25px, top_margin = 10px, right_margin = 20px)
png("cpr\\output\\fourpic.png")



###################################
####### SEARCH PROCESS ############

 # Multicore 2 groups
 # Uses special Leakage group
 L = fill(.01, 40)
 ng = fill(9, 40) 
 @everywhere function g2(L, ng)  
    cpr_abm(labor = .7, max_forest = 105000*ng, n = ng*75, ngroups = ng, 
    lattice = [3,3], harvest_limit = 2, harvest_var = 0.5, nrounds = 5000, travel_cost = 0,
    harvest_var_ind = 0.1, experiment_group = collect(1:1:ng), zero = true, nsim = 1, regrow = 0.01,
    experiment_punish2 = 1, experiment_punish1 = 0.01,  experiment_leak = L, special_leakage_group = 5,
    leak=false, control_learning = true, back_leak= true, pun1_on = true, groups_sampled = 8, seized_on = false,
    begin_leakage_experiment = 1)
end
dat=pmap(g2, L, ng)
serialize("lowleak.dat", dat)
L = fill(1, 40)
ng = fill(9, 40)
@everywhere function g2(L, ng) 
       cpr_abm(labor = .7, max_forest = 105000*ng, n = ng*75, ngroups = ng, 
       lattice = [3,3], harvest_limit = 2, harvest_var = 0.5, nrounds = 5000, travel_cost = 0,
       harvest_var_ind = 0.1, experiment_group = collect(1:1:ng), zero = true, nsim = 1, regrow = 0.01,
       experiment_punish2 = 1, experiment_punish1 = 0.01,  experiment_leak = L, special_leakage_group = 5,
       leak=false, control_learning = true, back_leak= true, pun1_on = true, groups_sampled = 8, seized_on = false,
       begin_leakage_experiment = 1)
end

dat=pmap(g2, L, ng)
serialize("highleak.dat", dat)


#################################################
############### STABLIZATION ####################

L = fill(1, 40)
ng = fill(9, 40)
@everywhere function g2(L, ng) 
       cpr_abm(labor = .7, max_forest = 105000*ng, n = ng*75, ngroups = ng, 
       lattice = [3,3], harvest_limit = 2, harvest_var = 0.5, nrounds = 10000, travel_cost = 0,
       harvest_var_ind = 0.1, experiment_group = collect(1:1:ng), zero = true, nsim = 1, regrow = 0.01,
       experiment_punish2 = 1, experiment_punish1 = 0.01,  experiment_leak = L, special_leakage_group = 5,
       leak=false, control_learning = true, back_leak= true, pun1_on = true, groups_sampled = 8, seized_on = false,
       begin_leakage_experiment = 5000)
end

dat=pmap(g2, L, ng)

#############Plot ###################
dat=deserialize("CPR\\data\\abm\\stabilization.dat")
    trim = collect(1:10:10000)
    groups = [collect(1:4);collect(6:9)]
    a=plot(dat[1][:limit][trim,:,1], label = "", alpha = 0.1, c=:black)
    [plot!(dat[i][:limit][trim,:,1], label = "", alpha = 0.1, c=:black) for i in 2:20]
 
    a=plot(dat[1][:stock][trim,:,1], label = "", alpha = 0.1, c=:black)
    [plot!(dat[i][:stock][trim,:,1], label = "", alpha = 0.1, c=:black) for i in 2:20]
 



##########################
####### SEARCH ###########

using Serialization
dat=[deserialize("CPR\\data\\abm\\lowleak.dat"), deserialize("CPR\\data\\abm\\highleak.dat")]

plotsl = []
for j in 1:2
    trim = collect(1:10:5000)
    groups = [collect(1:4);collect(6:9)]
    lab = ifelse(j == 1, "(i)", "(j)")
    col = ifelse.(dat[j][1][:stock][trim,groups,1] .> .1, :green, :black)
    a=plot(dat[j][1][:limit][trim,groups,1], label = "", alpha = 0.1, linecolor=col, xticks = (0, ""), yticks = (0, ""),
     xlab = "Time", ylab = "MAY", ylim = (0, 6.1),
     title = lab, titlelocation = :left, titlefontsize = 15)
    for i in 1:40
        col = ifelse.(dat[j][i][:stock][trim,groups,1] .> .1, :green, :black)
        plot!(dat[j][i][:limit][trim,groups,1], label = "", alpha = 0.1, c=col)
    end

    hline!([3.5, 3.5], c = :red, label = "")
    push!(plotsl, a)
end



savefig(a, "test.pdf")

a=plot(heterogenity, stringent, noseizures, seizures, border, Punish, Selection, Covariance,
 plotsl[1], plotsl[2], layout = grid(3,4), size = (1300, 850), left_margin = 25px, bottom_margin = 25px, top_margin = 10px, right_margin = 20px);

 savefig(a, "cpr\\output\\full.pdf")





############################################################################## 
################## DYNAMICS ##################################################


test=cpr_abm(price = .5, wages = 10, punish_cost = 0.0005, travel_cost = 0.0001, baseline = 5, nrounds = 5000, pun2_on = true, nsim = 5, regrow = 0.022, n = 150, max_forest = 420000/2)

plot(mean(mean(test[:punish][1:750,:,3], dims = 3)[:,:,1], dims = 2), lw = 2, label = "Borders", ylab = "Trait Frequency", xlab = "time", ylim = (0, 1.2))
plot!(mean(mean(test[:leakage][1:750,:,3], dims = 3)[:,:,1], dims = 2), lw = 2, label = "IRC")

png("cpr\\output\\cylical.png")


plot(mean(mean(test[:punish][1:750,:,2], dims = 3)[:,:,1], dims = 2), lw = 2, label = "Borders", ylab = "Trait Frequency", xlab = "time", ylim = (0, 1.2), size = (430, 350))
plot!(mean(mean(test[:leakage][1:750,:,2], dims = 3)[:,:,1], dims = 2), lw = 2, label = "IRC")
png("cpr\\output\\cylical2.png")


@JLD2.load("CPR\\data\\abm\\brute22.jld2")


y = [mean(mean(dat[i][:leakage][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = mean(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)

leakage=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Roving Bandits", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")), size = (430, 350))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)
png("cpr\\output\\leak2.png")























































################################################################################################################################################
########################### SUPPORT FOR REGULATION #############################################################################################

########## FIND WHERE THE DIFFRENCE IS THE LARGEST
@JLD2.load("cpr\\data\\abm\\osy.jld2")
diff = findmax(osyp./ncsh)
par=L[diff[2],:]
lim=osy[diff[2]]

S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 20,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun1_on = true, 
    wages = 0.007742636826811269, price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_punish1 = L,  travel_cost = 0,
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true)
end
dat=pmap(g, S)
#@JLD2.save("brute2.jld2", dat)



##############################################################################
################### FOR DRAMATIC EFFECT ######################################
@everywhere include("cpr/code/abm/abm_group_policy.jl")

S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 20,
    lattice = [3,3], harvest_limit = 8.259+2, regrow = .025, pun1_on = true, 
    wages = 0.007742636826811269, price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, experiment_punish1 = L,  travel_cost = 0,
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true, learn_group_policy = true)
end
dat=pmap(g, S)
@JLD2.save("brute3.jld2", dat)



@JLD2.load("cpr\\data\\abm\\brute2.jld2")
load("cpr\\data\\abm\\brute21.jld")

y = [median(median(dat[i][:punish2][100:end,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)

mean(y)
self=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Support for self-regulation", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)

borders=function(;r = .5, # strarting bandits
    s = 1, # Starting forest stock
    x = .5, # Starting border patrols 
    k = 1,  # carrying capacity
    α =.1, # effect of eco-system health on theft
    β =.1, # loss of bandits due to internal competition and patrols
    γ = .1, # Growth in borders due to siezures
    ζ = .1, # Loss of border patrol due to competition over resources
    ω =.01, # Loss of forest due to harvesting    
    ι = .01, # regrowth rate  
    t= 1000
    )
    hists = []
    histr = []
    histx = []
            
    for i in 1:t
        #Record history
        push!(histr, r)
        push!(hists, s)
        push!(histx, x)  
        # Payoff by consumer type
        Δr =  α*s*r - β*r*x
        Δx =  γ*r*x*s -ζ*x
        Δs =  ι*s*(1-s) - ω*s*r
        Δs = isnan(Δs) ? 0 : Δs
        Δr = isnan(Δr) ? 0 : Δr
        Δx = isnan(Δx) ? 0 : Δx  
        #update
        r=copy(r+Δr)
        s=copy(s+Δs)
        x=copy(x+Δx)
        x=x > 1 ? 1 : x
        x=x < 0 ? 0.01 : x
        r=r > 1 ? 1 : r
        r=r < 0 ? 0.01 : r
        s=s > 1 ? 1 : s
        s=s < 0 ? 0 : s
    end
    out = Dict(:s =>Float16.(hists),
    :r =>Float16.(histr),
    :x =>Float16.(histx))
    return(out)
end #end function


out=borders(γ=.2, ω = .004, t = 1000)
maintain=plot(out[:s], ylim = (0,1), label = "Resource Stock", legend = :bottomleft, c = :green, ylab = "Trait frequency", xlab = "Time")
plot!(out[:x], label = "Border Patrols", c =:blue)
plot!(out[:r], label = "Roving Bandits", c = :red, bottom_margin = 20px, left_margin = 20px)

out=borders(γ=.2, ω = .006, t = 1000)
collapse=plot(out[:s], ylim = (0,1), label = "Resource Stock", legend = :bottomleft, c = :green, xlab = "time", ylab = " ")
plot!(out[:x], label = "Border Patrols", c = :blue)
plot!(out[:r], label = "Roving Bandits", c= :red, bottom_margin = 20px, left_margin = 20px)


png(plot(maintain, collapse, leakage, layout = grid(1,3), size = (900, 220)), "cpr//output//ostromfirstprincipleT.png")













#############################################################################
# ########################## GRAVE YARD #######################################





# #########################################################################
# ################ Leakage##################################################

# @JLD2.load("CPR\\data\\abm\\brute22.jld2")


# y = [mean(mean(dat[i][:leakage][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = mean(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# leakage=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "IRC", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)


# ###########################################################
# ########## Seizure #########################################

# y = [mean(mean(dat[i][:seized][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])./150
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Seized=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Seizures from out-groups", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



# y = [mean(mean(dat[i][:seized2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])./150
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)

# mean(y)
# Seized2=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Seziures from in-group", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)

# l = grid(1, 3)
# plot(leakage, Seized, Seized2, layout = l, size = (810, 250), left_margin = 20px, bottom_margin = 20px)
# png("cpr\\output\\leakage_ostrom.png")

# #########################################################################
# ######################## PUNISH #########################################

# y = [mean(mean(dat[i][:punish2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Punish=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Support for Regulation", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



# #####################################################
# ################ LIMIT ##############################



# y = [mean(mean(dat[i][:limit][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = std(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)

# limitvar=plot(μ, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Std(MAH)", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))



# y = [mean(mean(dat[i][:limit][300:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = mean(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Limit=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "MAH", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
#  hline!([8.29], label = false)
# # scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



# @JLD2.load("CPR\\data\\abm\\brute3.jld2")

# y1 = [mean(mean(dat[i][:punish2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y1[2:51])
# μ = mean(a, dims = 2)
# a=reduce(vcat, y1[2:51])
# a=reduce(vcat, a)

# y2 = [mean(mean(dat[i][:limit][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a2=reduce(vcat, y1[2:51])
# μ = mean(a2, dims = 2)
# a2=reduce(vcat, y2[2:51])
# a2=reduce(vcat, a2)


# Selection=scatter(a, a2, c=:firebrick, ylim = (5, 16), label = false, xlab = "Support for Regulation", 
# ylab = "Policy level")
# hline!([8.19], lw = 2, c=:blue, label = "OSY", )



# @JLD2.load("CPR\\data\\abm\\brute2.jld2")





# ###########################################################
# ########## Stock #########################################

# y = [mean(mean(dat[i][:stock][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Stock=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "stock", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)


# l = grid(1, 3)
# a=plot(Punish, Selection, Stock, layout = l, size = (810, 250), left_margin = 20px, bottom_margin = 20px)

# png("cpr\\output\\punsih2_ostrom.png")



# plot(border, Punish, Selection, layout = l, size = (810, 250), left_margin = 20px, bottom_margin = 20px)
# png("cpr\\output\\ostrom_typtic.png")



# #############################################################################
# ##################### TIME SERISE ###########################################

# test=cpr_abm(price = .5, wages = 10, punish_cost = 0.0005, travel_cost = 0.0001, baseline = 5, nrounds = 5000, pun2_on = true, nsim = 5, regrow = 0.022, n = 150, max_forest = 420000/2)

# plot(mean(mean(test[:punish][1:750,:,3], dims = 3)[:,:,1], dims = 2), lw = 2, label = "Borders", ylab = "Trait Frequency", xlab = "time", ylim = (0, 1.2))
# plot!(mean(mean(test[:leakage][1:750,:,3], dims = 3)[:,:,1], dims = 2), lw = 2, label = "IRC")

# png("cpr\\output\\cylical.png")


# plot(mean(mean(test[:punish][1:750,:,2], dims = 3)[:,:,1], dims = 2), lw = 2, label = "Borders", ylab = "Trait Frequency", xlab = "time", ylim = (0, 1.2), size = (430, 350))
# plot!(mean(mean(test[:leakage][1:750,:,2], dims = 3)[:,:,1], dims = 2), lw = 2, label = "IRC")
# png("cpr\\output\\cylical2.png")


# leakage=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "IRC", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")), size = (430, 350))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)
# png("cpr\\output\\leak2.png")









# plot(mean(mean(test[:punish][1:750,:,1], dims = 3)[:,:,1], dims = 2), lw = 2, label = "Borders", ylab = "Trait Frequency", xlab = "time", ylim = (0, 1.2))
# plot!(mean(mean(test[:leakage][1:750,:,1], dims = 3)[:,:,1], dims = 2), lw = 2, label = "IRC")








# plot(border, Punish, Selection)








# #########################################################################
# ################ PAYOFF##################################################


# y = [mean(mean(dat[i][:payoffR][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = mean(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# payoff=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Payoff", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)


# ###########################################################
# ########## PUNISH 2 #######################################

# y = [mean(mean(dat[i][:punish2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Punish=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Punish2", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)




# ###########################################################
# ########## EFFORT #########################################

# y = [mean(mean(dat[i][:effort][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Effort=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Effort", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)


# ###########################################################
# ########## Harvest #########################################

# y = [mean(mean(dat[i][:harvest][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Harvest=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Harvest", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)
# hline!([4.8])


# ###########################################################
# ########## Stock #########################################

# y = [mean(mean(dat[i][:stock][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Stock=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "stock", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



# plot(Stock, Effort, Harvest, Punish, payoff, limit, limitvar, leakage)





# ###########################################################
# ########## Seizure #########################################

# y = [mean(mean(dat[i][:seized][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])./150
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Seized=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Seizures from out-groups", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



# y = [mean(mean(dat[i][:seized2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])./150
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)

# mean(y)
# Seized2=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Seziures from in-group", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)

# plot(leakage, Seized, Seized2, Effort)






# plot(Stock, Effort, Harvest, Punish, payoff, limit, limitvar, leakage, Seized)


# ###########################################################
# ########## Stock #########################################

# y = [mean(mean(dat[i][:harvest][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a1=reduce(vcat, y[2:51])
# μ1 = median(a1, dims = 2)

# y = [mean(mean(dat[i][:limit][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a2=reduce(vcat, y[2:51])
# μ2 = median(a2, dims = 2)

# a=a1 .- a2

# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# plot(μ1- μ2)

# mean(y)
# Stock=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "stock", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



# plot(Stock, Effort, Harvest, Punish, payoff, limit, limitvar, leakage)



# ###########################################################
# ########## CLP2 #########################################

# y = [mean(mean(dat[i][:clp2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)


# mean(y)
# Stock=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "CLP2", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)





# ######################################################################################
# ######################## SUPPORT FOR REGULATION VARIANCE #############################
# S=collect(0:.02:1)
# # set up a smaller call function that allows for only a sub-set of pars to be manipulated
# @everywhere function g(L)
#     cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 50,
#     lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
#     wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
#     punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = L, 
#     experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, )
# end
# dat=pmap(g, S)
# #@JLD2.save("brute2.jld2", dat)








# ##############################################################################################
# ############################ SET TRAVEL COST #################################################


# S=collect(0:.02:1)
# @everywhere function g(L)
#     cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 20,
#     lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
#     wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
#     punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = L, travel_cost = 0.001,
#     experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true)
# end

# dat=pmap(g, S)
# @JLD2.save("brute3.jld2", dat)
# #@JLD2.save("brute2.jld2", dat)
# @JLD2.load("cpr\\data\\abm\\brute3.jld2")


# y = [median(median(dat[i][:punish2][100:end,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)

# mean(y)
# self=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
#  ylab = "Support for self-regulation", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



# ##############################################################################################
# ############################ VARIANCE        #################################################


# S=collect(.01:.02:1)*100000
# S = [0; S]
# @everywhere function g(L)
#     cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10,
#     lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = false, pun2_on = false,
#     var_forest = L, 
#     wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
#     punish_cost = 0.01, labor = .7, zero = true, travel_cost = 0.01, back_leak = true, control_learning = true, groups_sampled = 6)
# end

# dat=pmap(g, S)
# @JLD2.save("brute4.jld2", dat)
# #@JLD2.save("brute2.jld2", dat)
# @JLD2.load("cpr\\data\\abm\\brute4.jld2")



# y = [median(median(dat[i][:leakage][1:end,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 50)

# mean(y)
# leak=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Variance",
#  ylab = "Leakage", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



# #############################################################################################
# ###################### TIME SERISE ##########################################################

# plot(mean(mean(dat[27][:punish2][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))
# plot!(mean(mean(dat[27][:stock][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))
# plot!(mean(mean(dat[27][:leakage][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))


# plot(mean(mean(dat[10][:punish2][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))
# plot!(mean(mean(dat[10][:stock][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))
# plot!(mean(mean(dat[10][:leakage][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))


# tempa=cpr_abm(n = 75*9, max_forest = 9*75*1400, ngroups =9, nsim = 1,
# lattice = [3,3], harvest_limit = 8.13-2, regrow = .025, pun1_on = true, full_save = true, 
# harvest_var = 3, harvest_var_ind = 1,
# wages = 0.0069519279617756054, 
# price = 0.0016237767391887226,
# defensibility = 1, 
# fines1_on = false,
# fines2_on = false, 
# punish_cost = 0.00001,
# labor = .7,
# zero = true,
# learn_group_policy = true,
# nrounds = 1500, 
# glearn_strat = "income",
# outgroup = 0.01)


# tempb=cpr_abm(n = 75*49, max_forest = 49*75*1400, ngroups =49, nsim = 1,
# lattice = [7,7], harvest_limit = 8.13-2, regrow = .025, pun1_on = true, full_save = true, 
# harvest_var = 3, harvest_var_ind = 1,
# wages = 0.0069519279617756054, 
# price = 0.0016237767391887226,
# defensibility = 1, 
# fines1_on = false,
# fines2_on = false, 
# punish_cost = 0.00001,
# labor = .7,
# zero = true,
#  learn_group_policy = false,
# nrounds = 1000, 
# outgroup = 0.01)


# plot(tempa[:punish2][:,:,1], ylim = (0, 1), label = false)
# plot(tempa[:punish][:,:,1], ylim = (0, 1), label = false)
# plot(tempa[:payoffR][:,:,1], label = false)
# plot(tempa[:limit][:,:,1], label = false)
# plot(tempa[:stock][:,:,1], label = false)
# plot(tempa[:harvest][:,:,1])


# plot(tempb[:punish2][:,:,1], ylim = (0, 1), label = false)
# plot(tempb[:punish][:,:,1], ylim = (0, 1), label = false)
# plot(tempb[:payoffR][:,:,1], label = false)
# plot(tempb[:limit][:,:,1], label = false)
# plot(tempb[:stock][:,:,1], label = false)
# plot(tempa[:harvest][:,:,1])


# plot(temp2[:punish2][:,:,1], ylim = (0, 1))

# hline!([8.19])
# plot(temp2[:limit][:,:,1])



# mean(temp2[:punish2][:,:,1])
# mean(tempa[:punish2][:,:,1])

# plot!(mean(mean(tempa[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))


# plot(mean(mean(tempa[:punish2][:,:,1], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot!(mean(mean(tempa[:punish][:,:,1], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot!(mean(mean(tempa[:leakage][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot!(mean(mean(tempa[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))


# plot(mean(mean(tempa[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
# plot(mean(mean(tempa[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 16))
# plot(mean(mean(tempa[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
# plot(mean(mean(tempb[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(tempb[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))



# tempb =   cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 1,
# lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
# wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
# punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = .55, 
# experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true)

# plot(tempb[:punish2][:,:,1])


# tempb =   cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10,
# lattice = [3,3], harvest_limit = 6, regrow = .025, pun1_on = true, harvest_var = 2.5,
# wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
# punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = 0.02, 
# experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true)



# plot(mean(mean(tempb[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(tempb[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
# plot(mean(mean(tempb[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
# plot(mean(mean(tempb[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(tempb[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))



# t1 =   cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 1000,
# lattice = [3,3], harvest_limit = 4, regrow = .01, pun1_on = true,
# wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
# punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = 0.02, 
# experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true)



# plot(mean(mean(t1[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t1[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
# plot(mean(mean(t1[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
# plot(mean(mean(t1[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t1[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))
# plot(mean(mean(t1[:effort][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))



# t2 =   cpr_abm(n = 75*36, max_forest = 36*210000, ngroups =36, nsim = 5, nrounds = 1000,
# lattice = [6,6], harvest_limit = 6, regrow = .025, pun1_on = true, harvest_var = 3,
# wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
# punish_cost = 0.01, labor = .7, zero = true, back_leak = false, control_learning = false, full_save = true)



# plot(mean(mean(t2[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t2[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
# plot(mean(mean(t2[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
# plot(mean(mean(t2[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t2[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))
# plot(mean(mean(t2[:effort][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))



# t3 =   cpr_abm(n = 150*49, max_forest = (49)*210000, ngroups =49, nsim = 5, nrounds = 500,
# lattice = [7,7], harvest_limit = 6, regrow = .025, pun1_on = true, harvest_var = 3,
# wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
# punish_cost = 0.01, labor = .7, zero = true, back_leak = false, control_learning = false, full_save = true)


# plot(mean(mean(t3[:punish][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t3[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t3[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
# plot(mean(mean(t3[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
# plot(mean(mean(t3[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t3[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))
# plot(mean(mean(t3[:effort][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))





# t4 =   cpr_abm(n = 150*49, max_forest = (49)*210000, ngroups =49, nsim = 5, nrounds = 500,
# lattice = [7,7], harvest_limit = 3.5, regrow = .025, pun1_on = true, harvest_var = 2,
# wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
# punish_cost = 0.01, labor = .7, zero = true, back_leak = true, control_learning = true, full_save = true, 
# experiment_punish1 = 1, experiment_group = [collect(1:49)][1])



# plot(mean(mean(t4[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t4[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
# plot(mean(mean(t4[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
# plot(mean(mean(t4[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t4[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))
# plot(mean(mean(t4[:effort][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
# plot(mean(mean(t4[:harvest][:,:,:], dims = 3), dims = 2)[:,:,1])
# plot(mean(mean(t4[:harvest][:,:,:], dims = 3), dims = 2)[:,:,1]./mean(mean(t4[:effort][:,:,:], dims = 3), dims = 2)[:,:,1])








# S=collect(0:.02:1)
# # set up a smaller call function that allows for only a sub-set of pars to be manipulated
# @everywhere function g(L)
#     cpr_abm(n = 150*2, max_forest = 2*210000, ngroups =2, nsim = 50,
#     lattice = [1,2], harvest_limit = 4.8, regrow = .025, pun2_on = false, leak=false,
#     wages = 1.3, price = .06, defensibility = 1, experiment_leak = L, experiment_effort =1, fines1_on = false,
#      punish_cost = 0.001, labor = .7, zero = true, bsm = "collective")
# end
# dat=pmap(g, S)
# #@JLD2.save("brute.jld2", dat)

# y = [mean(dat[i][:punish][100:end,2,:], dims =1) for i in 1:length(dat)]
# a=reduce(vcat, y[2:51])
# μ = median(a, dims = 2)
# PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
# PI=vecvec_to_matrix(PI) 
# y=reduce(vcat, a)
# x=collect(.02:.02:1)
# x=repeat(x, 10)

# mean(y)
# border=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "IRC", ylab = "Support for borders",
# xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")) , size = (300, 250))
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)


