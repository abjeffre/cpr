##############################################################
###################### LEVELS OF SELECTION ###################

function GetContextualSelection(data, x, X)
    out = []
        df=data
        ngroups=size(df[X])[2]
        nrounds = size(df[X])[1]
        dat = DataFrame(p = mean(Float64.(df[x][2,:,1].-df[x][1,:,1])),
                            X = var(Float64.(df[X][1,:,1])),
                            x = mean([var(Float64.(df[x][1,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])
            )
    
        for i in 2:(nrounds-1)
            temp = DataFrame(p = mean(Float64.(df[x][i+1,:,1].-df[x][i,:,1])),
                        X = var(Float64.(df[X][i,:,1])),
                        x = mean([var(Float64.(df[x][i,Int.(df[:gid][:,1,1]) .== j,1])) for j in 1:ngroups])    )
                append!(dat, temp)
            end
        return(dat)
end


ngroups = 20
out = []
for i in collect(0.01:.1:.99)
   
     a=cpr_abm(ngroups = ngroups, n = 30*ngroups,  
        lattice = [1,ngroups], wages = .01, punish_cost = .1,
        price = 3.99, outgroup = i, nrounds = 1000,
        max_forest = 30*ngroups*1333,
        tech = 0.00002,
        genetic_evolution = false,
        invasion = true,
        experiment_punish2 = 0,
        leak = false,
        experiment_group = collect(1:1:ngroups),
        control_learning = true,
        back_leak = true,
        full_save = true,
        seized_on = false,
        fidelity = 0.1,
        limit_seed_override = collect(range(start = .1, stop = 4, length =20)))
    push!(out, a)
end

above = []
below = []
for i in 1:length(out)
    dat=GetContextualSelection(out[i], :effortfull, :effort)
    ########################################################
    ################### ABOVE THE MSY ######################

    ind=findall(vec(mean(out[i][:stock][2:800,:,1], dims =2)) .> .5) 
    dat2 = dat[ind, :]
    context_above=lm(@formula(p ~ x + X), dat2)
    #dat2.x=dat2.x-dat2.X
    push!(above, coef(lm(@formula(p ~ x + X), dat2))[2:3])

    ########################################################
    ################# BELOW THE MSY ########################


    ind=findall(vec(mean(out[i][:stock][2:end,:,1], dims =2)) .< .5) 
    dat2 = dat[ind, :]
    context_below=lm(@formula(p ~ x + X), dat2)
    #dat2.x=dat2.x-dat2.X
    price_below=lm(@formula(p ~ x + X), dat2)
    push!(below, coef(lm(@formula(p ~ x + X), dat2))[2:3])
end

bx = [below[i][1] for i in 1:10]
bX = [below[i][2] for i in 1:10 ]
ax = [above[i][1] for i in 1:10]
aX = [above[i][2] for i in 1:10 ]
using Plots
plot(bx, label = "")
plot!(bX, label = "")
plot!(ax, label = "")
plot!(aX, label = "")