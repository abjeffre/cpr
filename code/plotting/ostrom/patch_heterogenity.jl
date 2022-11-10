########################################################################################
########################## HETEROGENITY IN PATCH SIZE ##################################



seq = collect(105000:20000:(105000*6))

if RUN  == true
    out = []
    for i in seq
        b=cpr_abm(n = 75*2, max_forest = 2*105000, ngroups =2, nsim = 1, nrounds = 1000,
        lattice = [1,2], pun1_on = false, pun2_on = false, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true, 
        labor = .7, zero = true, travel_cost = 0.1, full_save = true, kmax_data = [i, 105000])
        push!(out, b)
    end
    dat=serialize("CPR\\data\\abm\\patch_heterogenity.dat", out)
end

# Load 
out=deserialize("CPR\\data\\abm\\patch_heterogenity.dat")

seq = collect(1:1:length(out))
# Plot
leakage=[mean(out[i][:leakage][:,2,1]) for i in 1:length(out)]
heterogenity=plot(seq, leakage, label = false, xlab = "Heterogenity in patch size",
 ylab = "Roving Banditry", c = :black, title = "(a)", titlelocation = :left, titlefontsize = 15)
xticks!([minimum(seq), maximum(seq)], ["Low", "High"], ylim = (0, 1))
