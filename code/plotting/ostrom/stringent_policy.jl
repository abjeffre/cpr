########################################################################################
########################## Stringent Policies ##########################################
using Serialization
if RUN  == true
    out = []
    seq = collect(.2:.3:5.5)
    for i in seq
        b=cpr_abm(n = 75*2, max_forest = 2*105000, ngroups =2, nsim = 1, nrounds = 500,
        lattice = [1,2], harvest_limit = 3.5, regrow = .01, pun1_on = false,
        pun2_on = true, wages = 0.1, harvest_var = .01,
        price = 1, defensibility = 1, fines1_on = false,
        fines2_on = false, seized_on = true, labor = .7,
        invasion = true, 
        travel_cost = 0.1, full_save = true, 
        experiment_limit = i, experiment_punish2 = 1)
        push!(out, b)
    end
    serialize("CPR\\data\\abm\\stringent_policies.dat", out)
end

# Load 
out=deserialize("CPR\\data\\abm\\stringent_policies.dat")
seq = collect(.2:.3:5.5)
# Plot
stringent=[mean(out[i][:leakage][:,1,1]) for i in 1:length(out)]
stringent=plot(5.5 .- seq, maximum(stringent).-stringent, c = :black, label = false, xlab = "Policy Stringency",
 xtick = ((minimum(seq), maximum(seq)), ("Low MAH", "High MAH")), ylab = "Roving Banditry",
 title = "(b)", titlelocation = :left, titlefontsize = 15, ylim = (0, 1))