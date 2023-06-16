######################################################################################
########################### 100 GROUPS ##############################################

if run == true
    @everywhere function g(x)
        ngroups = 100
        n= 30
        cpr_abm(degrade = 1,
         n=n*ngroups,
         ngroups = ngroups,
         lattice = [1,ngroups],
         max_forest = 1333*n*ngroups,
         tech = .00002,
         wages = 1,
         price = 3,
         nrounds = 15000,
         leak = false,
         learn_group_policy =false,
         invasion = true,
         nsim = 1, 
         experiment_group = collect(1:ngroups),
         control_learning = true,
         back_leak = true,
         outgroup = x,
         full_save = true,
         genetic_evolution = false,
         #glearn_strat = "income",
         limit_seed_override = collect(range(start = .1, stop = 4, length =ngroups)))
    end

    # Run Sweep
    cnt = 1
    base_folder = "outgroup_sweeps"
    for i in [0.01, 0.1, 0.2, 0.3, 0.4, 0.5]
        S = fill(i, 50)
        out=pmap(g, S)
        dirname = string("$base_folder/ngroups100_outgroup",i)
        mkdir(dirname)
        save(string("$dirname/output.jld2"), "out", out)
        out = nothing
    end


    # Run Sweep
    cnt = 1
    base_folder = "outgroup_sweeps"
    for i in [0.6, 0.7, 0.8, 0.9, 1.0]
        S = fill(i, 50)
        out=pmap(g, S)
        dirname = string("$base_folder/ngroups100_outgroup",i)
        mkdir(dirname)
        save(string("$dirname/output.jld2"), "out", out)
        out = nothing
    end


    # Extract Data
    Stock = []
    Punish1 = []
    Punish2 = []
    Limit = []
    Payoff = []
    base_folder = "outgroup_sweeps"
    for dir in readdir(base_folder)
        dat=load(string("$base_folder/$dir/output.jld2"))
        println(dir)
        ST=[mean(dat["out"][i][:stock][14500:15000,:,1]) for i in 1:50]
        P1=[mean(dat["out"][i][:punish][14500:15000,:,1]) for i in 1:50]
        P2=[mean(dat["out"][i][:punish2][14500:15000,:,1]) for i in 1:50]
        L=[mean(convert.(Float64,dat["out"][i][:limit][14500:15000,:,1])) for i in 1:50]
        P=[mean(convert.(Float64,dat["out"][i][:payoffR][14500:15000,:,1])) for i in 1:50]        
        push!(Stock, ST)
        push!(Limit, L)
        push!(Punish1, P1)
        push!(Payoff, P)
        push!(Punish2, P2)
    end
    STOCK=[mean(mean(Stock[i])) for i in 1:11]
    LIMIT=[mean(mean(Limit[i])) for i in 1:11]
    REGULATE=[mean(mean(Punish2[i])) for i in 1:11]
    PAYOFF=[mean(mean(Payoff[i])) for i in 1:11]

    # Save Data
    save("stock_outgroup.jld2", "out", STOCK)
    save("limit_outgroup.jld2", "out", LIMIT)
    save("regulate_outgroup.jld2", "out", REGULATE)
    save("payoff_outgroup.jld2", "out", PAYOFF)
end

    # 
    STO=load("Y:/eco_andrews/Projects/CPR/data/stock_outgroup.jld2")
    LIM=load("Y:/eco_andrews/Projects/CPR/data/limit_outgroup.jld2")
    REG=load("Y:/eco_andrews/Projects/CPR/data/regulate_outgroup.jld2")
    Outgroup=plot([0.01, .1, .2, .3, .4, .5], REG["out"], label = "", xlab = "Out-group learning",
    title = "(i)", titlelocation = :left, titlefontsize = 15,
     ylim = (0,1), c = :Black, 3, ylab = "Regulate", grid = false)  
    # plot!([0.01, .1, .2, .3, .4, .5], LIM["out"]/5.1, label = "", c = :Black)