#########################
######### DAMAGE ########

stock1 = []
payoff1 = []
effort1 = []

for i in 30:10:300
    a = cpr_abm(pun1_on = false, pun2_on= false, tech = 0.000001, leak = false,
    labor = 1, wages = 4, degrade = 1, nrounds = 1000, n = i)
    push!(payoff1, median(a[:payoffR][500:end,:,1]))
    push!(effort1, mean(a[:effort][500:end,:,1]))
    push!(stock1, median(a[:stock][500:end,:,1]))
end

function normalize(x)
    (x)./ (maximum(x))
end

damage=plot(payoff, label = "congestion = 0", w = 2, xlab = "Leakage", ylim = (0, 15), c = "#125c2c",
 xaxis=nothing, yaxis = nothing, grid = false, ylab= "Payoff", left_margin = 20px)


###################################################
########### DAMAGE WITH CONGESTION ################

stock = []
payoff = []
effort = []


for j in .1:.2:1
    s = []
    p = []
    e = []
    
    for i in 30:10:300
        a = cpr_abm(pun1_on = false, pun2_on= false, tech = 0.000001, leak = false,
        labor = 1, wages = 4, degrade = 1, nrounds = 1000, n = i, congestion = j)
        push!(p, median(a[:payoffR][500:end,:,1]))
        push!(e, mean(a[:effort][500:end,:,1]))
        push!(s, median(a[:stock][500:end,:,1]))
    end
    push!(stock, s)
    push!(effort, e)
    push!(payoff, p)

end


congestion=plot(15.5 .-payoff1, label = "congestion = none", w = 2, xlab = "Leakage", ylim = (0, 15), c = "#ea5545",
 xaxis=nothing, yaxis = nothing, grid = false, ylab= "Damage", left_margin = 20px, legend = :bottomright)
plot!(15.5 .-payoff[1], w =2, label = "congestion = low", c= "#ef9b20" )
plot!(15.5 .-payoff[3], w =2, label = "congetsion = med", c = "#ede15b")
plot!(15.5 .-payoff[5], w= 2, label = "congetsion = high", c = "#87bc45")
vline!([14], ls = :dash, c = :red, label = "OAE")


