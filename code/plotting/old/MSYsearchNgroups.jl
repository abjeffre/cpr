############################################
############ SEARCH PROCESS FOR N GROUPS ###

using Plots.PlotMeasures
using Distributed
using Plots
using Serialization

run = false
if run == true
    # Multicore 2 groups
    @everywhere function g2(ng) 
        cpr_abm(labor = .7, max_forest = 105000*ng, n = ng*75, ngroups = ng, 
            lattice = [1,ng], harvest_limit = 2, harvest_var = .5, nrounds = 75000,
            harvest_var_ind = 0.1, experiment_group = collect(1:1:ng), invasion = true, nsim = 1,
            experiment_punish2 = 1, leak = false, control_learning = true, back_leak= true)
    end

    ng = fill(2, 80)
    testlong=pmap(g2, ng)
    
    # Multicore 9 groups

    ng = fill(9, 20)
    testlong9=pmap(g2, ng)
end
##################
#### Plot ########


testlong=deserialize("Y:/eco_andrews/Projects/CPR/data/abm/testlong.dat")
using Plots
timmer = collect(1:99:75000)
i=1
a= plot(testlong[i][:limit][timmer,:,1], label = "", alpha = .1, c = :black, ylab = "MAY", ylim = (0, 25))
[plot!(testlong[i][:limit][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:80]
hline!([3.5, 3.5], lw = 3, c = :red, label = "MSY")

i=1
b= plot(testlong[i][:stock][timmer,:,1], label = "", alpha = .1, c = :black, xlab = "Time", ylab = "Stock", title = "2 groups")
[plot!(testlong[i][:stock][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:80]

i=1
c= plot(testlong[i][:payoffR][timmer,:,1], label = "", alpha = .1, c = :black, ylab = "Payoffs")
[plot!(testlong[i][:payoffR][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:80]

MSYsearch2groups=plot(a, b, c, layout = grid(1,3), size = (975, 300), left_margin = 25px, bottom_margin = 25px)
savefig(MSYsearch2groups, "MSYsearch2groups.pdf")


testlong9=deserialize("Y:/eco_andrews/Projects/CPR/data/abm/testlong9.dat")
i=1
timmer = collect(1:99:75000)
a= plot(testlong9[i][:limit][timmer,:,1], label = "", alpha = .1, c = :black, ylab = "MAY")
[plot!(testlong9[i][:limit][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:20]
hline!([3.5, 3.5], lw = 3, c = :red, label = "MSY")

i=1
b= plot(testlong9[i][:stock][timmer,:,1], label = "", alpha = .1, c = :black, xlab = "Time", ylab = "Stock", title = "9 groups")
[plot!(testlong9[i][:stock][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:20]

i=1
c= plot(testlong9[i][:payoffR][timmer,:,1], label = "", alpha = .1, c = :black, ylab = "Payoffs")
[plot!(testlong9[i][:payoffR][timmer,:,1], label = "", alpha = .1, c = :black) for i in 1:20]

MSYsearch9groups=plot(a, b, c, layout = grid(1,3), size = (975, 300), left_margin = 25px, bottom_margin = 25px)
savefig(MSYsearch9groups, "MSYsearch9groups.pdf")
MSYsearch=plot(MSYsearch2groups, MSYsearch9groups, layout = grid(2,1), size = (975, 700))

savefig(MSYsearch, "MSYsearch.pdf")

# With final Histograms

final_limit9=reduce(vcat, [testlong9[i][:limit][75000,:,1] for i in 1:20])
final_limit2=reduce(vcat, [testlong[i][:limit][75000,:,1] for i in 1:80])

d1=histogram(final_limit2, bins = 30, ylim = (0,82), label = "", c =:black, alpha = .3)
vline!([3.5, 3.5])
d2=histogram(final_limit9, bins = 30, ylim = (0,82), label = "", c =:black, alpha = .3)
vline!([3.5, 3.5])

# Histograms with those under selection

final_forest9=reduce(vcat, [testlong9[i][:stock][75000,:,1] for i in 1:20])
final_forest2=reduce(vcat, [testlong[i][:stock][75000,:,1] for i in 1:80])

d1=histogram(final_limit2, bins = 30, ylim = (0,82), label = "", c =:black, alpha = .3)
histogram!(final_limit2[final_forest2.>.1], bins = 30, ylim = (0,82), label = "", c =:blue, alpha = .3)
vline!([3.5, 3.5])

d2=histogram(final_limit9, bins = 30, ylim = (0,82), label = "", c =:black, alpha = .3)
vline!([3.5, 3.5])


@Plots.density(final_limit)



