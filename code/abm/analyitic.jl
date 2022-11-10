# Parameters
p = 1       # price
c = .001      # harvesting Cost
ρ = .1      # Discount factor
α = .5      # elasticity on labor
β = .5      # elasticity on forest
q = .01     # Tech
r = 0.01    # regrowth 
B = 1       # Starting forest
K = 1       # Carrying Capacity
# Variables
e =  1        

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
    e = .01      # Effort
    )
    HistoryB = []
    Historyℜ = []
    for i in 1:10000
        H = harvest(q, e, α, B, β)
        ℜ = payoff(p, H, c, e)
        B = regrow(B, r, K, H)
        B = B < 0 ? 0 : B
        push!(HistoryB, B)
        push!(Historyℜ, ℜ)
    end
    return HistoryB, Historyℜ
end

B, R = cpr(e= .15)

plot(plot(B), plot(R))
