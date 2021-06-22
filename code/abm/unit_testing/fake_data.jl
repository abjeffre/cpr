versioninfo()
    
    #All trait minus effort
    n = 300
    nrounds = 500
    nsim = 2
    sim =3
    ngroups = 2
    gs_init = convert(Int64, n/ngroups)
    ngoods = 2
    K = ones(ngroups).*7500
    kmax = K.+1000
    year =1
    mortality_rate = .05
    fidelity = .02
    


    temp = ones(ngoods)
    temp[1] = 100-ngoods
    effort = rand(Dirichlet(temp), n)'
    effort=DataFrame(Matrix(effort), :auto)

    traits = DataFrame(
      leakage_type = rand(0:1, n),
      punish_type = rand(n),
      punish_type2 = rand(n),
      fines1 = rand(n),
      fines2 = rand(n),
      harv_limit = rand(n),
      og_type = rand(n))


    agents = DataFrame(
      id = collect(1:n),
      gid = repeat(1:ngroups, gs_init),
      payoff = rand(n),
      payoff_round = rand(n),
      age = sample(18:19, n, replace=true) #notice a small variation in age is necessary for our motrality risk measure
      )
    traitTypes = ["binary" "prob" "prob" "positivecont" "positivecont" "positivecont" "prob"]

    gmean = AnalyticWeights(rand(ngroups))
    out = rand(n)
    glearn_strat = false

    k = ones(ngroups)*7500