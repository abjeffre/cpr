

######################################################
################ PLOT ###############################

@everywhere include("C:/Users/jeffr/Documents/Work/cpr/code/analyitic/secondary_leakage.jl")

@everywhere function hu(x)
        c = .002
        price =.5
        q = 0.0044
        cₜ = .0001
        beta = .5
        s1, h1, r1, pf1, s2, h2, r2, pf2, pp, ind, pars, m=profitMax_SL(β=[beta, beta], q= q, c=c, p =[price,price], T = 2000, cₜ = cₜ, e₂ = x, full_output = true)
        effort, leakage =OAE_leakage(h1, h2, price, c, cₜ, pars)
    return effort, leakage
end



S=collect(0:.055:.55)
out=pmap(hu, S[:])

out2 = zeros(length(out), 2)
for i in 1:length(out)
    out2[i,:].=out[i]
end
secondary_leakage = plot(out2, ylim = (0, 1), axis = nothing, ylab = "Trait value", 
xlab = "Primary leakage", left_margin = 4mm, label = "", title = " ", titlefontsize = 10, l = [:solid :dash], c = [:black :grey])
annotate!(3, .5, text("e", :black, :right, 8))
annotate!(6.5, .5, text("ζ", :black, :right, 8))
