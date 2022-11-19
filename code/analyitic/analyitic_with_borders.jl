
borders=function(;r = .5, # strarting bandits
    s = 1, # Starting forest stock
    x = .5, # Starting border patrols 
    k = 1,  # carrying capacity
    α =.1, # effect of eco-system health on theft
    β =.1, # loss of bandits due to internal competition and patrols
    γ = .1, # Growth in borders due to siezures
    ζ = .1, # Loss of border patrol due to competition over resources
    ω =.01, # Loss of forest due to harvesting    
    ι = .01, # regrowth rate  
    t= 1000
    )
    hists = []
    histr = []
    histx = []
            
    for i in 1:t
        #Record history
        push!(histr, r)
        push!(hists, s)
        push!(histx, x)  
        # Payoff by consumer type
        Δr =  α*s*r - β*r*x
        Δx =  γ*r*x*s -ζ*x
        Δs =  ι*s*(1-s) - ω*s*r
        Δs = isnan(Δs) ? 0 : Δs
        Δr = isnan(Δr) ? 0 : Δr
        Δx = isnan(Δx) ? 0 : Δx  
        #update
        r=copy(r+Δr)
        s=copy(s+Δs)
        x=copy(x+Δx)
        x=x > 1 ? 1 : x
        x=x < 0 ? 0.01 : x
        r=r > 1 ? 1 : r
        r=r < 0 ? 0.01 : r
        s=s > 1 ? 1 : s
        s=s < 0 ? 0 : s
    end
    out = Dict(:s =>Float16.(hists),
    :r =>Float16.(histr),
    :x =>Float16.(histx))
    return(out)
end #end function




# Equations
function harvest(q, e, α, B, β) 
       q*(e^α)*B^β
end

function regrow(B, r, K, H₁, H₂)
    B+r*B*(1-B/K)-H₁-H₂
end

function payoff(p, H, c, e)
    p*H-c*e
end


function cpr_borders(;
    p = 1,       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = .5,      # elasticity on forest
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    e₁ = .01,      # Effort for locals
    e₂ = .01,       # Effort for non-locals
    x =  0.5,       # Effort 
    ϕ = .1,     # effect of eco-system health on theft
    ζ = .1, # Loss of border patrol due to competition over resources
    ι =.1, # loss of bandits due to internal competition and patrols
    γ = .1, # Growth in borders due to siezures
    T = 1000
    )
    HistoryB    = []
    Historyℜ    = []
    Historye₂   = []
    Historyx    = []
    HistoryH₁    = []
    HistoryH₂    = []
    for i in 1:T
        H₁ = harvest(q, e₁, α, B, β)
        H₂ = harvest(q, e₂, α, B, β)
        ℜ = payoff(p, H₁, c, e₁)
        #println("price = $p, harvest = $H₁,  cost = $c, effort =$e₁, profit = $ℜ")
        Δe₂ =  ϕ*H₂*e₂ - ι*x*(1-B)*e₂
        Δx =  γ*H₂*x - ζ*x
        #Δe₂ =  ϕ*H₂ - ι*x
        #Δx =  γ*e₂ - ζ*x 
        B = regrow(B, r, K, H₁, H₂)
        B = B < 0 ? 0 : B
        Δe₂ = isnan(Δe₂) ? 0 : Δe₂
        Δx = isnan(Δx) ? 0 : Δx
        x=copy(x+Δx)
        e₂=copy(e₂+Δe₂)
        x=x > 1 ? 1 : x
        x=x < 0 ? 0.01 : x
        e₂=e₂ > 1 ? 1 : e₂
        e₂=e₂ < 0 ? 0.01 : e₂  
        push!(HistoryB, B)
        push!(Historyℜ, ℜ)
        push!(Historye₂, e₂)
        push!(Historyx, x)
        push!(HistoryH₁, H₁)
        push!(HistoryH₂, H₂)
    end
    return HistoryB, Historyℜ, Historye₂, Historyx, HistoryH₁, HistoryH₂
end


B, R, E, X, H1, H2 =cpr_borders(q = .03, ζ=.01, γ = 12.5, c=1, p=100, r = .04, ϕ = .2, ι = .2, T = 10000, e₁=.01)

plot(plot(B, title = "Stock", ylim = (0,1)),
plot(R, title = "Profits", ylim = (0, 1)),
plot(E, title = "Theft",ylim = (0, 1)),
plot(X, title = "Border Patorl", ylim = (0,1)),
plot(H1, title = "H1"),
#plot(H2, title = "H2")
)


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
    e₂ = .01,
    T = T
    )
    HistoryBⁿ = []
    Historyℜⁿ = []
    Bⁿ=copy(B)
    for i in 1:T
        H₁ = harvest(q, e₁, α, Bⁿ, β)
        H₂ = harvest(q, e₂, α, Bⁿ, β)
        ℜⁿ = payoff(p, H₁, c, e₁)
        Bⁿ = regrow(Bⁿ, r, K, H₁, H₂)
        Bⁿ = Bⁿ < 0 ? 0 : Bⁿ
        push!(HistoryBⁿ, Bⁿ)
        push!(Historyℜⁿ, ℜⁿ)
    end
    return HistoryBⁿ, Historyℜⁿ
end


#########################################
####### Determine maximization ##########

