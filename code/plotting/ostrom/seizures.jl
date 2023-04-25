########################################################################################
########################## Effect of Seizures ##########################################

if RUN  == true
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
                invasion = true, harvest_var_ind = 0.1,
                travel_cost = 0.1, full_save = true)
        end
        println("gothere")
        b=pmap(newone, L)
        push!(out3, b)
    end
    serialize("CPR\\data\\abm\\seizures.dat", out3)
end

# Load 
dat=deserialize("CPR\\data\\abm\\seizures.dat")

# Plot

seizures=plot(dat[1][1][:punish][:,:,1], labels = "", ylab = "Support for Boundaries",
 xlab = "Time (seizures)", c=:black, alpha = .1, xticks = (0, " "), ylim = (0,1),
 title = "(g)", titlelocation = :left, titlefontsize = 15)
[plot!(dat[1][i][:punish][:,:,1], labels = "", c =:black, alpha = .025) for i in 1:40]

noseizures=plot(dat[2][1][:punish][:,:,1], labels = "", ylab = "Support for Boundaries", xlab = "Time (no seizures)",
 c=:black, alpha = .1, xticks = (0, " "), ylim = (0,1),
 title = "(f)", titlelocation = :left, titlefontsize = 15)
[plot!(dat[2][i][:punish][:,:,1], labels = "", c =:black, alpha = .025) for i in 1:40]

