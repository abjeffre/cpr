########################################################
# DO NOT CHANGE THIS MODEL BECAUSE IT IS PERFECTION ####

Perfection =cpr_abm(
    ngroups = 15,
    n = 150*15,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=15000*7.5,
    nrounds = 1000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[15,1],
    var_forest = 0,
    pun1_on = true,
    pun2_on =false,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    seized_on = false,
    leak = false
)

plot(Perfection["stock"][:,:,1], legend = false, ylim=(0,1), color = :forestgreen)
plot!(Perfection["effort"][:,:,1] , legend = false, color=:goldenrod, alpha =.6)
plot!(Perfection["punish2"][:,:,1] , legend = false, color=:pink, alpha =.6)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\baseline.png")
plot!(Perfection["payoffR"][:,:,1] , legend = false, color=:firebrick, alpha =.4)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\baseline_payoff.png")
plot(Perfection["roi"][:,:,1] , legend = false, color=:blue, alpha =.4)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\baseline_roi.png")


###########


Beatutiful =cpr_abm(
    ngroups = 10,
    n = 150*10,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*10,
    nrounds = 1000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[10,1],
    var_forest = 0,
    pun1_on = false,
    pun2_on =true,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    seized_on = true,
    leak = false,
    invasion = false
)

plot(Beatutiful["stock"][:,:,1], legend = false, ylim=(0,1), color = :forestgreen)
plot!(Beatutiful["effort"][:,:,1] , legend = false, color=:goldenrod, alpha =.6)
plot!(Beatutiful["punish2"][:,:,1] , legend = false, color=:pink, alpha =.6)
plot!(Beatutiful["payoffR"][:,:,1] , legend = false, color=:firebrick, alpha =.4)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\Beatutiful_roi.png")
##
plot(Beatutiful["roi"][:,:,1] , legend = false, color=:blue, alpha =.4)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\Beatutiful_roi.png")
plot(Beatutiful["harvest"][:,:,1], legend = false, color=:purple, alpha =.6)
plot!(Beatutiful["limit"][:,:,1] , legend = false, color=:orange, alpha =.6)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\Beatutiful_harvest.png")



#################
### SAVIROR #####




death =cpr_abm(
    ngroups = 30,
    n = 150*10,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*10,
    nrounds = 1000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[30,1],
    var_forest = 0,
    pun1_on = false,
    pun2_on =true,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    seized_on = true,
    leak = false,
    invasion = true,
    og_on = true
)

# FOR WHEN YOU GET BACK = JUST ADDED OG

plot(savior["stock"][:,:,1], legend = false, ylim=(0,1), color = :forestgreen)
plot!(savior["effort"][:,:,1] , legend = false, color=:goldenrod, alpha =.6)
plot!(savior["punish2"][:,:,1] , legend = false, color=:pink, alpha =.6)
plot!(savior["payoffR"][:,:,1] , legend = false, color=:firebrick, alpha =.4)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\savior.png")

##
plot(savior["roi"][:,:,1] , legend = false, color=:blue, alpha =.4)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\savior_roi.png")

plot(savior["harvest"][:,:,1], legend = false, color=:purple, alpha =.6)
plot!(savior["limit"][:,:,1] , legend = false, color=:orange, alpha =.6)
plot!(savior["og"][:,:,1] , legend = false, color=:red, alpha =.1)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\savior_harvest.png")

######################
#########DEATH########



death =cpr_abm(
    ngroups = 30,
    n = 150*10,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*10,
    nrounds = 1000,
    nsim =1,
    regrow = .01,
    labor = .7,
    lattice =[30,1],
    var_forest = 0,
    pun1_on = false,
    pun2_on =true,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    seized_on = true,
    leak = true,
    invasion = true,
    og_on = true
)
plot(death["stock"][:,:,1], legend = false, ylim=(0,1), color = :forestgreen)
plot!(death["effort"][:,:,1] , legend = false, color=:goldenrod, alpha =.6)
plot!(death["punish2"][:,:,1] , legend = false, color=:pink, alpha =.6)
plot!(death["payoffR"][:,:,1] , legend = false, color=:firebrick, alpha =.4)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\death.png")

##
plot(death["roi"][:,:,1] , legend = false, color=:blue, alpha =.4)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\death_roi.png")

plot(death["harvest"][:,:,1], legend = false, color=:purple, alpha =.6)
plot!(death["limit"][:,:,1] , legend = false, color=:orange, alpha =.6)
plot!(death["og"][:,:,1] , legend = false, color=:red, alpha =.1)
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\death_harvest.png")
