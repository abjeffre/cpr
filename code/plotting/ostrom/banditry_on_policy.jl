###################################################################
##################### BANDITRY ON POLICY ##########################

 # Multicore 2 groups
 # Uses special Leakage group
if RUN == true
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
    serialize("CPR\\data\\abm\\lowleak.dat", dat)
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
    serialize("CPR\\data\\abm\\highleak.dat", dat)
end

println("got here")

using Serialization
dat=[deserialize("CPR\\data\\abm\\lowleak.dat"), deserialize("CPR\\data\\abm\\highleak.dat")]

annotate = [" (no banditry)", " (banditry)"]
plotsl = []
for j in 1:2
    trim = collect(1:10:5000)
    groups = [collect(1:4);collect(6:9)]
    lab = ifelse(j == 1, "(e)", "(d)")
    col = ifelse.(dat[j][1][:stock][trim,groups,1] .> .1, :green, :black)
    a=plot(dat[j][1][:limit][trim,groups,1], label = "", alpha = 0.1, linecolor=col, xticks = (0, ""), yticks = (0, ""),
     xlab = string("Time", annotate[j]), ylab = "MAH", ylim = (0, 6.1),
     title = lab, titlelocation = :left, titlefontsize = 15)
    for i in 1:40
        col = ifelse.(dat[j][i][:stock][trim,groups,1] .> .1, :green, :black)
        plot!(dat[j][i][:limit][trim,groups,1], label = "", alpha = 0.1, c=col)
    end

    hline!([3.5, 3.5], c = :red, label = "")
    push!(plotsl, a)
end




