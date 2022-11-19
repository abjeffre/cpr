n = 100
e  = rand(n)
μ = .05
q = .01
K = 10000
α = .5
β = .5
r = .01
B = copy(K)
p = 1
c = 1
nrounds = 1000
nₘ = 50

using StatsBase
using Statistics
using Distributions
# Equations
function harvest(q, e, α, B, β) 
    q*(e^α)*B^β
end

function regrow(B, r, K, H)
 B+r*B*(1-B/K)-H
end

function payoff(p, H, c, e)
 p*H+c*(1-e)
end

function logit(p)
    log(p/(1-p))
end


function inv_logit(a)
    exp(a)/(1+exp(a))
end


function learn(e, ℜ, nₘ)
    for i in 1:n
        inds=collect(1:n)[1:end .!= i]
        models=wsample(inds, AnalyticWeights(ℜ[inds]), nₘ)
        top_model = models[findmax(ℜ[models])[2]]
        e[i]= ℜ[top_model] > ℜ[i] ? e[top_model] : e[i]
    end
    return e
end

function mutate(e, μ, n)
    mutant=rand(n) .< μ 
    temp=inv_logit.(logit.(e).*rand(Normal(1, .1), n))
    temp[isnan.(temp)] = rand(0:1, sum(isnan.(temp)))
    e=ifelse.(mutant, temp, e)
    return e 
end


function abm(;
    n = 100,
    e  = rand(n),
    μ = .05,
    q = .01,
    K = 10000,
    α = .5,
    β = .5,
    r = .01,
    p = 1,
    c = 1,
    nrounds = 1000,
    nₘ = 50)
    B = copy(K)
    histe = []
    histB = []
    for i in 1:nrounds
        H = harvest.(q, e, α, B, β) 
        B = regrow(B, r, K, sum(H))
        ℜ = payoff.(p, H, c, e)
        e = learn(e, ℜ, nₘ)
        e = mutate(e, μ, n)   
        B =  B < 0 ? .01 : B
        push!(histe, e)
        push!(histB, B)
    end 
    return histe, histB
end

e0, b0=abm(nrounds = 10000, n = 100)

B1=[mean(b0[i]) for i in 1:length(b0)]
E=[mean(e0[i]) for i in 1:length(b0)]

using Plots 

plot(plot(E), plot(B1, ylim = (0, 10000)))


e0, b0=abm(nrounds = 10000, n = 110)

B1=[mean(b0[i]) for i in 1:length(b0)]
E=[mean(e0[i]) for i in 1:length(b0)]

using Plots 

plot(plot(E), plot(B1, ylim = (0, 10000)))
