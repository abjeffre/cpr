
# Equations
function harvest(q, e, α, B, β) 
       q*(e^α)*B^β
end

function regrow(B, r, K, H)
    B+r*B*(1-B/K)-H
end

function payoff(p, H, c, e)
    p*H-c*e
end

function cpr(;
    p = 1,       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = .5,      # elasticity on forest
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    e = .01,      # Effort,
    T = 1000
    )
    HistoryB = []
    Historyℜ = []
    for i in 1:T
        H = harvest(q, e, α, B, β)
        ℜ = payoff(p, H, c, e)
        B = regrow(B, r, K, H)
        B = B < 0 ? 0 : B
        push!(HistoryB, B)
        push!(Historyℜ, ℜ)
    end
    return HistoryB, Historyℜ
end


# Determine maximization
function profitMax(;
    eRange = 0.001:0.001:1,
    p = 1,
    c = .001,
    ρ = .1,
    α = .5,
    β = .5,
    q = .01,  
    r = 0.01,
    B = 1,
    K = 1,
    T=T
    )
    profit = []
    for e in collect(eRange)
        eₜ=fill(e, T)
        t = collect(1:T)
        Bₜ, R=cpr(p = p, c = c, ρ = ρ, α = α, β = β, q = q,  
            r = r,   B = B,  K = K,  e = e, T=T)
        ℜ=sum(ρ.^t.*(p*harvest.(q, eₜ, α, Bₜ, β) .- c.*eₜ))
        push!(profit, ℜ)
    end
    eₘₐₓ=eRange[findmax(profit)[2]]    
    Bₘₐₓ, R=cpr(p = p, c = c, ρ = ρ, α = α, β = β, q = q,  
    r = r,   B = B,  K = K,  e = eₘₐₓ, T=T)
    return eₘₐₓ, Bₘₐₓ
end


profit, stock =profitMax(c=0.01, ρ = .001)

plot(stock, ylim = (0, 1))