function profitMax(;
    eRange = 0.01:0.01:1,
    p = 1,       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = .5,      # elasticity on forest
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    e₂ = .01,       # Effort for NON FOCAL GROUP!
    T = 100
    )
    profitᴾ = []
    for eᵖ in collect(eRange)
        eₜ=fill(eᵖ, T)
        t = collect(1:T)
        Bₜ, R=cpr_projection( p = p, c = c, α = α, β = β, q = q, r = r, B = B, K = K, e₁ = eᵖ, e₂ = e₂, T = T) 
        ℜᵖ=sum(ρ.^t.*(p*harvest.(q, eₜ, α, Bₜ, β) .- c.*eₜ))
        push!(profitᴾ, ℜᵖ)
    end
    eₘₐₓ=eRange[findmax(profitᴾ)[2]]    
    #Bₘₐₓ, R=cpr(p = p, c = c, ρ = ρ, α = α, β = β, q = q,  
    # r = r,   B = B,  K = K,  e = eₘₐₓ, T=T)
    return eₘₐₓ #Bₘₐₓ
end

###############################################################################
########## NOTE THIS GETS PROFIT MAXIMZATION FOR THE SECOND AGENT ############
function profitMax2(;
    eRange = 0.01:0.01:1,
    p = 1,       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = .5,      # elasticity on forest
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    e₂ = .01,       # Effort for NON FOCAL GROUP!
    T = 100,
    x = .5,
    ι = 1
    )
    profitᴾ = []
    for eᵖ in collect(eRange)
        eₜ=fill(eᵖ, T)
        t = collect(1:T)
        Bₜ, R=cpr_projection( p = p, c = c, α = α, β = β, q = q, r = r, B = B, K = K, e₁ = eᵖ, e₂ = e₂, T = T) 
        ℜᵖ=sum(ρ.^t.*((ι.*(1 .-x)).*p*harvest.(q, eₜ, α, Bₜ, β) .- c.*eₜ))
        push!(profitᴾ, ℜᵖ)
    end
    eₘₐₓ=eRange[findmax(profitᴾ)[2]]    
    #Bₘₐₓ, R=cpr(p = p, c = c, ρ = ρ, α = α, β = β, q = q,  
    # r = r,   B = B,  K = K,  e = eₘₐₓ, T=T)
    return eₘₐₓ #Bₘₐₓ
end


profitMax2()
#######################################################
############# PLUG MAXIMIZATION BACK INTO MODEL #######


function cpr_borders_adaptive_updating(;
    p = 1,       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = .5,      # elasticity on forest
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    e₂ = .01,       # Effort for non-locals at initalization
    x =  0.5,       # Effort 
    ζ = .1, # Loss of border patrol due to competition over resources
    ι =.1, # loss of bandits due to internal competition and patrols
    γ = .1, # Growth in borders due to siezures
    T = 1000
    )
    HistoryB    = []
    Historyℜ    = []
    Historye₁   = []
    Historye₂   = []
    Historyx    = []
    HistoryH₁    = []
    HistoryH₂    = []
    for i in 1:T
        e₁ = profitMax(p = p, c = c, ρ = ρ, α = α,  β = β, q =  q, r = r, B = B, K = K, e₂ = e₂,  T = 100)
        e₂ = profitMax2(p = p, c = c, ρ = ρ, α = α,  β = β, q =  q, r = r, B = B, K = K, e₂ = e₁, x =x, ι =ι,  T = 100)
        H₁ = harvest(q, e₁, α, B, β)
        H₂ = harvest(q, e₂, α, B, β)
        ℜ = payoff(p, H₁, c, e₁)
        #println("price = $p, harvest = $H₁,  cost = $c, effort =$e₁, profit = $ℜ")
        Δx =  γ*ι*H₂ - ζ*x
        #Δe₂ =  ϕ*H₂ - ι*x
        #Δx =  γ*e₂ - ζ*x 
        B = regrow(B, r, K, H₁, H₂)
        B = B < 0 ? 0 : B
        Δx = isnan(Δx) ? 0 : Δx
        x=copy(x+Δx)
        x=x > 1 ? 1 : x
        x=x < 0 ? 0.01 : x
        e₂=e₂ > 1 ? 1 : e₂
        e₂=e₂ < 0 ? 0.01 : e₂  
        push!(HistoryB, B)
        push!(Historyℜ, ℜ)
        push!(Historye₁, e₁)
        push!(Historye₂, e₂)
        push!(Historyx, x)
        push!(HistoryH₁, H₁)
        push!(HistoryH₂, H₂)
    end
    return HistoryB, Historyℜ, Historye₁, Historye₂, Historyx, HistoryH₁, HistoryH₂
end



B, R, E₁, E₂, X, H₁, H₂ = cpr_borders_adaptive_updating(q = .005, c=.5, p=100, r = .020, γ =15, ρ = 1, ι = 1, T = 2000, e₂=.01)
plot(plot(B, title = "Stock", ylim = (0,1)),
plot(R, title = "Profits", ylim = (0, 1)),
plot(X, title = "Border Patorl", ylim = (0,1)),
plot(E₁, title = "Effort local", ylim = (0,1)),
plot(E₂, title = "Effort non-local",ylim = (0, 1))
#plot(H₁, title = "Effort local", ylim = (0,1)),
#plot(H₂, title = "Effort non-local",ylim = (0, 1))
)


