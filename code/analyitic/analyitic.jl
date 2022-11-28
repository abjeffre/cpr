
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

function regrow(B, r, K, H₁, H₂)
    B+r*B*(1-B/K)-H₁-H₂
end

function payoff(p, H, c, e)
    #println(p)
    #println(H)
    #println(c)
    #println(e)
    p*H-c*e
end


# Get open access equilibrium
# This only uses model output for h
function getOAE(h, p, c)
    effort=collect(0:.01:1)
    revenue=h*p
    cost = c*effort
    oae=findfirst((revenue - cost) .< 0)
    return oae
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

#################################
##### PROJECTED PROFITS #########

# This functon gets the estimated future profits for a fixed value of e₁
# This is used to plug into the maximization function

function cpr_projection(;
    p = 1,       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = .5,      # elasticity on forest
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    e₁ = .01,      # Effort
    e₂ = 0.01,       # Effort from leakage
    T = T
    )
    HistoryBⁿ = []
    Historyℜⁿ = []
    HistoryHⁿ = []
    Bⁿ = copy(B)
    for i in 1:T
        H₁ = harvest(q, e₁, α, Bⁿ, β)
        H₂ = harvest(q, e₂, α, Bⁿ, β)
        ℜⁿ = payoff(p, H₁, c, e₁)
        Bⁿ = regrow(Bⁿ, r, K, H₁, H₂)
        Bⁿ = Bⁿ < 0 ? 0 : Bⁿ
        push!(HistoryBⁿ, Bⁿ)
        push!(Historyℜⁿ, ℜⁿ)
        push!(HistoryHⁿ, H₁)
    end
    return HistoryBⁿ, Historyℜⁿ, HistoryHⁿ
end


#####################################
############ MAXIMIZE ###############


function profitMax(;
    eRange = 0.00:0.01:1,
    p = 1,       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = .5,      # elasticity on forest
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    e₂ = .01,    # Effort from the other group
    T = 100,
    full_output = false
    )
    profitᴾ = []
    stock = []
    harvestᴾ  = []
    profitᶠ = [] 
    for eᵖ in collect(eRange)
        eₜ=fill(eᵖ, T)
        t = collect(1:T)
        Bₜ, R, Hᴾ=cpr_projection( p = p, c = c, α = α, β = β, q = q, r = r, B = B, K = K, e₁ = eᵖ, e₂ = e₂, T = T) 
        ℜᵖ=sum(ρ.^t.*(p*harvest.(q, eₜ, α, Bₜ, β) .- c.*eₜ))
        push!(profitᴾ, ℜᵖ)
        push!(stock, Bₜ[T])
        push!(harvestᴾ, Hᴾ[T])
        push!(profitᶠ, R[T])
    end
    eₘₐₓ=eRange[findmax(profitᴾ)[2]]    
    Bₘₐₓ=stock[findmax(profitᴾ)[2]]   
    # r = r,   B = B,  K = K,  e = eₘₐₓ, T=T)
    if full_output == false return eₘₐₓ end #Bₘₐₓ
    if full_output == true  return  stock,  harvestᴾ, profitᴾ, profitᶠ, eₘₐₓ, Bₘₐₓ end
end



function cpr_adaptive_updating(;
    p = [1,1],       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = .5,      # elasticity on forest
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    T = 1000,
    e₂ = 1,
    pmaxT = 100,
    eRange = [0.00:0.01:1, 0.00:0.01:1]  # the upper limit acts as the constriant on labor
    )
    HistoryB    = []
    Historyℜ    = []
    Historye₁   = []
    Historye₂   = []
    HistoryH₁    = []
    HistoryH₂    = []
    for i in 1:T
        e₁,  = profitMax(p = p[1], c = c, ρ = ρ, α = α,  β = β, q =  q, r = r, B = B, K = K, e₂ = e₂,  T = pmaxT,  eRange = eRange[1])
        e₂ = profitMax(p = p[2], c = c, ρ = ρ, α = α,  β = β, q =  q, r = r, B = B, K = K, e₂ = e₁,  T = pmaxT,  eRange  = eRange[2]) 
        H₁ = harvest(q, e₁, α, B, β)
        H₂ = harvest(q, e₂, α, B, β)
        ℜ = payoff(p[1], H₁, c, e₁)
        B = regrow(B, r, K, H₁, H₂)
        B = B < 0 ? 0 : B
        push!(HistoryB, B)
        push!(Historyℜ, ℜ)
        push!(Historye₁, e₁)
        push!(Historye₂, e₂)
        push!(HistoryH₁, H₁)
        push!(HistoryH₂, H₂)
    end
    return HistoryB, Historyℜ, Historye₁, Historye₂,  HistoryH₁, HistoryH₂
end

