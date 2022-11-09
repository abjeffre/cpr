########################################################################################
########################## HETEROGENITY IN PATCH SIZE ##################################



seq = collect((105000):20000:(105000*6))

if RUN  == true
    out = []
    for i in seq
        b=cpr_abm(n = 75*2, max_forest = 2*105000, ngroups =2, nsim = 1, nrounds = 500,
        lattice = [1,2], harvest_limit = 3.5, regrow = .01, pun1_on = false, pun2_on = false, wages = 0.007742636826811269,
        price = 1, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true, labor = .7, zero = true,
        travel_cost = 0.15, full_save = true, kmax_data = [i, 210000],
        learn_group_policy = true)
        push!(out, b)
    end
    serialize("CPR\\data\\abm\\patch_heterogenity.dat", out)
end

# Load 
out=deserialize("CPR\\data\\abm\\patch_heterogenity.dat")

# Plot
het=[mean(out[i][:leakage][:,2,1]) for i in 1:length(out)]
heterogenity=plot(seq, het, label = false, xlab = "Heterogenity in patch size",
ylab = "Roving Banditry", c = :black,
title = "(a)", titlelocation = :left, titlefontsize = 15)
xticks!([minimum(seq), maximum(seq)], ["Low", "High"])

