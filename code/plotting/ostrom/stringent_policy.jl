########################################################################################
########################## Stringent Policies ##########################################
using Serialization
if RUN  == true
    out = []
    seq = collect(.1:.2:10)
    for i in seq
        b=cpr_abm(n = 30*2,
        max_forest = 2*30*1333,
        ngroups =2,
        nsim = 10,
        nrounds = 1000,
        tech = 0.000002,
        lattice = [1,2], 
        pun1_on = false,
        labor = 1,
        pun2_on = true,
        wages = 1,
        price = 3,
        defensibility = 1,
        fines1_on = false,
        fines2_on = false, 
        seized_on = true,
        invasion = true, 
        travel_cost = 4,
        full_save = true, 
        experiment_limit = i,
        experiment_punish2 = 1)
        push!(out, b)
    end
    serialize("CPR\\data\\abm\\stringent_policies.dat", out)
end

# Load 
 out=deserialize("CPR\\data\\abm\\stringent_policies.dat")
# Plot
stringent=[mean(out[i][:leakage][1:1000,1,:]) for i in 1:length(out)]
stringent=plot(stringent, c = :black, label = false, xlab = "Policy Stringency",
 xtick = ((1, length(stringent)), ("Low MAH", "High MAH")), ylab = "Banditry",
 title = "(b)", titlelocation = :left, titlefontsize = 15, ylim = (0, 1), grid = false)
 savefig("stringent_policy.pdf")