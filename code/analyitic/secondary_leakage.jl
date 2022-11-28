#####################################
############ MAXIMIZE ###############
@everywhere include("analyitic.jl")


# Determine the OAE for each amount of leakage
@everywhere function getOAE_Leakage(h1, h2, p, c, l, cₜ, pars)
    effort=collect(0:.01:1)
    revenue=((h1+h2)*p)[findall(x->x .==l, pars[:,2])]
    cost = (c+l*cₜ)*effort
    oae=findfirst((revenue - cost) .< 0)
    return oae
end

@everywhere function OAE_leakage(h1, h2, price, c, cₜ, pars)
    # Find which one has the highest payoff
    oae = []
    for i in 0:.01:1
        push!(oae,getOAE_Leakage(h1, h2, price, c, i, cₜ, pars))
    end

    effort =findmax(oae)[1]/100
    leakage = collect(0:.01:1)[findmax(oae)[2]]
    return effort, leakage
end


@everywhere function profitMax_SL(;
    eRange = 0.00:0.01:1,
    lRange = 0.00:0.01:1,
    p = [1,1],       # price
    c = .001,      # harvesting Cost
    ρ = .1,      # Discount factor
    α = .5,      # elasticity on labor
    β = [.5, .5],      # elasticity on forest - we can make two forests
    q = .01,     # Tech
    r = 0.01,    # regrowth 
    B = 1,       # Starting forest
    K = 1,       # Carrying Capacity
    e₂ = .01,    # Effort from the other group
    cₜ = .00001, # travel cost
    T = 100,
    full_output = false
    )
    revenue₁ = []
    revenue₂ = []
    stock₁ = []
    stock₂ = []   
    harvest₁  = []
    harvest₂  = []
    profitf₁ = []
    profitf₂ = []
    profit = []
    pars = zeros(length(collect(eRange))^2, 2)
    profit_m = zeros(length(collect(eRange)), length(collect(lRange)))
    cnt = 1
    cnt3 = 1 
    # Generate data for secodnary group which is assumed to be in equalibrium
    s, h, pr, pf, em, sm = profitMax(p = p[2], c = c, ρ = ρ, α = α, β = β[2], q = q, r = r, B = 1,  K = 1, e₂ = .0, T = T, full_output=true)
    a=getOAE(h, p[1], c)
    a=length(a) == 0 ? 1 : a
    s=length(a) == 0 ? s[end] : s[a]
    
    for e in collect(eRange)
        cnt2 = 1 
        for l in collect(lRange)
            eₜ=fill(e, T)
            lₜ=fill(l, T)
            t = collect(1:T)
            B₁, R₁, H₁=cpr_projection( p = p[1], c = c, α = α, β = β[1], q = q, r = r, B = B, K = K, e₁ = e.*(1 -l), e₂ = e₂, T = T)
            # FIRST WE ASSUME THAT THE OTHER GROUP IS AT THEIR OAE! 
            B₂, R₂, H₂=cpr_projection( p = p[2], c = c, α = α, β = β[2], q = q, r = r, B = B, K = K, e₁ = l*e, e₂ =a/100 , T = T) 
            rev₁ = p[1]*harvest.(q, eₜ.*(1 .-lₜ), α, B₁, β[1])
            rev₂ = p[2]*harvest.(q, eₜ.*(lₜ),     α, B₂, β[2])
            ℜ=sum(ρ.^t.*(rev₁ .+ rev₂ .- c.*(1 .-eₜ) .- cₜ.*lₜ.*eₜ))
            pars[cnt, 1] = e
            pars[cnt, 2] = l
            push!(revenue₁, rev₁)
            push!(stock₁, B₁[T])
            push!(harvest₁, H₁[T])
            push!(profitf₁, R₁[T])
            push!(revenue₂, rev₂)
            push!(stock₂, B₂[T])
            push!(harvest₂, H₂[T])
            push!(profitf₂, R₂[T])
            push!(profit, ℜ)
            profit_m[cnt3, cnt2] = rev₁[T] + rev₂[T] - c*(1-e) - cₜ*l.*e
            cnt += 1
            cnt2 +=1
            #println(cnt)
        end
        cnt3 += 1
    end
    argsₘₐₓ=pars[findmax(profit)[2], :]    
    #Bₘₐₓ, R=cpr(p = p, c = c, ρ = ρ, α = α, β = β, q = q,  
    # r = r,   B = B,  K = K,  e = eₘₐₓ, T=T)
    if full_output == false return argsₘₐₓ end #Bₘₐₓ
    if full_output == true  return  stock₁,  harvest₁, revenue₁, profitf₁, stock₂,  harvest₂, revenue₂, profitf₂, profit, argsₘₐₓ, pars, profit_m end
end