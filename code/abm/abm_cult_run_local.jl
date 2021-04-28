using(Distributed)

Threads.nthreads()
addprocs(15)

@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)

#Load code
@everywhere cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm")
@everywhere include("cpr_setup.jl")
@everywhere include("sep_test.jl")


S =expand_grid( [900],              # Population Size
                [6, 60],            # Ngroups
                [[3, 2]],           # lattice, will be replaced below
                [.005, .015],       # Wages
                [.5, 1.5],          # Tech
                [0, 0.05],          # Necessity
                [0.07, .7],         # labor
                [0,  .9],           # Experiment_leak
                [0],                # experiment_punish
                [1],                # experiment_group
                [false],            # cmls
                [true],             # social learning
                [true],             # leakage
                [true],             # self policing
                [10000]              # max forest
                )

for i in 1:size(S)[1]
    if S[i,2].==60
        S[i,3] =[6,10]
        S[i,1] =9000
        S[i, 15]=50000
        if S[i,8] .==9
                S[i,10] =[1,2,3,4,5,6]
                S[i,11] =.9
        end
    end
end

@everywhere function g(n, ng, l, w, te, ne, lm, el, ep, eg, c, sl, lk, sp, mf)
    cpr_abm(n = n,
            nrounds = 2000,
            nsim = 1,
            ngroups = ng,
            lattice = l,
            wages = w,
            tech = te,
            necessity = ne,
            labor = lm,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_group = eg,
            cmls = c,
            social_learning = sl,
            leak = lk,
            self_policing = sp,
            max_forest = mf,
            verbose = false )
end

#Verify
check = false

if check == true
    for i = 1:2
        println(i)
        abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8],
         S[i,9], S[i,10], S[i,11], S[i,12], S[i,13], S[i,14], S[i,15])
    end
end

#For daytime
S1=S[isodd.(collect(1:128)), :]
abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12], S[:,13], S[:,14], S[:,15])

 @JLD2.save("abm_dat_econ1WS.jld2", abm_dat, S)
 @JLD2.save("abm_dat_econ1.jld2", abm_dat)

 @JLD2.load("abm_dat_econ.jld2")



S2=S[iseven.(collect(1:128)), :]

abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12], S2[:,13], S2[:,14], S2[:,15])

 @JLD2.save("abm_dat_econWS2.jld2", abm_dat, S)
 @JLD2.save("abm_dat_econ2.jld2", abm_dat)
